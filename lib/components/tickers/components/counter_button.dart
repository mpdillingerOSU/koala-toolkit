import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import '../../round_button.dart';
import '../aesthetics/ticker_color_theme.dart';
import '../aesthetics/ticker_lighting_theme.dart';

class CounterButton extends StatelessWidget {
  static const double defaultRadius = 23;

  final Counter dependency;
  final int shift;
  late final double radius;
  late final double proportionality;
  final TickerColorTheme colorTheme;
  final TickerLightingTheme lightingTheme;
  final IconData icon;

  CounterButton.fromRadius({
    super.key,
    required this.dependency,
    required this.shift,
    this.radius = defaultRadius,
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
    this.icon = Icons.circle,
  }) {
    proportionality = radius / defaultRadius;
  }

  CounterButton.fromProportionality({
    super.key,
    required this.dependency,
    required this.shift,
    this.proportionality = 1,
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
    this.icon = Icons.circle,
  }) {
    radius = defaultRadius * proportionality;
  }

  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onPressed: () {
        dependency.getCurrentState()?.bound(shift: shift);
      },
      icon: icon,
      radius: radius,
      iconRatio: 75,
      buttonColor: colorTheme.buttonColor,
      borderColor: colorTheme.buttonBorderColor,
    );
  }
}
