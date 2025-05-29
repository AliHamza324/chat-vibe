import 'package:chat_vibe/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/audio_player_widget.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';

class VoiceMessageView extends StatelessWidget {
  final String audioUrl;
  final Color backgroundColor;
  final Color progressBarBackgroundColor;
  final double size;
  const VoiceMessageView({
    super.key,
    required this.audioUrl,
    required this.backgroundColor,
    required this.progressBarBackgroundColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AudioPlayerWidget(
      autoLoad: true,
      audioPath: audioUrl,
      audioType: AudioType.url,
      size: size,
      progressBarHeight: 5,
      backgroundColor: backgroundColor,
      progressBarColor: kWhiteColor,
      progressBarBackgroundColor: progressBarBackgroundColor,
      iconColor: kWhiteColor,
      shapeType: PlayIconShapeType.circular,
      playerStyle: PlayerStyle.style1,
      width: 300,
      showProgressBar: true,
      showTimer: true,
      showSpeedControl: true,
    );
  }
}
