import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';
import 'package:gaming_toolkit/user_preferences.dart';

const double _kDefaultWidth = 380;
const double _kDefaultHeight = 65;

class NameCapsule extends StatelessWidget {
  late final double width;
  late final double height;
  late final double proportionality;
  final String value;
  final void Function()? onTap;

  NameCapsule({
    super.key,
    double? width,
    double? height,
    required this.value,
    this.onTap,
  }) {
    this.width = width ?? _kDefaultWidth;
    this.height = height ?? _kDefaultHeight;
    proportionality = this.height / _kDefaultHeight;
  }

  @override
  Widget build(BuildContext context) {
    TickerLightingTheme lightingTheme = UserPreferences.getLightingTheme();
    const double borderRadius = 25;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: lightingTheme.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: lightingTheme.shadowColor,
            spreadRadius: 4 * proportionality,
            blurRadius: 4 * proportionality,
            offset: Offset(
              0,
              4 * proportionality,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 20 * proportionality,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius * .825),
                bottomLeft: Radius.circular(borderRadius * .825),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 2 * proportionality,
                  blurRadius: 2 * proportionality,
                  offset: Offset(
                    2 * proportionality,
                    0,
                  ),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Name',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: lightingTheme.backgroundColor,
                  fontSize: 26 * proportionality,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: TapDetector(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20 * proportionality,
                ),
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.lightBlue,
                    fontSize: 24 * proportionality,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
