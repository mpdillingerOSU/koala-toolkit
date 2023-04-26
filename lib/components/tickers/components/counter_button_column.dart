import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import '../aesthetics/ticker_color_theme.dart';
import '../aesthetics/ticker_lighting_theme.dart';
import 'counter_button.dart';

class CounterButtonColumn extends StatelessWidget {
  static const double defaultWidth = 66;
  static const double defaultHeight = 135;

  final Counter dependency;
  late final double width;
  late final double height;
  late final double proportionality;
  final TickerColorTheme colorTheme;
  final TickerLightingTheme lightingTheme;
  final bool hasGlow;

  CounterButtonColumn.fromWidth({
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

  CounterButtonColumn.fromProportionality({
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
              borderRadius: BorderRadius.circular(50 * proportionality),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CounterButton.fromProportionality(
                  dependency: dependency,
                  shift: 1,
                  proportionality: proportionality,
                  icon: Icons.add,
                  colorTheme: colorTheme,
                  lightingTheme: lightingTheme,
                ),
                SizedBox(
                  height: 6 * proportionality,
                ),
                Container(
                  color: colorTheme.titleColor,
                  width: 48 * proportionality,
                  height: 3 * proportionality,
                ),
                SizedBox(
                  height: 6 * proportionality,
                ),
                CounterButton.fromProportionality(
                  dependency: dependency,
                  shift: -1,
                  proportionality: proportionality,
                  icon: Icons.remove,
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
