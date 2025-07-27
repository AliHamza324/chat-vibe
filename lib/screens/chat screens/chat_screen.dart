import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/chat_controller.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/screens/chat%20screens/call_picking_screen.dart';
import 'package:chat_vibe/screens/chat%20screens/chat_app_bar.dart';
import 'package:chat_vibe/screens/chat%20screens/chat_bottom_bar.dart';
import 'package:chat_vibe/screens/chat%20screens/chat_bubble.dart';
import 'package:chat_vibe/widgets/my_container.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:chat_vibe/widgets/voice_message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final String? recieverId;
  final String? recieverName;
  final String? recieverFirstLetter;
  final String? recieverImage;
  final String? blockedById;
  final String? fullPhone;
  const ChatScreen({
    super.key,
    this.recieverId,
    this.recieverName,
    this.recieverFirstLetter,
    this.blockedById,
    this.recieverImage,
    this.fullPhone,
  });
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<ChatController>(ChatController());
    final homeCtrl = Get.put<HomeController>(HomeController());
    final String recieverId = this.recieverId ?? '';
    final String recieverName = this.recieverName ?? 'Unknown user';
    final String recieverFirstLetter = this.recieverFirstLetter ?? '?';
    final String recieverImage = this.recieverImage ?? "";
    final String blockedById = this.blockedById ?? "";
    final String chatId = getChatId(recieverId);

    if (recieverId != userId) {
      homeCtrl.makeMessageSeen(chatId);
    }
    ctrl.listenMessagesAndRecordingToUpdate(chatId);
    ctrl.listenMessagesRecordingAndStatusToFetch(recieverId, chatId);
    ctrl.setupCallingBoolListener();

    return Obx(
      () =>
          (ctrl.isCalling.value != true)
              ? Scaffold(
                backgroundColor: kWhiteColor,
                appBar: ChatAppBar(
                  recieverId: recieverId,
                  recieverName: recieverName,
                  recieverFirstLetter: recieverFirstLetter,
                  recieverImage: recieverImage,
                  fullPhone: fullPhone,
                ),
                body: Stack(
                  children: [
                    Column(
                      children: [
                        StreamBuilder(
                          stream:
                              firestore
                                  .collection("chats")
                                  .doc(chatId)
                                  .collection("messages")
                                  .orderBy("time", descending: false)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: MyText(
                                  text: "Start a chat",
                                  color: kWhiteColor,
                                  fontSize: 20,
                                ),
                              );
                            }
                            bool isCached = snapshot.data!.metadata.isFromCache;
                            var messages = snapshot.data!.docs;
                            return SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 12,
                              ),
                              child: Column(
                                children: List.generate(messages.length, (
                                  index,
                                ) {
                                  var data = messages[index];
                                  Timestamp timestamp = data["time"];
                                  DateTime dateTime = timestamp.toDate();
                                  var time = DateFormat(
                                    'h:mm a',
                                  ).format(dateTime);
                                  ctrl.allMessagesIds.add(data["message_id"]);

                                  return (data["audio_url"] != "" &&
                                          data["message"] == "" &&
                                          data["image_url"] == "")
                                      ? Align(
                                        alignment:
                                            data["sender_id"] == userId
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,

                                        child: Obx(
                                          () => InkWell(
                                            onLongPress: () {
                                              ctrl.selectedMessagesIds.contains(
                                                    data["message_id"],
                                                  )
                                                  ? ctrl.selectedMessagesIds
                                                      .remove(
                                                        data["message_id"],
                                                      )
                                                  : ctrl.selectedMessagesIds
                                                      .add(data["message_id"]);

                                              ctrl.selectedMessagesSendersIds
                                                      .contains(
                                                        data["sender_id"],
                                                      )
                                                  ? null
                                                  : ctrl
                                                      .selectedMessagesSendersIds
                                                      .add(data["sender_id"]);
                                            },
                                            child: Stack(
                                              alignment:
                                                  data["sender_id"] == userId
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 6,
                                                        horizontal: 10,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        data["sender_id"] ==
                                                                userId
                                                            ? CrossAxisAlignment
                                                                .end
                                                            : CrossAxisAlignment
                                                                .start,
                                                    children: [
                                                      Card(
                                                        child: VoiceMessageWidget(
                                                          audioSource:
                                                              data["audio_url"],
                                                          backgroundColor:
                                                              data["sender_id"] ==
                                                                      userId
                                                                  ? const Color.fromARGB(
                                                                    255,
                                                                    1,
                                                                    176,
                                                                    159,
                                                                  )
                                                                  : const Color.fromARGB(
                                                                    250,
                                                                    13,
                                                                    97,
                                                                    97,
                                                                  ),
                                                          circlesColor:
                                                              data["sender_id"] ==
                                                                      userId
                                                                  ? const Color.fromARGB(
                                                                    250,
                                                                    13,
                                                                    97,
                                                                    97,
                                                                  )
                                                                  : const Color.fromARGB(
                                                                    255,
                                                                    1,
                                                                    176,
                                                                    159,
                                                                  ),
                                                          width: 250,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20,
                                                            ),
                                                        child: Obx(
                                                          () => Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              MyText(
                                                                text: time,
                                                                fontSize: 12,
                                                              ),
                                                              const SizedBox(
                                                                width: 7,
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    data["sender_id"] ==
                                                                            userId
                                                                        ? true
                                                                        : false,
                                                                child:
                                                                    ctrl.isOnline.value ==
                                                                            true
                                                                        ? Icon(
                                                                          Icons
                                                                              .done_all,
                                                                          size:
                                                                              16,
                                                                        )
                                                                        : data["seen"] ==
                                                                            true
                                                                        ? Icon(
                                                                          Icons
                                                                              .done_all,
                                                                          color:
                                                                              Colors.green,
                                                                          size:
                                                                              16,
                                                                        )
                                                                        : Icon(
                                                                          Icons
                                                                              .done,
                                                                          size:
                                                                              16,
                                                                        ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                ctrl.selectedMessagesIds
                                                        .contains(
                                                          data["message_id"],
                                                        )
                                                    ? Opacity(
                                                      opacity: 0.5,
                                                      child: MyContainer(
                                                        height:
                                                            (data["audio_url"] ==
                                                                        null ||
                                                                    data["audio_url"] ==
                                                                        "")
                                                                ? 70
                                                                : 100,
                                                        width: Get.width,
                                                        color: kSenderColor,
                                                      ),
                                                    )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      : InkWell(
                                        onLongPress: () {
                                          ctrl.selectedMessagesIds.contains(
                                                data["message_id"],
                                              )
                                              ? ctrl.selectedMessagesIds.remove(
                                                data["message_id"],
                                              )
                                              : ctrl.selectedMessagesIds.add(
                                                data["message_id"],
                                              );

                                          ctrl.selectedMessagesSendersIds
                                                  .contains(data["sender_id"])
                                              ? null
                                              : ctrl.selectedMessagesSendersIds
                                                  .add(data["sender_id"]);
                                        },
                                        onTap: () {
                                          (data["image_url"] != null &&
                                                  data["image_url"] != "")
                                              ? viewImage(
                                                data["image_url"],
                                                "",
                                                context,
                                                true,
                                              )
                                              : null;
                                        },
                                        child: Obx(
                                          () => Visibility(
                                            visible:
                                                data["deleteForMeId"] == userId
                                                    ? false
                                                    : true,
                                            child: Visibility(
                                              visible:
                                                  data["sender_id"] == userId ||
                                                  data["receiverId"] == userId,
                                              child: Stack(
                                                children: [
                                                  ChatBubble(
                                                    message:
                                                        data["message"] ?? '',
                                                    isMe:
                                                        data["sender_id"] ==
                                                        userId,
                                                    time: time,
                                                    imageUrl:
                                                        data["image_url"] ?? "",
                                                    isSeen: data["seen"],
                                                    isCached: isCached,
                                                  ),
                                                  Opacity(
                                                    opacity:
                                                        ctrl.selectedMessagesIds
                                                                .contains(
                                                                  data["message_id"],
                                                                )
                                                            ? 0.5
                                                            : 0.0,
                                                    child: MyContainer(
                                                      height:
                                                          (data["image_url"] ==
                                                                      null ||
                                                                  data["image_url"] ==
                                                                      "")
                                                              ? 70
                                                              : 170,
                                                      width: Get.width,
                                                      color: kSenderColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                }),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    (blockedById == userId || blockedById == recieverId)
                        ? Align(
                          alignment: Alignment.bottomCenter,
                          child: MyText(
                            text:
                                blockedById == userId
                                    ? "You have blocked $recieverName."
                                    : "$recieverName has blocked you.",
                          ),
                        )
                        : ChatBottomBar(
                          recieverId: recieverId,
                          recieverName: recieverName,
                          recieverFirstLetter: recieverFirstLetter,
                          recieverImage: recieverImage,
                        ),
                  ],
                ),
              )
              : CallPickingScreen(),
    );
  }
}
