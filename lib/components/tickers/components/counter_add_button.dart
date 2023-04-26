import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import '../aesthetics/ticker_color_theme.dart';
import '../aesthetics/ticker_lighting_theme.dart';
import 'counter_button.dart';

class CounterAddButton extends StatelessWidget {
  static const double defaultWidth = 83;
  static const double defaultHeight = 66;

  final Counter dependency;
  late final double width;
  late final double height;
  late final double proportionality;
  final TickerColorTheme colorTheme;
  final TickerLightingTheme lightingTheme;
  final bool hasGlow;

  CounterAddButton.fromWidth({
    super.key,
    required this.dependency,
    this.width = defaultWidth,
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
    this.hasGlow = true,
  }) {
    proportionality = width / defaultWidth;
    height = defaultHeight * proportionality;
  }

  CounterAddButton.fromProportionality({
    super.key,
    required this.dependency,
    this.proportionality = 1,
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
    this.hasGlow = true,
  }) {
    width = defaultWidth * proportionality;
    height = defaultHeight * proportionality;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: hasGlow
                  ? (lightingTheme == TickerLightingTheme.lightTheme
                      ? colorTheme.lightGlowColor
                      : colorTheme.darkGlowColor)
                  : const Color(0x00FFFFFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20 * proportionality),
                bottomLeft: Radius.circular(20 * proportionality),
                topRight: Radius.circular(50 * proportionality),
                bottomRight: Radius.circular(50 * proportionality),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: colorTheme.titleColor,
                  width: 3 * proportionality,
                  height: 48 * proportionality,
                ),
                SizedBox(
                  width: 6 * proportionality,
                ),
                CounterButton.fromProportionality(
                  dependency: dependency,
                  shift: 1,
                  proportionality: proportionality,
                  icon: Icons.add,
                  colorTheme: colorTheme,
                  lightingTheme: lightingTheme,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
