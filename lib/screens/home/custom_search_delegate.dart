import 'dart:convert';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/screens/chat%20screens/chat_screen.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream:
          firestore
              .collection("users")
              .where("id", isNotEqualTo: userId)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var data = snapshot.data!.docs;
        var matchedUsers =
            data.where((doc) {
              String name = doc["name"].toString().toLowerCase();
              return name.contains(query.toLowerCase());
            }).toList();

        if (matchedUsers.isEmpty) {
          return const Center(child: MyText(text: "No users found"));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: matchedUsers.length,
          itemBuilder: (context, index) {
            var user = matchedUsers[index];
            String otherUserId = user["id"];
            String chatId = getChatId(otherUserId);
            return StreamBuilder(
              stream: firestore.collection("chats").doc(chatId).snapshots(),
              builder: (context, chatSnapshot) {
                if (!chatSnapshot.hasData) {
                  return const SizedBox();
                }
                var chatData = chatSnapshot.data!.data();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.to(
                        () => ChatScreen(
                          recieverId: user["id"],
                          recieverName: user["name"],
                          recieverFirstLetter: user["name_first_letter"],
                          recieverImage: user["image_url"],
                          blockedById: chatData?["block_by_id"],
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          (user["image_url"] != null || user["image_url"] != "")
                              ? MemoryImage(base64Decode(user["image_url"]))
                              : null,
                      child:
                          (user["image_url"] == null || user["image_url"] == "")
                              ? Center(
                                child: MyText(
                                  text: user["name_first_letter"],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              )
                              : null,
                    ),
                      tileColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                    title: MyText(text: user["name"], color: kWhiteColor),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context); // Avoid repeating the same logic twice
  }
}
