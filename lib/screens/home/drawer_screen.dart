import 'package:chat_vibe/screens/home/home_screen.dart';
import 'package:chat_vibe/screens/home/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    final ZoomDrawerController drawerController = ZoomDrawerController();

    return ZoomDrawer(
      menuScreen: MenuScreen(),
      mainScreen: HomeScreen(
        onMenuPressed: () {
          drawerController.toggle!();
        },
      ),
      controller: drawerController,
      menuBackgroundColor: Colors.teal,
      style: DrawerStyle.defaultStyle,
      borderRadius: 24.0,
      showShadow: true,

      angle: -12.0,
      slideWidth: MediaQuery.of(context).size.width * .65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}
