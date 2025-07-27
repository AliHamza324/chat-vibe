import 'package:chat_vibe/controllers/my_musical_beats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMusicalBeats extends StatelessWidget {
  const MyMusicalBeats({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<MyMusicalBeatsController>(MyMusicalBeatsController());
    return Obx(
      () => Row(
        children: List.generate(ctrl.heights.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 4,
            height: ctrl.heights[index],
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }
}
