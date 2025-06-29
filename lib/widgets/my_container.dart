import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final BoxBorder? border;
  final DecorationImage? image;
  final Gradient? gradient;
  const MyContainer({
    super.key,
    this.height,
    this.width,
    this.color,
    this.borderRadius,
    this.child,
    this.border,
    this.image,
    MemoryImage? backgroundImage, this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: image,
        color: color,
        border: border,
        borderRadius: borderRadius,
        gradient: gradient,
      ),
      child: child,
    );
  }
}
