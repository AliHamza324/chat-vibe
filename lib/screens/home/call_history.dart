import 'dart:convert';
import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/controllers/call_screen_controller.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallHistory extends StatelessWidget {
  const CallHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<CallScreenController>(CallScreenController());
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: MyText(text: "Calls"),
        backgroundColor: kTransparentColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("calls")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: MyText(text: "No call history found"));
          }

          var callDoc = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: callDoc.length,
            itemBuilder: (context, index) {
              var data = callDoc[index];

              Timestamp timestamp = data['time'] ?? Timestamp.now();
              DateTime dateTime = timestamp.toDate();
              String time = ctrl.formatCallTimestamp(dateTime);

              if (data["callerId"] != userId && data["receiverId"] != userId) {
                return const SizedBox(); // skip irrelevant calls
              }

              return ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: (data["caller_image"] != "" ||
                          data["reciever_image"] != "")
                      ? MemoryImage(
                          base64Decode(
                            data["callerId"] == userId
                                ? data["reciever_image"]
                                : data["caller_image"],
                          ),
                        )
                      : null,
                  child: (data["caller_image"] == "" ||
                          data["reciever_image"] == "")
                      ? Center(
                          child: MyText(
                            text: data["callerId"] == userId
                                ? data["reciever_first_letter"] ?? ""
                                : data["caller_first_letter"] ?? "",
                            color: kDarkColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  data["callerId"] == userId
                      ? data["reciever_name"] ?? ""
                      : data["caller_name"] ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: data["isPickedUp"] == false ? Colors.red : Colors.black,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      data["callerId"] != userId
                          ? Icons.call_received
                          : Icons.call_made,
                      size: 16,
                      color: data["isPickedUp"] == false ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 4),
                    MyText(text: time),
                  ],
                ),
                onTap: () {
                  ctrl.saveCallData(
                    data["receiverId"],
                    data["reciever_name"],
                    data["reciever_first_letter"],
                    data["reciever_image"],
                    data["video_call"],
                  );
                },
                trailing: Icon(
                  data["video_call"] == true ? Icons.videocam : Icons.call,
                  color: Colors.teal[700],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add_call),
      ),
    );
  }
}
