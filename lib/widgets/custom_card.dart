import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCard extends StatelessWidget {
  String title;
  IconData icon;
  final VoidCallback onPressed;
  CustomCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Card(
          color: Colors.deepPurple[300],
          borderOnForeground: false,
          clipBehavior: Clip.antiAlias,
          shadowColor: Colors.black,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
