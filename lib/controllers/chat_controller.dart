import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:chat_vibe/widgets/my_text_form_feild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class ChatController extends GetxController {
  @override
  void onClose() {
    recorder.closeRecorder();
    player.closePlayer();
    super.onClose();
  }

  final messageController = TextEditingController();
  final recordController = RecorderController();
  RxList selectedMessagesIds = [].obs;
  RxList allMessagesIds = [].obs;
  List selectedMessagesSendersIds = [];
  int unseenMessagesLength = 1;
  File? image;
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  final playerController = PlayerController();
  RxBool isRecording = false.obs;
  String? recordedFilePath;
  Timer? timer;
  int startValue = 0;
  RxBool isTimerOn = false.obs;
  String imageDownloadedUrl = "";
  

  Future<void> pickImage(source) async {
    var tempImage = await ImagePicker().pickImage(source: source);
    if (tempImage != null) {
      image = File(tempImage.path);
      File cImg = await compressImage(image!);
      final imageBytes = await cImg.readAsBytes();
      double sizeInMb = imageBytes.length / (1024 * 1024);
      imageDownloadedUrl = base64Encode(imageBytes);
      Get.snackbar("", sizeInMb.toString());
      update();
    }
  }

  

  Future<void> saveChat(
    receiverId,
    recieverName,
    recieverFirstLetter,
    recieverImage,
  ) async {
    var chatId = getChatId(userId!, receiverId);
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
    imageDownloadedUrl = "";
    startValue = 0;
    isRecording(false);
    isTimerOn(false);
    timer!.cancel();
    stopRecording();
    update();
  }

  String getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort(); // ensures same order always
    return ids.join('_');
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
    var chatId = getChatId(userId!, receiverId);
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
    print(unseenMessagesLength);
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
    var chatId = getChatId(userId!, receiverId);
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
    var chatId = getChatId(userId!, receiverId);
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
