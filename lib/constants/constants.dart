import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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

// to compress the image
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
