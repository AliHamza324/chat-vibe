import 'dart:convert';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/call_screen_controller.dart';
import 'package:chat_vibe/controllers/chat_controller.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String recieverId;
  final String recieverName;
  final String recieverFirstLetter;
  final String recieverImage;
  final String? fullPhone;
  const ChatAppBar({
    super.key,
    required this.recieverId,
    required this.recieverName,
    required this.recieverFirstLetter,
    required this.recieverImage,
    this.fullPhone,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<ChatController>(ChatController());
    final homeCtrl = Get.put<HomeController>(HomeController());
    final callCtrl = Get.put<CallScreenController>(CallScreenController());

    return Obx(
      () => AppBar(
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios, color: kWhiteColor),
            ),
            InkWell(
              onTap: () {
                viewImage(recieverImage, recieverFirstLetter, context, false);
              },
              child: CircleAvatar(
                radius: 22,
                backgroundColor: kWhiteColor,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      recieverImage != ""
                          ? MemoryImage(base64Decode(recieverImage))
                          : null,
                  child:
                      recieverImage == ""
                          ? Center(
                            child: MyText(
                              text: recieverFirstLetter,
                              color: kDarkColor,
                            ),
                          )
                          : null,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(text: recieverName, color: kWhiteColor, fontSize: 20),

                  Row(
                    children: [
                      MyText(
                        text:
                            ctrl.isOnline.value == true
                                ? ".Online"
                              
                       : "last seen ${homeCtrl.seenFormat(ctrl.lastSeen.value )}",
                        fontSize: 13,
                        color: kWhiteColor,
                      ),
                      SizedBox(width: 7),
                      MyText(
                        text:
                            ctrl.isRecoderId.value == ""
                                ? (ctrl.isTyperId.value != "" &&
                                        ctrl.isTyperId.value != userId)
                                    ? "typing....."
                                    : ""
                                : (ctrl.isRecoderId.value != "" &&
                                    ctrl.isRecoderId.value != userId)
                                ? "recording....."
                                : "",
                        fontSize: 16,
                        color: kWhiteColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        actions: [
          ctrl.selectedMessagesIds.isNotEmpty
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (ctrl.selectedMessagesSendersIds.contains(userId) &&
                          ctrl.selectedMessagesSendersIds.length == 1 &&
                          ctrl.selectedMessagesIds.length == 1)
                      ? TextButton(
                        onPressed: () {
                          ctrl.editDialog(recieverId, context);
                        },
                        child: MyText(text: "Edit", color: kWhiteColor),
                      )
                      : SizedBox.shrink(),
                  PopupMenuButton<String>(
                    iconColor: kWhiteColor,
                    onSelected: (value) {
                      if (value == 'Delete') {
                        ctrl.deleteDialog(recieverId, context);
                      } else if (value == 'Select All') {
                        ctrl.selectAllMessages();
                      } else if (value == 'Un-Select') {
                        ctrl.unSelectAllMessages();
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                          PopupMenuItem(
                            value: 'Delete',
                            child: MyText(text: "Delete"),
                          ),
                          PopupMenuItem(
                            value: 'Select All',
                            child: MyText(text: "Select All"),
                          ),
                          PopupMenuItem(
                            value: 'Un-Select',
                            child: MyText(text: "Un-Select"),
                          ),
                        ],
                  ),
                ],
              )
              : Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(
                        callCtrl.saveCallData(
                          recieverId,
                          recieverName,
                          recieverFirstLetter,
                          recieverImage,
                          false,
                        ),
                      );
                    },
                    icon: Icon(Icons.phone, color: kWhiteColor),
                  ),
                  IconButton(
                    onPressed: () {
                      callCtrl.saveCallData(
                        recieverId,
                        recieverName,
                        recieverFirstLetter,
                        recieverImage,
                        true,
                      );
                    },
                    icon: Icon(Icons.video_call, color: kWhiteColor),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
