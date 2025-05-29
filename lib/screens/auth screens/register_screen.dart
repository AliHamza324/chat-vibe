import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/auth_controller.dart';
import 'package:chat_vibe/screens/auth%20screens/login_screen.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:chat_vibe/widgets/my_text_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ctrl = Get.put<AuthController>(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: ctrl.formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    ctrl.pickImage();
                  },
                  child: GetBuilder<AuthController>(
                    builder: (authCtrl) {
                      return CircleAvatar(
                        backgroundColor: kDarkColor,
                        radius: 60,
                        backgroundImage:
                            authCtrl.image != null
                                ? FileImage(authCtrl.image!)
                                : null,
                        child:
                            authCtrl.image == null
                                ? Icon(
                                  Icons.person,
                                  size: 30,
                                  color: kWhiteColor,
                                )
                                : null,
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),
                MyTextFormFeild(
                  labelText: "Enter Name",
                  prefixIcon: Icon(Icons.person),
                  controller: ctrl.nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Enter your name";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),

                MyTextFormFeild(
                  labelText: "Enter Bio",
                  prefixIcon: Icon(Icons.description),
                  controller: ctrl.bioController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Enter your bio";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),

                MyTextFormFeild(
                  labelText: "Enter Email",
                  prefixIcon: Icon(Icons.mail_outline),
                  controller: ctrl.emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Enter your email";
                    } else if (!ctrl.emailController.text.isEmail) {
                      return "* Invalid email";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(color: kDarkColor),

                  decoration: InputDecoration(
                    iconColor: kDarkColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Enter Password",
                    prefixIcon: Icon(
                      ctrl.isVisible ? Icons.lock_open_rounded : Icons.lock,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        ctrl.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          ctrl.isVisible = !ctrl.isVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !ctrl.isVisible,
                  keyboardType: TextInputType.visiblePassword,
                  controller: ctrl.passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Enter your password";
                    } else if (ctrl.passwordController.text.length.isLowerThan(
                      6,
                    )) {
                      return "* At least 6 characters";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                MyTextFormFeild(
                  labelText: "Enter Phone Number",
                  prefixIcon: Icon(Icons.call),
                  controller: ctrl.phoneController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Enter your phone number";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    MyText(text: "Already have an account!", color: kDarkColor),
                    SizedBox(width: 7),
                    InkWell(
                      onTap: () {
                        Get.to(() => LoginScreen());
                        ctrl.passwordController.clear();
                      },
                      child: MyText(text: "Login ", color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ctrl.checkValidation();
                      ctrl.registerUser();
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
                        text: 'Register',
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
        ),
      ),
    );
  }
}
