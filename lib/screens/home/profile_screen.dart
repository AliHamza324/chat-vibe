import 'dart:convert';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/profile_screen_controller.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:chat_vibe/widgets/my_text_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final String? name;
  final String? password;
  final String? bio;
  final String? imageUrl;
  const ProfileScreen({
    super.key,
    this.name,
    this.password,
    this.bio,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<ProfileScreenController>(ProfileScreenController());
    ctrl.nameController.text = name!;
    ctrl.passwordController.text = password!;
    ctrl.bioController.text = bio!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTransparentColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kDarkColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GetBuilder<ProfileScreenController>(
                  builder: (pCtrl) {
                    return CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 60,
                      backgroundImage:
                          pCtrl.image == null
                              ? MemoryImage(base64Decode(imageUrl.toString()))
                              : FileImage(pCtrl.image!),
                    );
                  },
                ),
                InkWell(
                  onTap: () {
                    ctrl.pickImage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 5, 101, 92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.edit, color: kWhiteColor, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MyTextFormFeild(
              labelText: "Full Name",
              controller: ctrl.nameController,
            ),

            SizedBox(height: 18),
            MyTextFormFeild(
              labelText: "Password",
              controller: ctrl.passwordController,
            ),
            SizedBox(height: 18),

            MyTextFormFeild(
              labelText: "Bio",
              controller: ctrl.bioController,
              maxLength: 100,
              maxLines: 3,
            ),
            SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ctrl.updateData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                  child: MyText(
                    text: 'Save Changes',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
