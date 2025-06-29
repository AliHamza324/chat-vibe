import 'dart:convert';
import 'dart:io';
import 'package:chat_vibe/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreenController extends GetxController {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  File? image;
  String imageDownloadedUrl = "";

  Future<void> updateData() async {
    try {
      Map<String, dynamic> userData = {
        "name": nameController.text,
        "password": passwordController.text,
        "bio": bioController.text,
        "image_url": imageDownloadedUrl,
      };
      await firestore.collection("users").doc(userId).update(userData).then((
        _,
      ) {
        updateCredentialsInAuth();
        Get.showSnackbar(
          GetSnackBar(
            message: "Updated Sucessfully",
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          ),
        );
        Get.back();
      });
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.toString(),
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        ),
      );
    }
  }

  Future<void> updateCredentialsInAuth() async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(passwordController.text);
    }
  }

  Future<void> pickImage() async {
    var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (tempImage != null) {
      image = File(tempImage.path);
      File compressedImg = await compressImage(image!);
      final imageBytes = await compressedImg.readAsBytes();
      imageDownloadedUrl = base64Encode(imageBytes);
      update();
    }
  }
}
