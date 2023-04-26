import 'package:flutter/material.dart';

class TickerLightingTheme {
  final Color deepBackgroundColor;
  final Color backgroundColor;
  final Color shadowColor;
  final Color contrastColor;
  final Color complementaryColor;
  final Color standardTextColor;

  static const TickerLightingTheme darkTheme = TickerLightingTheme._(
    deepBackgroundColor: Color(0xFF262626),
    backgroundColor: Color(0xFF3A3838),
    shadowColor: Color(0xC2000000),
    contrastColor: Color(0xFFFFFDE7),
    complementaryColor: Color(0xFFFFFDE7),
    standardTextColor: Color(0xFFFFFDE7),
  );

  static const TickerLightingTheme lightTheme = TickerLightingTheme._(
    deepBackgroundColor: Color(0xFFE7F3FF),
    backgroundColor: Color(0xFFFFFFFF),
    shadowColor: Colors.black26,
    contrastColor: Color(0xFFFFFDE7),
    complementaryColor:Color(0xFF3A3838),
    standardTextColor: Color(0xFF262626),
  );

  const TickerLightingTheme._({
    required this.deepBackgroundColor,
    required this.backgroundColor,
    required this.shadowColor,
    required this.contrastColor,
    required this.complementaryColor,
    required this.standardTextColor,
  });
}
