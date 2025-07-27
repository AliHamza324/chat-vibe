import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/chat_controller.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatefulWidget {
  final String callId;
  final ZegoUIKitPrebuiltCallConfig config;
  const CallScreen({super.key, required this.callId, required this.config});
  @override
  State<CallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<CallScreen> {
  // These credentials are of correct_chat_vibe project not of chat_vibe in zego cloud.Be carefull.
  int appId = 86969610;
  String appSign =
      "1ef424d37824b7879f5f6fbdc213ec294a2f7dceacec9290d1ffe1c05d8b4c85";
  String currentUserName = Get.find<HomeController>().currentUserName;
  final ctrl = Get.put<ChatController>(ChatController());

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: appId,
      appSign: appSign,
      callID: widget.callId,
      userID: userId,
      userName: currentUserName,
      config: widget.config,
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (event, defaultAction) {
          ctrl.declineCall(widget.callId);
          defaultAction();
        },
      ),
    );
  }
}
