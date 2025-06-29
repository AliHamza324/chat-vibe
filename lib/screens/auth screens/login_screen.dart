import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/auth_controller.dart';
import 'package:chat_vibe/screens/auth%20screens/register_screen.dart';
import 'package:chat_vibe/widgets/my_container.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:chat_vibe/widgets/my_text_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ctrl = Get.put<AuthController>(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: ctrl.formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyText(
                      text: "Login Your Account",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kDarkColor,
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
                        } else if (ctrl.passwordController.text.length
                            .isLowerThan(6)) {
                          return "* At least 6 characters";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        MyText(
                          text: "Don't have an account!",
                          color: kDarkColor,
                        ),
                        SizedBox(width: 7),
                        InkWell(
                          onTap: () {
                            Get.to(() => RegisterScreen())!.then((_) {
                              ctrl.passwordController.clear();
                            });
                          },
                          child: MyText(text: "Rigester ", color: Colors.blue),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await ctrl.checkValidation();
                          ctrl.loginUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: MyText(
                            text: "Sign In",
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
            ctrl.isLoading == true
                ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: MyContainer(
                          height: Get.height,
                          width: Get.width,
                          color: kWhiteColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 5,
                                strokeCap: StrokeCap.round,
                                backgroundColor: kbgColor,
                                color: kWhiteColor,
                              ),
                              SizedBox(height: 10),
                              MyText(
                                text: "wait for loading.......",
                                color: kbgColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
