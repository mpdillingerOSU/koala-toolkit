import 'package:flutter/material.dart';

import 'general/tap_detector.dart';

class RoundButton extends StatelessWidget {
  static const double defaultRadius = 30;
  static const double defaultBorderWidth = 3;

  final VoidCallback onPressed;
  final double radius;
  final Color buttonColor;
  final IconData icon;
  final int iconRatio;
  final Color iconColor;
  late final double proportionality;
  late final double borderWidth;
  final Color borderColor;

  RoundButton({
    super.key,
    required this.onPressed,
    this.radius = defaultRadius,
    this.buttonColor = const Color(0xFF0C8FD5),
    required this.icon,
    this.iconRatio = 60,
    this.iconColor = Colors.white,
    this.borderColor = const Color(0xFF1565C0),
  }) {
    proportionality = radius / defaultRadius;
    borderWidth = defaultBorderWidth * proportionality;
  }

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 2 * proportionality,
              blurRadius: 2 * proportionality,
              offset: Offset(
                0,
                4 * proportionality,
              ),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: buttonColor,
          child: Icon(
            icon,
            size: radius * 2 * iconRatio / 100,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
