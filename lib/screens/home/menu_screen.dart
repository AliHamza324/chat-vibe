import 'dart:convert';

import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/auth_controller.dart';
import 'package:chat_vibe/screens/auth%20screens/register_screen.dart';
import 'package:chat_vibe/screens/home/blocked_user_screen.dart';
import 'package:chat_vibe/screens/home/call_history.dart';
import 'package:chat_vibe/screens/home/profile_screen.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      body: StreamBuilder(
        stream:
            firestore
                .collection("users")
                .where("id", isEqualTo: userId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          } else if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
            return Center(
              child: InkWell(
                onTap: () {
                  Get.offAll(() => RegisterScreen());
                },
                child: MyText(
                  text: "Create an account",
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            var data = snapshot.data!.docs;
            return SingleChildScrollView(
              child: Column(
                children: List.generate(data.length, (index) {
                  return Column(
                    children: [
                      SizedBox(height: 150),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                viewImage(
                                  data[index]["image_url"],
                                  data[index]["name_first_letter"],
                                  context,
                                  false,
                                );
                              },
                              child: CircleAvatar(
                                radius: 47,
                                backgroundColor: kWhiteColor,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundImage:
                                        (data[index]["image_url"] != null ||
                                                data[index]["image_url"] != "")
                                            ? MemoryImage(
                                              base64Decode(
                                                data[index]["image_url"],
                                              ),
                                            )
                                            : null,
                                    child:
                                        (data[index]["image_url"] == null ||
                                                data[index]["image_url"] == "")
                                            ? Center(
                                              child: MyText(
                                                text:
                                                    data[index]["name_first_letter"],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            )
                                            : null,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyText(
                                  text: data[index]["name"],
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.bold,
                                ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: kWhiteColor,
                                      size: 5,
                                    ),
                                    SizedBox(width: 3),
                                    MyText(
                                      text:
                                          data[index]["online"] == true
                                              ? ".online"
                                              : "offline",
                                      color: kWhiteColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // DrawerHeader(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           InkWell(
                      //             onTap: () {
                      //               viewImage(
                      //                 data[index]["image_url"],
                      //                 data[index]["name_first_letter"],
                      //                 context,
                      //                 false,
                      //               );
                      //             },
                      //             child: CircleAvatar(
                      //               radius: 40,
                      //               backgroundImage:
                      //                   (data[index]["image_url"] != null ||
                      //                           data[index]["image_url"] != "")
                      //                       ? MemoryImage(
                      //                         base64Decode(
                      //                           data[index]["image_url"],
                      //                         ),
                      //                       )
                      //                       : null,
                      //               child:
                      //                   (data[index]["image_url"] == null ||
                      //                           data[index]["image_url"] == "")
                      //                       ? Center(
                      //                         child: MyText(
                      //                           text:
                      //                               data[index]["name_first_letter"],
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 25,
                      //                         ),
                      //                       )
                      //                       : null,
                      //             ),
                      //           ),
                      //           SizedBox(width: 20),
                      //           Divider(),
                      //           Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               MyText(
                      //                 text: data[index]["name"],
                      //                 color: kWhiteColor,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //               MyText(
                      //                 text: data[index]["email"],
                      //                 color: kWhiteColor,
                      //               ),

                      //               Row(
                      //                 children: [
                      //                   Icon(
                      //                     Icons.circle,
                      //                     color: Colors.green,
                      //                     size: 5,
                      //                   ),
                      //                   SizedBox(width: 3),
                      //                   MyText(
                      //                     text:
                      //                         data[index]["online"] == true
                      //                             ? ".online"
                      //                             : "offline",
                      //                     color: Colors.green,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //       // SizedBox(height: 20),
                      //       // MyText(
                      //       //   text: data[index]["bio"],
                      //       //   color: kWhiteColor,
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 100),
                      ListTile(
                        leading: Icon(Icons.person, color: kWhiteColor),
                        title: MyText(
                          text: "Personal Info",
                          color: kWhiteColor,
                        ),
                        onTap: () {
                          Get.to(
                            () => ProfileScreen(
                              name: data[index]["name"],
                              password: data[index]["password"],
                              bio: data[index]["bio"],
                              imageUrl: data[index]["image_url"],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.lock_person, color: kWhiteColor),
                        title: MyText(
                          text: "Blocked users",
                          color: kWhiteColor,
                        ),
                        onTap: () {
                          Get.to(() => BlockedUserScreen());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.call_end, color: kWhiteColor),
                        title: MyText(text: "Call history", color: kWhiteColor),
                        onTap: () {
                          Get.to(() => CallHistory());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: kWhiteColor),
                        title: MyText(text: "Logout", color: kWhiteColor),
                        onTap: () {
                          Get.find<AuthController>().logOut();
                        },
                      ),

                      ListTile(
                        leading: Icon(Icons.person_off, color: kWhiteColor),
                        title: MyText(
                          text: "Delete Account",
                          color: kWhiteColor,
                        ),
                        onTap: () {
                          Get.find<AuthController>().deleteAccount();
                        },
                      ),
                    ],
                  );
                }),
              ),
            );
          }
        },
      ),
    );
  }
}
