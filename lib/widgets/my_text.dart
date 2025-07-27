import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? wordSpacing;
  final double? height;
  const MyText(
      {super.key,
      this.text,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.wordSpacing,
      this.height,  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: height,
          wordSpacing: wordSpacing),
    );
  }
}
