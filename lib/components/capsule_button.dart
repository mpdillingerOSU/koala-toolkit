import 'package:flutter/material.dart';

import 'general/tap_detector.dart';

class CapsuleButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double height;
  final void Function()? onTap;

  const CapsuleButton({
    super.key,
    required this.text,
    this.icon,
    this.height = 38,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFDFF0FF),
          borderRadius: BorderRadius.circular(50),
        ),
        child: FittedBox(
          child: Row(
            children: [
              SizedBox(
                width: height * .3,
              ),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: Colors.lightBlue,
                  fontSize: height * .5,
                ),
              ),
              icon != null
                  ? Icon(
                      icon,
                      size: height * .8,
                      color: Colors.lightBlue,
                    )
                  : const SizedBox(),
              SizedBox(
                width: height * .3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
