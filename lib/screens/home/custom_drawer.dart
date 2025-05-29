import 'dart:convert';

import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/auth_controller.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/screens/auth%20screens/register_screen.dart';
import 'package:chat_vibe/screens/home/blocked_user_screen.dart';
import 'package:chat_vibe/screens/home/profile_screen.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<HomeController>(HomeController());
    return Drawer(
      backgroundColor: kDarkColor,
      child: StreamBuilder(
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
                      DrawerHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    ctrl.viewImage(
                                      data[index]["image_url"],
                                      data[index]["name_first_letter"],
                                      context,
                                      false,
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        (data[index]["image_url"] != null|| data[index]["image_url"] != "")
                                            ? MemoryImage(
                                              base64Decode(
                                                data[index]["image_url"],
                                              ),
                                            )
                                            : null,
                                    child:
                                       ( data[index]["image_url"] == null || data[index]["image_url"] == "")
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
                                SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MyText(
                                      text: data[index]["name"],
                                      color: kWhiteColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    MyText(
                                      text: data[index]["email"],
                                      color: kWhiteColor,
                                    ),

                                    MyText(
                                      text:
                                          data[index]["online"] == true
                                              ? ".Online"
                                              : ".Offline",
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(),
                            MyText(
                              text: data[index]["bio"],
                              color: kWhiteColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.person, color: kWhiteColor),
                        title: MyText(
                          text: "Personal Details",
                          color: kWhiteColor,
                        ),
                        onTap: () {
                          Get.to(
                            () => ProfileScreen(
                              name: data[index]["name"],
                              email: data[index]["email"],
                              password: data[index]["password"],
                              number: data[index]["phone_number"],
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
