import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

class MyMusicalBeatsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  int beatsCount = 20;
  var heights = [].obs;
  Random random = Random();
  double randomHeight() => 10.0 + random.nextInt(40);
  Timer? animationTimer;
  void startAnimation() {
    animationTimer = Timer.periodic(Duration(milliseconds: 200), (_) {
      heights.value = List.generate(beatsCount, (_) => randomHeight());
    });
    update();
  }
}
