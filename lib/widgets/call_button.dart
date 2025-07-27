import 'package:chat_vibe/constants/constants.dart';
import 'package:flutter/material.dart';

class CallButton extends StatefulWidget {
  final Color backgroundColor;
  final IconData icon;
  const CallButton({
    super.key,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  State<CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<CallButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    callingVibration();
  }

  void callingVibration() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 1.0, end: 1.3).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(scale: animation.value, child: child);
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: widget.backgroundColor,
        child: Center(child: Icon(widget.icon, color: kWhiteColor)),
      ),
    );
  }
}
