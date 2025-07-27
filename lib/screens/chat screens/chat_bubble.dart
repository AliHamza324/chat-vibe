import 'dart:convert';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/chat_controller.dart';
import 'package:chat_vibe/widgets/my_container.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isSeen;
  final bool isCached;
  final String? recieverId;
  final String time;
  final String? imageUrl;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.recieverId,
    required this.time,
    this.imageUrl,
    required this.isSeen,
    required this.isCached,
  });
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<ChatController>(ChatController());
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          (imageUrl == null || imageUrl == "")
              ? Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),

                decoration: BoxDecoration(
                  color:
                      isMe
                          ? const Color.fromARGB(255, 1, 176, 159)
                          : const Color.fromARGB(250, 13, 97, 97),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isMe ? 0 : 20),
                    bottomRight: Radius.circular(isMe ? 20 : 0),
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                  boxShadow: [BoxShadow(blurRadius: 2, offset: Offset(1, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(color: kWhiteColor, fontSize: 16),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 10,
                ),
                child: MyContainer(
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(imageUrl!)),
                  ),
                  height: 150,
                  width: 150,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isMe ? kSenderColor : recierverColor,
                    width: 3,
                  ),
                ),
              ),

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyText(text: time, fontSize: 12),
                const SizedBox(width: 7),
                Visibility(
                  visible: isMe ? true : false,

                  child:
                      ctrl.isOnline.value == true
                          ? Icon(Icons.done_all, size: 16)
                          : isSeen
                          ? Icon(Icons.done_all, color: Colors.green, size: 16)
                          : isCached == true
                          ? Icon(
                            Icons.watch_later_outlined,
                            size: 16,
                            color: Colors.grey,
                          )
                          : Icon(Icons.done, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
