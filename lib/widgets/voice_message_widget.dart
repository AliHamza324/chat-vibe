import 'package:chat_vibe/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

class VoiceMessageWidget extends StatelessWidget {
  final String audioSource;
  final Color backgroundColor;
  final Color circlesColor;
  final double width;

  const VoiceMessageWidget({
    super.key,
    required this.audioSource,
    required this.backgroundColor,
    required this.circlesColor, required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: VoiceMessageView(
        controller: VoiceController(
          audioSrc: audioSource,
          onComplete: () {},
          onPause: () {},
          onPlaying: () {},
          maxDuration: Duration(minutes: 10),
          isFile: true,
        ),
        backgroundColor: backgroundColor,
        activeSliderColor: kWhiteColor,
        innerPadding: 10.0,
        cornerRadius: 16,
        circlesColor: circlesColor,
        counterTextStyle: TextStyle(color: kWhiteColor),
      ),
    );
  }
}
