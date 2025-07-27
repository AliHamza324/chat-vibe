import 'dart:convert';
import 'dart:io';
import 'package:chat_vibe/widgets/my_container.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

//color constants
final kWhiteColor = Colors.white;
final kBlackColor = Colors.black;
final kbgColor = const Color.fromARGB(255, 36, 45, 57);
final kDarkColor = const Color.fromARGB(255, 50, 64, 82);
final kSenderColor = const Color.fromARGB(255, 72, 73, 75);
final recierverColor = const Color.fromARGB(255, 119, 120, 121);
final kTransparentColor = Colors.transparent;

// Firebase constants
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
String userId = FirebaseAuth.instance.currentUser!.uid;

// used in........Auth Controller...... Chat Controller.......profile screen controller
compressImage(File file) async {
  final targetPath =
      '${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 40,
  );
  return File(result!.path);
}

// used in-----------Home screen-----------chat screen----------chat controller---------
String getChatId(String user2Id) {
  List<String> ids = [userId, user2Id];
  ids.sort(); // ensures same order always
  return ids.join('_');
}

// -------For..Home Screen.......Chat Screen......chat app bar......Blocked User Screen.....custom drawer----------------

viewImage(image, letter, context, isMessage) {
  showDialog(
    context: context,
    builder: (context) {
      double size = 200.0;
      return isMessage == true
          ? MyContainer(
            height: Get.height,
            width: Get.width,
            color: kWhiteColor,
            child: Image.memory(base64Decode(image)),
          )
          : Dialog(
            child: MyContainer(
              height: size,
              width: size,
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return MyContainer(
                        height: Get.height,
                        width: Get.width,
                        color: kWhiteColor,
                        child:
                            (image == null || image == "")
                                ? Center(
                                  child: MyText(
                                    text: letter,
                                    fontSize: size / 2,
                                    color: kDarkColor,
                                  ),
                                )
                                : Image.memory(base64Decode(image)),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: size,
                  backgroundImage:
                      (image != null || image != "")
                          ? MemoryImage(base64Decode(image))
                          : null,
                  child:
                      (image == null || image == "")
                          ? Center(
                            child: MyText(
                              text: letter,
                              fontSize: size / 2,
                              color: kDarkColor,
                            ),
                          )
                          : null,
                ),
              ),
            ),
          );
    },
  );
}
