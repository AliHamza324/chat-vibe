import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/profile_screen_controller.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:chat_vibe/widgets/my_text_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final String? name;
  final String? email;
  final String? password;
  final String? number;
  final String? bio;
  final String? imageUrl;

  const ProfileScreen({
    super.key,
    this.name,
    this.email,
    this.password,
    this.number,
    this.bio,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<ProfileScreenController>(ProfileScreenController());
    ctrl.nameController.text = name!;
    ctrl.emailController.text = email!;
    ctrl.passwordController.text = password!;
    ctrl.bioController.text = bio!;
    ctrl.numberController.text = number!;

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
                    return CircleAvatar(backgroundColor: kDarkColor,
                      radius: 60,
                      backgroundImage:
                          pCtrl.image == null
                              ? NetworkImage(imageUrl.toString())
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
                      color: kDarkColor,
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
              labelText: "Email",
              controller: ctrl.emailController,
            ),
            SizedBox(height: 18),
            MyTextFormFeild(
              labelText: "Password",
              controller: ctrl.passwordController,
            ),
            SizedBox(height: 18),
            MyTextFormFeild(
              labelText: "Phone Number",
              controller: ctrl.numberController,
            ),
            SizedBox(height: 18),
            MyTextFormFeild(
              labelText: "Bio",
              controller: ctrl.bioController,

              maxLength: 80,
            ),
            SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ctrl.updateData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkColor,
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
