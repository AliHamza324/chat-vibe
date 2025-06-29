import 'dart:convert';
import 'dart:io';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/screens/auth%20screens/login_screen.dart';
import 'package:chat_vibe/screens/auth%20screens/register_screen.dart';
import 'package:chat_vibe/screens/home/drawer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isVisible = false;
  RxBool isLoading = false.obs;
  String imageDownloadedUrl = "";
  File? image;

  Future<void> checkValidation() async {
    if (formkey.currentState!.validate()) {
      return;
    } else {
      return;
    }
  }

  Future<void> registerUser() async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.showSnackbar(
          GetSnackBar(
            message: "Email and Password cannot be empty",
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          ),
        );
        return;
      }

      await firebaseAuth
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((_) {
            isLoading(true);
          });

      await saveData();
      Get.showSnackbar(
        GetSnackBar(
          message: "Registered Successfully",
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        ),
      );

      Get.to(() =>       DrawerScreen()
);
      makeUserOnline();
      isLoading(false);
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.toString(),
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.warning, color: Colors.yellow),
        ),
      );
    }
  }

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

      if (!userCredential.user!.emailVerified) {
        userCredential.user!.sendEmailVerification();
        Get.showSnackbar(
          GetSnackBar(
            message:
                "Please verify your eamil. A verification link has been sent to your email ",
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          ),
        );
      } else {
        isLoading(true);
        Get.showSnackbar(
          GetSnackBar(
            message: "Logged In Sucessfully",
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          ),
        );

        Get.to(() =>       DrawerScreen()
);
        makeUserOnline();
        isLoading(false);
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.toString(),
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.warning, color: Colors.yellow),
        ),
      );
    }
  }

  Future<void> logOut() async {
    try {
      await firebaseAuth.signOut().then((_) {
        Get.showSnackbar(
          GetSnackBar(
            message:
                '${Get.find<HomeController>().currentUserName} ${" Logged Out Sucessfully"}',
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
            icon: Icon(Icons.warning, color: Colors.yellow),
          ),
        );
        Get.offAll(() => Get.offAll(() => LoginScreen()));
      });
    } catch (e) {
      GetSnackBar(
        message: e.toString(),
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.warning, color: Colors.yellow),
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      await firestore.collection("users").doc(userId).delete().then((_) {
        firebaseAuth.currentUser!.delete();
        Get.showSnackbar(
          GetSnackBar(
            message:
                '${Get.find<HomeController>().currentUserName} ${"your acoount has been deleted Sucessfully"}',
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
            icon: Icon(Icons.warning, color: Colors.yellow),
          ),
        );
        Get.offAll(() => Get.offAll(() => RegisterScreen()));
      });
    } catch (e) {
      GetSnackBar(
        message: e.toString(),
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.warning, color: Colors.yellow),
      );
    }
  }

  Future<void> saveData() async {
    Map<String, dynamic> userData = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "bio": bioController.text,
      "image_url": imageDownloadedUrl,
      "name_first_letter": nameController.text.substring(0, 1).toUpperCase(),
      "id": userId.toString(),
      "last_seen": FieldValue.serverTimestamp(),
      "online": false,
    };
    await firestore.collection("users").doc(userId).set(userData);
  }

  Future<void> makeUserOnline() async {
    await firestore.collection("users").doc(userId).update({
      "online": true,
      "last_seen": FieldValue.serverTimestamp(),
    });
  }

  Future<void> makeUserOfline() async {
    await firestore.collection("users").doc(userId).update({
      "online": false,
      "last_seen": FieldValue.serverTimestamp(),
    });
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
