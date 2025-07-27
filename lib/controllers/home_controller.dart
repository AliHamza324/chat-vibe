import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ctrl = Get.put<AuthController>(AuthController());

class HomeController extends GetxController {
  String currentUserName = "";
  String currentUserFirstLetter = "";
  String currentUserImage = "";
  String lastSeen = "";
  bool? status;
  RxList slectedChatsIds = [].obs;
  RxList allChatIds = [].obs;
  AppLifecycleState? state;
  getCurrentUserData() async {
    var userDoc = await firestore.collection("users").doc(userId).get();
    if (userDoc.exists) {
      currentUserName = userDoc["name"].toString();
      currentUserFirstLetter = userDoc["name_first_letter"].toString();
      currentUserImage = userDoc["image_url"].toString();
      status = userDoc["online"] as bool;
      lastSeen = userDoc["last_seen"].toString();
    }
  }

  String seenFormat(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes} minutes ago';
    if (diff.inDays < 1) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  void appStatus(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      ctrl.makeUserOfline();
    } else if (state == AppLifecycleState.resumed) {
      ctrl.makeUserOnline();
    }
  }

  void checkInternetConnection() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        ctrl.makeUserOnline();
      } else {
        ctrl.makeUserOfline();
      }
    });
  }

  Future<void> selectAllChat() async {
    for (var id in allChatIds) {
      slectedChatsIds.add(id);
    }
  }

  Future<void> unSelectAllChat() async {
    slectedChatsIds.clear();
  }

  Future<void> deleteChat() async {
    for (String id in slectedChatsIds) {
      await firestore.collection("chats").doc(id).update({
        "deleteChatForMeId": userId,
      });
    }
    slectedChatsIds.clear();
  }

  Future<void> blockUser() async {
    for (String id in slectedChatsIds) {
      await firestore.collection("chats").doc(id).update({
        "block_by_id": userId,
      });
    }
    slectedChatsIds.clear();
  }

  Future<void> unBlockUser() async {
    for (String id in slectedChatsIds) {
      await firestore.collection("chats").doc(id).update({"block_by_id": ""});
    }
    slectedChatsIds.clear();
  }

  Future<List<String>> makeMessageSeen(chatId) async {
    var messageDoc =
        await firestore
            .collection("chats")
            .doc(chatId)
            .collection("messages")
            .where("seen", isEqualTo: false)
            .get();
    List<String> ids = messageDoc.docs.map((doc) => doc.id).toList();
    for (String id in ids) {
      await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(id)
          .update({"seen": true});
    }
    await firestore.collection("chats").doc(chatId).update({
      "last_message_seen": true,
    });
    return ids;
  }

  // notification setup ----------------



  
}
