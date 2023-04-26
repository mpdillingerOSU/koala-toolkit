import 'package:flutter/material.dart';

class MyConstants{
  static const Color primaryColor = Color(0xFFFFFFFF);
  static const LinearGradient silverPurpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Color(0xFFFAE7FF),
      Color(0xFFF5C0FF),
    ],
  );
  static const Color borderColor = Colors.black45;
  static const Color textColor = Colors.black87;
}