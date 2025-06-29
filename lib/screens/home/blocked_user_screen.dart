import 'dart:convert';

import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/widgets/my_container.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BlockedUserScreen extends StatelessWidget {
  const BlockedUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<HomeController>(HomeController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: MyText(text: "Blocked users", color: kWhiteColor),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: kWhiteColor),
        ),
        actions: [
          Obx(
            () => Visibility(
              visible: ctrl.slectedChatsIds.isNotEmpty ? true : false,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      ctrl.unSelectAllChat();
                    },
                    child: MyText(text: "Un-Select", color: kWhiteColor),
                  ),

                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      ctrl.selectAllChat();
                    },
                    child: MyText(text: "Select All", color: kWhiteColor),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      ctrl.unBlockUser();
                    },
                    child: MyText(text: "Unblock", color: kWhiteColor),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      ctrl.deleteChat();
                    },
                    icon: Icon(Icons.delete, color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            firestore
                .collection("chats")
                .where("block_by_id", isEqualTo: userId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: MyText(text: "No blocked user exist", color: kWhiteColor),
            );
          } else {
            var blocked = snapshot.data!.docs;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: List.generate(blocked.length, (index) {
                    var data = blocked[index];
                    Timestamp timestamp = data["last_message_time"];
                    DateTime dateTime = timestamp.toDate();
                    String time = DateFormat('h:mm a').format(dateTime);
                    return Visibility(
                      visible:
                          data["deleteChatForMeId"] == userId ? false : true,
                      child: Obx(
                        () => Stack(
                          children: [
                            Opacity(
                              opacity:
                                  ctrl.slectedChatsIds.contains(data["chat_id"])
                                      ? 0.5
                                      : 0.0,
                              child: MyContainer(
                                height: 70,
                                width: Get.width,
                                color: kBlackColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onLongPress: () {
                                  ctrl.slectedChatsIds.contains(data["chat_id"])
                                      ? ctrl.slectedChatsIds.remove(
                                        data["chat_id"],
                                      )
                                      : ctrl.slectedChatsIds.add(
                                        data["chat_id"],
                                      );
                                },
                                leading: InkWell(
                                  onTap: () {
                                    viewImage(
                                      data["sender_id"] == userId
                                          ? data["reciever_image"]
                                          : data["sender_image"],

                                      data["sender_id"] == userId
                                          ? data["reciever_first_letter"]
                                          : data["sender_first_letter"],
                                      context,
                                      false,
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        (data["reciever_image"] != null|| data["reciever_image"] != "")
                                            ? MemoryImage(
                                              base64Decode(
                                                data["reciever_image"],
                                              ),
                                            )
                                            : null,
                                    child:
                                       ( data["reciever_image"] == null||data["reciever_image"] == "")
                                            ? Center(
                                              child: MyText(
                                                text:
                                                    data["reciever_first_letter"],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            )
                                            : null,
                                  ),
                                ),
                                tileColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                title: MyText(
                                  text: data["reciever_name"],
                                  color: kWhiteColor,
                                ),
                                subtitle: MyText(
                                  text: data["last_message"],
                                  color: kWhiteColor,
                                ),
                                trailing: InkWell(
                                  onTap: () {},
                                  child: MyText(text: time, color: kWhiteColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
