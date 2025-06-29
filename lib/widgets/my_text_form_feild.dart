import 'package:chat_vibe/constants/constants.dart';
import 'package:flutter/material.dart';

class MyTextFormFeild extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final Widget? counter;
  final String? helperText;
  final String? labelText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextStyle? labelStyle;
  final BorderSide? borderSide;
  final Color? fillColor;
  final Color? textColor;
  final int? maxLength;
  final BorderRadius? borderRadius;
  final TextStyle? hintStyle;
  final bool? filled;
  final int? maxLines;
  const MyTextFormFeild({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.counter,
    this.helperText,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.labelStyle,
    this.borderSide,
    this.fillColor,
    this.borderRadius,
    this.hintStyle,
    this.filled,
    this.textColor,
    this.maxLength,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      style: TextStyle(color: kDarkColor),
      onTap: onTap,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        iconColor: kDarkColor,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderSide: borderSide ?? BorderSide(color: kDarkColor),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        hintText: hintText,
        filled: filled,
        counter: counter,
        helperText: helperText,
        labelText: labelText,
        labelStyle: labelStyle,
        hintStyle: hintStyle,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
