// build action button widgit
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onPressed;
  final double topPadding;
  const ActionButton(
      {super.key,
      required this.text,
      required this.imagePath,
      required this.onPressed,
      required this.topPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, right: 30.0),
      child: Align(
        alignment: Alignment.topRight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath, width: 24, height: 24),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF036666),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
