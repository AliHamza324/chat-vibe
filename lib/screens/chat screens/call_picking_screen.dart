import 'dart:convert';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/chat_controller.dart';
import 'package:chat_vibe/widgets/call_button.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallPickingScreen extends StatelessWidget {
  const CallPickingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<ChatController>(ChatController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 85, 84, 84),
      body: StreamBuilder(
        stream:
            firestore
                .collection('calls')
                .orderBy('time', descending: false)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          var callDoc = snapshot.data!.docs;
          return ListView.builder(
            itemCount: callDoc.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var data = callDoc[index];
              return Visibility(
                visible:
                    (data["callerId"] != userId &&
                        data["receiverId"] == userId &&
                        data["call_going"] == true),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height / 5),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(radius: 82, backgroundColor: kWhiteColor),
                        CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              data["caller_image"] != ""
                                  ? MemoryImage(
                                    base64Decode(data["caller_image"]),
                                  )
                                  : null,
                          child:
                              data["caller_image"] == ""
                                  ? Center(
                                    child: MyText(
                                      text: data["caller_first_letter"],
                                      color: kDarkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                    ),
                                  )
                                  : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    MyText(
                      text: data["caller_name"] ?? "Unknown",
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: kWhiteColor,
                    ),
                    MyText(
                      text:
                          data["video_call"] == true
                              ? "Incoming video call"
                              : "Incoming voice call",
                      fontWeight: FontWeight.bold,
                      color: kWhiteColor,
                    ),
                    SizedBox(height: Get.height / 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Draggable(
                              onDragStarted: () {
                                ctrl.declineCall(data["call_id"]);
                              },
                              feedback: CallButton(
                                backgroundColor: Colors.red,
                                icon: Icons.call_end,
                              ),
                              childWhenDragging: SizedBox.shrink(),
                              axis: Axis.vertical,
                              child: CallButton(
                                backgroundColor: Colors.red,
                                icon: Icons.call_end,
                              ),
                            ),
                            SizedBox(height: 10),
                            MyText(text: "Decline", color: kWhiteColor),
                          ],
                        ),
                        SizedBox(width: Get.width / 3),
                        Column(
                          children: [
                            Draggable(
                              onDragStarted: () {
                                ctrl.acceptCall(
                                  data["call_id"],
                                  data["video_call"],
                                );
                              },
                              feedback: CallButton(
                                backgroundColor: Colors.green,
                                icon: Icons.call,
                              ),
                              childWhenDragging: SizedBox.shrink(),
                              axis: Axis.vertical,
                              child: CallButton(
                                backgroundColor: Colors.green,
                                icon: Icons.call,
                              ),
                            ),
                            SizedBox(height: 10),
                            MyText(text: "Accept", color: kWhiteColor),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
