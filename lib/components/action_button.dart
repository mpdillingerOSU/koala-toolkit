import 'package:flutter/material.dart';
import 'package:gaming_toolkit/my_constants.dart';

import 'general/tap_detector.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;

  const ActionButton({
    super.key,
    required this.onPressed,
    this.text = '',
    this.buttonColor = MyConstants.primaryColor,
    this.textColor = MyConstants.textColor,
    this.borderColor = MyConstants.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12.5),
          border: Border.all(
            color: borderColor,
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Sans Source Pro',
              color: textColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
