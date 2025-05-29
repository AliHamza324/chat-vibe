import 'dart:convert';
import 'dart:io';
import 'package:chat_vibe/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreenController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  File? image;
  String imageDownloadedUrl = "";

  Future<void> updateData() async {
    Map<String, dynamic> userData = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "phone_number": numberController.text,
      "bio": bioController.text,
      "image_url": imageDownloadedUrl,
    };
    await firestore.collection("users").doc(userId).update(userData).then((_) {
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
  }

  Future<void> updateCredentialsInAuth() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(passwordController.text);
      }
    } catch (e) {
      Get.snackbar("Chat Vibe", e.toString());
    }
  }

  Future<void> pickImage() async {
     var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (tempImage != null) {
      image = File(tempImage.path);
      File cImg = await compressImage(image!);
      final imageBytes = await cImg.readAsBytes();
      double sizeInMb = imageBytes.length / (1024 * 1024);
      imageDownloadedUrl = base64Encode(imageBytes);
      Get.snackbar("", sizeInMb.toString());
      update();
    }
  }
}
