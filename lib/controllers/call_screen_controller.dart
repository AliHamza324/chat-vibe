import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/home_controller.dart';
import 'package:chat_vibe/screens/chat%20screens/call_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreenController extends GetxController {
  Future<void> saveCallData(
    receiverId,
    recieverName,
    recieverFirstLetter,
    recieverImage,
    bool videoCall,
  ) async {
    String callId = firestore.collection("calls").doc().id;
    Map<String, dynamic> callData = {
      "callerId": userId,
      "caller_name": Get.find<HomeController>().currentUserName,
      "caller_first_letter": Get.find<HomeController>().currentUserFirstLetter,
      "caller_image": Get.find<HomeController>().currentUserImage.toString(),
      'receiverId': receiverId,
      "reciever_name": recieverName,
      "reciever_first_letter": recieverFirstLetter,
      "reciever_image": recieverImage.toString(),
      "call_id": callId,
      "time": Timestamp.now(),
      "isPickedUp": false,
      "call_going": true,
      "video_call": videoCall,
    };
    await firestore.collection("calls").doc(callId).set(callData);

    Get.to(
      () => CallScreen(
        callId: callId,
        config:
            videoCall == true
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
      ),
    )!.then((value) {
      Future.delayed(Duration(seconds: 40), () {
        firestore.collection("calls").doc(callId).update({"call_going": false});
      });
    });
  }

  String formatCallTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // Today
      return "Today ${DateFormat('h:mm a').format(dateTime)}";
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return "Yesterday ${DateFormat('h:mm a').format(dateTime)}";
    } else if (now.difference(dateTime).inDays < 7) {
      // Same week: show day name
      return DateFormat('EEEE, h:mm a').format(dateTime);
    } else {
      // Older: show full date
      return DateFormat('MMM d, h:mm a').format(dateTime);
    }
  }
}
