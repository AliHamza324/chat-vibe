import 'dart:convert';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/chat_controller.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/screens/chat%20screens/chat_screen.dart';
import 'package:chat_vibe/screens/home/custom_search_delegate.dart';
import 'package:chat_vibe/widgets/my_container.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onMenuPressed;

  const HomeScreen({super.key, required this.onMenuPressed});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final homeCtrl = Get.put<HomeController>(HomeController());
  final ctrl = Get.put<ChatController>(ChatController());

  @override
  void initState() {
    super.initState();
    homeCtrl.getCurrentUserData();
    homeCtrl.checkInternetConnection();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    homeCtrl.appStatus(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTransparentColor,
        leading: IconButton(
          onPressed: widget.onMenuPressed,
          icon: Icon(Icons.menu),
        ),
        actions: [
          Obx(
            () =>
                homeCtrl.slectedChatsIds.isNotEmpty
                    ? Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            homeCtrl.unSelectAllChat();
                          },
                          child: MyText(text: "Un-Select", color: kWhiteColor),
                        ),
                        TextButton(
                          onPressed: () {
                            homeCtrl.selectAllChat();
                          },
                          child: MyText(text: "Select All", color: kWhiteColor),
                        ),
                        TextButton(
                          onPressed: () {
                            homeCtrl.blockUser();
                          },
                          child: MyText(text: "Block", color: kWhiteColor),
                        ),
                        IconButton(
                          onPressed: () {
                            homeCtrl.deleteChat();
                          },
                          icon: Icon(Icons.delete, color: kWhiteColor),
                        ),
                      ],
                    )
                    : IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(),
                        );
                      },
                      icon: Icon(Icons.search, color: kWhiteColor),
                    ),
          ),
        ],
      ),
      backgroundColor: Colors.teal,
      body: MyContainer(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00897B), // Teal
            Color(0xFFE0F2F1), // Light teal
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyText(
                  text: "Online users",
                  color: kWhiteColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              StreamBuilder(
                stream:
                    firestore
                        .collection("users")
                        .where("id", isNotEqualTo: userId)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox();
                  }
                  var userData = snapshot.data!.docs;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(userData.length, (index) {
                        var users = userData[index];
                        String chatId = getChatId(users["id"]);
                        return StreamBuilder(
                          stream:
                              firestore
                                  .collection("chats")
                                  .doc(chatId)
                                  .snapshots(),
                          builder: (context, chatSnapshot) {
                            if (!chatSnapshot.hasData) {
                              return SizedBox();
                            }
                            var chatData = chatSnapshot.data!.data();
                            return users["online"] == true
                                ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => ChatScreen(
                                              recieverId: users["id"],
                                              recieverName: users["name"],
                                              recieverFirstLetter:
                                                  users["name_first_letter"],
                                              recieverImage: users["image_url"],
                                              blockedById:
                                                  chatData?["block_by_id"],
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            CircleAvatar(
                                              radius: 62,
                                              backgroundColor: kWhiteColor,
                                              child: Center(
                                                child: CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage:
                                                      (users["image_url"] !=
                                                                  null ||
                                                              users["image_url"] !=
                                                                  "")
                                                          ? MemoryImage(
                                                            base64Decode(
                                                              users["image_url"],
                                                            ),
                                                          )
                                                          : null,
                                                  child:
                                                      (users["image_url"] ==
                                                                  null ||
                                                              users["image_url"] ==
                                                                  "")
                                                          ? Center(
                                                            child: MyText(
                                                              text:
                                                                  users["name_first_letter"],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25,
                                                            ),
                                                          )
                                                          : null,
                                                ),
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                      MyText(
                                        text: users["name"],
                                        color: kWhiteColor,
                                      ),
                                    ],
                                  ),
                                )
                                : SizedBox();
                          },
                        );
                      }),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              MyContainer(
                height: Get.height,
                width: Get.width,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: kWhiteColor,
                child: Column(
                  children: [
                    SizedBox(height: 6),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection("chats").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: MyText(
                              text: "No chat found",
                              color: kWhiteColor,
                            ),
                          );
                        }
                        var data = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var chatData =
                                data[index].data() as Map<String, dynamic>;
                            Timestamp timestamp = chatData["last_message_time"];
                            DateTime dateTime = timestamp.toDate();
                            String time = DateFormat('h:mm a').format(dateTime);
                            homeCtrl.allChatIds.add(chatData["chat_id"]);
                            return Obx(
                              () => Visibility(
                                visible:
                                    chatData["deleteChatForMeId"] == userId
                                        ? false
                                        : true,
                                child: Visibility(
                                  visible:
                                      chatData["sender_id"] == userId ||
                                      chatData["receiverId"] == userId,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Opacity(
                                        opacity:
                                            homeCtrl.slectedChatsIds.contains(
                                                  chatData["chat_id"],
                                                )
                                                ? 0.5
                                                : 0.0,
                                        child: MyContainer(
                                          height: 70,
                                          width: Get.width,
                                          color: Colors.teal,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: ListTile(
                                            tileColor: Colors.teal,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            onTap: () {
                                              Get.to(
                                                () => ChatScreen(
                                                  recieverId:
                                                      chatData["sender_id"] ==
                                                              userId
                                                          ? chatData["receiverId"]
                                                          : chatData["sender_id"],
                                                  recieverName:
                                                      chatData["sender_id"] ==
                                                              userId
                                                          ? chatData["reciever_name"]
                                                          : chatData["sender_name"],
                                                  recieverFirstLetter:
                                                      chatData["sender_id"] ==
                                                              userId
                                                          ? chatData["reciever_first_letter"]
                                                          : chatData["sender_first_letter"],
                                                  recieverImage:
                                                      chatData["sender_id"] ==
                                                              userId
                                                          ? chatData["reciever_image"]
                                                          : chatData["sender_image"],
                                                  blockedById:
                                                      chatData["block_by_id"],
                                                ),
                                              );
                                              if (chatData["last_message_from_id"] !=
                                                  userId) {
                                                homeCtrl.makeMessageSeen(
                                                  chatData["chat_id"],
                                                );
                                              }
                                            },
                                            onLongPress: () {
                                              homeCtrl.slectedChatsIds.contains(
                                                    chatData["chat_id"],
                                                  )
                                                  ? homeCtrl.slectedChatsIds
                                                      .remove(
                                                        chatData["chat_id"],
                                                      )
                                                  : homeCtrl.slectedChatsIds
                                                      .add(chatData["chat_id"]);
                                            },
                                            leading: InkWell(
                                              onTap: () {
                                                viewImage(
                                                  chatData["sender_id"] ==
                                                          userId
                                                      ? chatData["reciever_image"]
                                                      : chatData["sender_image"],

                                                  chatData["sender_id"] ==
                                                          userId
                                                      ? chatData["reciever_first_letter"]
                                                      : chatData["sender_first_letter"],

                                                  context,
                                                  false,
                                                );
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundImage:
                                                    (chatData["reciever_image"] !=
                                                                null ||
                                                            chatData["reciever_image"] !=
                                                                "")
                                                        ? MemoryImage(
                                                          base64Decode(
                                                            chatData["sender_id"] ==
                                                                    userId
                                                                ? chatData["reciever_image"]
                                                                : chatData["sender_image"],
                                                          ),
                                                        )
                                                        : null,
                                                child:
                                                    (chatData["reciever_image"] ==
                                                                null ||
                                                            chatData["reciever_image"] ==
                                                                "")
                                                        ? Center(
                                                          child: MyText(
                                                            text:
                                                                chatData["sender_id"] ==
                                                                        userId
                                                                    ? chatData["reciever_first_letter"]
                                                                    : chatData["sender_first_letter"],
                                                            color: kDarkColor,
                                                          ),
                                                        )
                                                        : null,
                                              ),
                                            ),

                                            title: MyText(
                                              text:
                                                  chatData["sender_id"] ==
                                                          userId
                                                      ? chatData["reciever_name"]
                                                      : chatData["sender_name"],
                                              color: kWhiteColor,
                                            ),
                                            subtitle: MyText(
                                              text: chatData["last_message"],
                                              color: kWhiteColor,
                                              fontWeight:
                                                  chatData["last_message_from_id"] ==
                                                              userId ||
                                                          chatData["last_message_seen"] ==
                                                              true
                                                      ? FontWeight.normal
                                                      : FontWeight.w900,
                                            ),
                                            trailing: Column(
                                              children: [
                                                MyText(
                                                  text: time,
                                                  color: kWhiteColor,
                                                ),
                                                MyText(
                                                  text:
                                                      chatData["block_by_id"] ==
                                                                  userId ||
                                                              chatData["block_by_id"] ==
                                                                  chatData["receiverId"]
                                                          ? "Blocked"
                                                          : "",
                                                  color: Colors.deepOrange,
                                                ),
                                                chatData["last_message_from_id"] ==
                                                            userId ||
                                                        chatData["last_message_seen"] ==
                                                            true
                                                    ? SizedBox()
                                                    : CircleAvatar(
                                                      backgroundColor:
                                                          kWhiteColor,
                                                      radius: 7,
                                                    ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
