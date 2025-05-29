import 'dart:convert';

import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/widgets/my_container.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:flutter/material.dart';


class ChatBubble extends StatelessWidget {
  final String message;
 
  final bool isMe;
  final bool isSeen;
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
  });
  @override
  Widget build(BuildContext context) {
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
                  color: isMe ? kSenderColor : recierverColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isMe ? 0 : 20),
                    bottomRight: Radius.circular(isMe ? 20 : 0),
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
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
           
              : MyContainer(
                image: DecorationImage(image: MemoryImage(base64Decode(imageUrl!))
                ),
                height: 150,
                width: 150,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isMe ? kSenderColor : recierverColor,
                  width: 3,
                ),
              ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(text: time, color: kWhiteColor, fontSize: 12),
              const SizedBox(width: 7),
              Visibility(
                visible: isMe ? true : false,
                child: StreamBuilder(
                  stream:
                      firestore
                          .collection("users")
                          .where("id", isEqualTo: recieverId)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return SizedBox();
                    } else {
                      var userData = snapshot.data!.docs[0];
                      return userData["online"] == true
                          ? Icon(Icons.done_all, color: kWhiteColor, size: 16)
                          : isSeen
                          ? Icon(Icons.done_all, color: Colors.green, size: 16)
                          : Icon(Icons.done, color: kWhiteColor, size: 16);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




