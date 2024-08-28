import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final TextStyle? labelStyle;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.labelStyle,
    this.enabledBorder,
    this.focusedBorder,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      onSubmitted: (value) {
        controller.clear();
      },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: labelStyle ?? const TextStyle(color: Colors.black),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.black),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.black),
            ),
      ),
    );
  }
}
