import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/chat_controller.dart';
import 'package:chat_vibe/widgets/my_container.dart';
import 'package:chat_vibe/widgets/my_musical_beats.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:chat_vibe/widgets/voice_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBottomBar extends StatelessWidget {
  final String recieverId;
  final String recieverName;
  final String recieverFirstLetter;
  final String recieverImage;
  const ChatBottomBar({
    super.key,
    required this.recieverId,
    required this.recieverName,
    required this.recieverFirstLetter,
    required this.recieverImage,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<ChatController>(ChatController());
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: GetBuilder<ChatController>(
              builder: (aCtrl) {
                return Visibility(
                  visible:
                      (aCtrl.image == null || aCtrl.image!.path == "")
                          ? false
                          : true,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            aCtrl.image != null
                                ? FileImage(aCtrl.image!)
                                : null,
                      ),
                      IconButton(
                        onPressed: () {
                          aCtrl.image = null;
                          aCtrl.update();
                        },
                        icon: Icon(Icons.cancel_sharp, color: kWhiteColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(
            () => MyContainer(
              height: ctrl.isRecording.value == true ? 155 : 80,
              width: Get.width,
              color:
                  ctrl.isRecording.value == true
                      ? Colors.teal
                      : kTransparentColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  (ctrl.isRecording.value == true)
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GetBuilder<ChatController>(
                            builder: (chatCtrl) {
                              return MyText(
                                text: chatCtrl.startValue.toString(),
                                color: kWhiteColor,
                                fontSize: 20,
                              );
                            },
                          ),
                          SizedBox(width: 10),
                          ctrl.isTimerOn.value == true
                              ? MyMusicalBeats()
                              : VoiceMessageWidget(
                                audioSource: ctrl.recordedFilePath,
                                backgroundColor: kbgColor,
                                circlesColor: kDarkColor,
                                width: 280,
                              ),
                        ],
                      )
                      : SizedBox(),

                  SizedBox(height: 10),
                  (ctrl.isRecording.value == true)
                      ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              ctrl.stopRecording();
                              ctrl.isRecording(false);
                              ctrl.stopTimer();
                              ctrl.startValue = 0;
                              ctrl.recordedFilePath = "";
                              ctrl.update();
                            },
                            icon: Icon(Icons.delete, color: kWhiteColor),
                          ),
                          Spacer(flex: 8),

                          ctrl.isTimerOn.value == true
                              ? IconButton(
                                onPressed: () {
                                  ctrl.pauseRecording();
                                  ctrl.stopTimer();
                                },
                                icon: Icon(
                                  Icons.pause,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              )
                              : IconButton(
                                onPressed: () {
                                  ctrl.resumeRecording();
                                  ctrl.startTimer();
                                },
                                icon: Icon(
                                  Icons.mic,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),

                          Spacer(flex: 8),

                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  ctrl.isRecording.value == true
                                      ? kbgColor
                                      : kDarkColor,
                              child: IconButton(
                                onPressed: () {
                                  if (recieverId.isNotEmpty) {
                                    ctrl.saveChat(
                                      recieverId,
                                      recieverName,
                                      recieverFirstLetter,
                                      recieverImage,
                                    );
                                  }
                                },
                                icon: Icon(Icons.send, color: kWhiteColor),
                              ),
                            ),
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: kDarkColor,
                            child: IconButton(
                              onPressed: () {
                                ctrl.getRecordingPermission().then((value) {
                                  ctrl.startRecording();
                                  ctrl.startTimer();
                                  ctrl.isRecording(true);
                                });
                              },
                              icon: Icon(Icons.mic, color: kWhiteColor),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: ctrl.messageController,
                              style: TextStyle(color: kWhiteColor),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: kWhiteColor),
                                hintText: "Type Message",
                                filled: true,
                                fillColor: kDarkColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    ctrl.showMediaPickerSheet(context);
                                  },
                                  icon: Icon(
                                    Icons.attach_file,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                ctrl.isRecording.value == true
                                    ? kbgColor
                                    : kDarkColor,
                            child: IconButton(
                              onPressed: () {
                                if (recieverId.isNotEmpty) {
                                  ctrl.saveChat(
                                    recieverId,
                                    recieverName,
                                    recieverFirstLetter,
                                    recieverImage,
                                  );
                                }
                              },
                              icon: Icon(Icons.send, color: kWhiteColor),
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
