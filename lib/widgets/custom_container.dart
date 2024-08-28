import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;

  const CustomContainer({
    super.key,
    required this.title,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(textAlign: TextAlign.center, title, style: textStyle),
      ),
    );
  }
}
