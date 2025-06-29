import 'package:chat_vibe/constants/constants.dart';
import 'package:chat_vibe/widgets/my_text.dart';
import 'package:flutter/material.dart';

class CallHistory extends StatelessWidget {
  const CallHistory({super.key});
 
  @override
  Widget build(BuildContext context) {
     final List callLogs = [
    (
      name: 'Ali Hamza',
      profileUrl: 'https://i.pravatar.cc/150?img=1',
      time: 'Today, 10:32 AM',
      isIncoming: true,
      isMissed: false,
      isVideo: true,
    ),
    (
      name: 'Fatima',
      profileUrl: 'https://i.pravatar.cc/150?img=2',
      time: 'Yesterday, 4:12 PM',
      isIncoming: false,
      isMissed: false,
      isVideo: false,
    ),
    (
      name: 'Ahmed',
      profileUrl: 'https://i.pravatar.cc/150?img=3',
      time: 'Today, 9:01 AM',
      isIncoming: true,
      isMissed: true,
      isVideo: false,
    ),
  ];
    return Scaffold(
     backgroundColor: kbgColor,
      appBar: AppBar(
        title: MyText(text: "Calls",color: kWhiteColor,),
        backgroundColor: kTransparentColor,
      ),
      body: ListView.builder(
        itemCount: callLogs.length,
        itemBuilder: (context, index) {
          final call = callLogs[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              // backgroundImage: CachedNetworkImageProvider(call.profileUrl),
            ),
            title: Text(
              call.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: call.isMissed ? Colors.red : Colors.black,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  call.isIncoming ? Icons.call_received : Icons.call_made,
                  size: 16,
                  color: call.isMissed ? Colors.red : Colors.green,
                ),
                const SizedBox(width: 4),
                Text(call.time),
              ],
            ),
            trailing: Icon(
              call.isVideo ? Icons.videocam : Icons.call,
              color: Colors.teal[700],
            ),
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


