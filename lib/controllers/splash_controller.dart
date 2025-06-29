import 'dart:async';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/screens/auth%20screens/register_screen.dart';
import 'package:chat_vibe/screens/home/drawer_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    checkUser();
    super.onInit();
  }

  Future<void> checkUser() async {
    var user = firebaseAuth.currentUser;
    Timer(Duration(seconds: 4), () {
      Get.offAll(() => user == null ? RegisterScreen() : 
      DrawerScreen()
      );
    });
    Get.put<HomeController>(HomeController()).checkInternetConnection();
  }
}
