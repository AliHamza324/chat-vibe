import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/screens/chat%20screens/call_screen.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:chat_vibe/widgets/my_text_form_feild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ChatController extends GetxController {
  @override
  void onClose() {
    recorder.closeRecorder();
    player.closePlayer();
    super.onClose();
  }

  final messageController = TextEditingController();
  RxList selectedMessagesIds = [].obs;
  RxList allMessagesIds = [].obs;
  List selectedMessagesSendersIds = [];
  int unseenMessagesLength = 1;
  File? image;
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  final playerController = PlayerController();
  RxBool isRecording = false.obs;
  String recordedFilePath = "";
  Timer? timer;
  int startValue = 0;
  RxBool isTimerOn = false.obs;
  File? compressedImg;
  String imageDownloadedUrl = "";
  RxBool isCalling = false.obs;
  Future<void> pickImage(source) async {
    var tempImage = await ImagePicker().pickImage(source: source);
    if (tempImage != null) {
      image = File(tempImage.path);
      compressedImg = await compressImage(image!);
      final imageBytes = await compressedImg!.readAsBytes();
      imageDownloadedUrl = base64Encode(imageBytes);
      update();
    }
  }

  Future<void> saveChat(
    receiverId,
    recieverName,
    recieverFirstLetter,
    recieverImage,
  ) async {
    var chatId = getChatId(receiverId);
    var messageId =
        firestore
            .collection("chats")
            .doc(chatId)
            .collection("messages")
            .doc()
            .id;
    // ignore: unnecessary_null_comparison
    if (messageController.text != "" ||
        image != null ||
        isRecording.value == true) {
      Map<String, dynamic> messageInfo = {
        "sender_id": userId,
        'receiverId': receiverId,
        "message_id": messageId,
        "message": messageController.text,
        "time": Timestamp.now(),
        "deleteForMeId": "",
        "image_url": imageDownloadedUrl,
        "audio_url": recordedFilePath ?? "",
        "seen": false,
      };
      Map<String, dynamic> chatInfo = {
        "sender_id": userId,
        "sender_name": Get.find<HomeController>().currentUserName,
        "sender_first_letter":
            Get.find<HomeController>().currentUserFirstLetter,
        "sender_image": Get.find<HomeController>().currentUserImage.toString(),
        'receiverId': receiverId,
        "reciever_name": recieverName,
        "reciever_first_letter": recieverFirstLetter,
        "reciever_image": recieverImage.toString(),
        "last_message": messageController.text,
        "last_message_time": Timestamp.now(),
        "last_message_seen": false,
        "chat_id": chatId,
        "deleteChatForMeId": "",
        "block_by_id": "",
        "last_message_from_id": userId,
        "typer_id": "",
        "recorder_id": "",
        "unseen_messages_length": unseenMessagesLength,
      };
      await firestore
          .collection("chats")
          .doc(chatId)
          .set(chatInfo, SetOptions(merge: true));
      await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .set(messageInfo);
      messageController.clear();
    }
    image = null;
    compressedImg = null;
    imageDownloadedUrl = "";
    startValue = 0;
    isRecording(false);
    isTimerOn(false);
    timer!.cancel();
    stopRecording();
    update();
  }

  // notificaton setupp
  String? callId;
  bool? videoCall;
  NotificationDetails getNotificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        category: AndroidNotificationCategory.call,
        color: Color(0xFF4CAF50),
        ticker: 'Incoming call',
        fullScreenIntent: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'DECLINE_CALL',
            'Decline',
            titleColor: Color(0xFFF44336), // Red text
            showsUserInterface: true,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            'ACCEPT_CALL',
            'Accept',
            titleColor: Color(0xFF4CAF50), // Green text
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotifications() async {
    callStream.listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            var data = change.doc.data()!;
            String callerName = data["caller_name"];
            callId = data["call_id"];
            videoCall = data["video_call"];
            // if (data["callerId"] != userId && data["receiverId"] == userId) {
            notificationPlugin.show(
              0,
              callerName,
              callId,
              // "Incoming voice call.....",
              getNotificationDetails(),
            );
            // }
          }
        }
      }
    });
  }

  Future<void> initNotifications() async {
    await Permission.notification.request();
    const initAndroidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initIosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIosSettings,
    );
    await notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final actionId = response.actionId;

        if (actionId == 'ACCEPT_CALL') {
          acceptCall(callId!, videoCall!);
        } else {
          declineCall(callId!);
        }
      },
    );
  }

  var callStream =
      firestore
          .collection('calls')
          .orderBy('time', descending: false)
          .where("call_going", isEqualTo: true)
          .snapshots();

  Future<void> declineCall(String callId) async {
    await firestore.collection('calls').doc(callId).update({
      "isPickedUp": false,
      "call_going": false,
    });
    isCalling(false);
  }

  Future<void> acceptCall(String callId, bool isVideoCall) async {
    await firestore.collection('calls').doc(callId).update({
      "isPickedUp": true,
      "call_going": true,
    });
    await Get.to(
      () => CallScreen(
        callId: callId,
        config:
            isVideoCall == true
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
      ),
    );
  }

  void setupCallingBoolListener() {
    firestore
        .collection('calls')
        .where("call_going", isEqualTo: true)
        .orderBy('time', descending: false)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            (snapshot.docs.first["callerId"] != userId &&
                    snapshot.docs.first["receiverId"] == userId)
                ? isCalling.value = snapshot.docs.first['call_going']
                : isCalling(false);
          } else {
            isCalling(false);
          }
        });
  }

  //  ----------------- For chat screen -----------------------

  Future<void> getRecordingPermission() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception("Microphone permission not granted");
    }
    await recorder.openRecorder();
    await player.openPlayer();
  }

  Future<void> startRecording() async {
    var tempDir = await getTemporaryDirectory();
    var time = Timestamp.now().millisecondsSinceEpoch;
    recordedFilePath = "${tempDir.path}/$time.aac";
    await recorder.startRecorder(toFile: recordedFilePath);
    await playerController.startPlayer();
  }

  Future<void> stopRecording() async {
    await recorder.stopRecorder();
    await playerController.stopPlayer();
  }

  Future<void> pauseRecording() async {
    await recorder.pauseRecorder();
    await playerController.pausePlayer();
  }

  Future<void> resumeRecording() async {
    await recorder.resumeRecorder();
    await playerController.startPlayer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      startValue++;
      isTimerOn(true);
      update();
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      isTimerOn(false);
      update();
    }
  }

  void listenMessagesAndRecording(chatId) {
    isRecording.listen((_) async {
      await firestore.collection("chats").doc(chatId).update({
        "recorder_id": isRecording.value == false ? "" : userId,
      });
    });
    messageController.addListener(() async {
      await firestore.collection("chats").doc(chatId).update({
        "typer_id": messageController.text.isEmpty ? "" : userId,
      });
    });
  }

  Future<void> updateMessage(receiverId) async {
    var chatId = getChatId(receiverId);
    for (String id in selectedMessagesIds) {
      await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(id)
          .update({"message": messageController.text});
    }

    messageController.clear();
    selectedMessagesIds.clear();
    selectedMessagesSendersIds.clear();
  }

  Future<void> getUnseenMessages(chatId) async {
    var messageDoc =
        await firestore
            .collection("chats")
            .doc(chatId)
            .collection("messages")
            .where("seen", isEqualTo: false)
            .get();

    unseenMessagesLength = messageDoc.docs.length + 1;
  }

  Future<void> selectAllMessages() async {
    for (String id in allMessagesIds) {
      selectedMessagesIds.add(id);
    }
  }

  Future<void> unSelectAllMessages() async {
    selectedMessagesIds.clear();
    selectedMessagesSendersIds.clear();
  }

  Future<void> deleteMessageFromMe(receiverId) async {
    var chatId = getChatId(receiverId);
    for (String id in selectedMessagesIds) {
      await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(id)
          .update({"deleteForMeId": userId});
    }
    selectedMessagesIds.clear();
    selectedMessagesSendersIds.clear();
  }

  Future<void> deleteMessageForAll(receiverId) async {
    var chatId = getChatId(receiverId);
    for (String id in selectedMessagesIds) {
      await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(id)
          .delete();
    }
    selectedMessagesIds.clear();
    selectedMessagesSendersIds.clear();
  }

  void editDialog(recieverId, context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: kDarkColor,
          child: SizedBox(
            width: 300,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "Edit Message",
                    color: kWhiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  MyTextFormFeild(
                    labelText: "Message",
                    controller: messageController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          updateMessage(recieverId);
                          Get.back();
                          selectedMessagesIds.clear();
                          selectedMessagesSendersIds.clear();
                        },
                        child: MyText(text: "Save", color: kWhiteColor),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                          selectedMessagesIds.clear();
                          selectedMessagesSendersIds.clear();
                        },
                        child: MyText(text: "Cancel", color: kWhiteColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteDialog(recieverId, context) {
    for (String id in selectedMessagesSendersIds) {
      if (id == userId && selectedMessagesSendersIds.length == 1) {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              backgroundColor: kDarkColor,
              title: MyText(text: "Delete message?", color: kWhiteColor),
              children: [
                ListTile(
                  onTap: () {
                    deleteMessageForAll(recieverId);
                    Get.back();
                  },
                  tileColor: kTransparentColor,
                  title: MyText(
                    text: "Delete for everyone",
                    color: kWhiteColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    deleteMessageFromMe(recieverId);
                  },
                  tileColor: kTransparentColor,
                  title: MyText(text: "Delete for me", color: kWhiteColor),
                ),
                ListTile(
                  onTap: () {
                    Get.back();
                  },
                  tileColor: kTransparentColor,
                  title: MyText(text: "Cancel", color: kWhiteColor),
                ),
              ],
            );
          },
        );
      } else if (id != userId && selectedMessagesSendersIds.length == 1) {
        deleteMessageFromMe(recieverId);
      } else {
        deleteMessageFromMe(recieverId);
      }
    }
    selectedMessagesSendersIds.clear();
  }

  void showMediaPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Media',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        pickImage(ImageSource.camera);
                        Get.back();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.blue),
                          MyText(text: "Camera"),
                        ],
                      ),
                    ),
                    SizedBox(width: Get.width / 6),
                    InkWell(
                      onTap: () {
                        pickImage(ImageSource.gallery);
                        Get.back();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.image, color: Colors.green),
                          MyText(text: "Gallery"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
