import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import '../../../my_constants.dart';

class TickerSideTitle extends StatelessWidget {
  final Ticker parent;
  late final double width;
  late final double proportionality;

  TickerSideTitle({
    super.key,
    required this.parent,
  }) {
    width = parent.sideTitleWidth;
    proportionality = width / Ticker.defaultSideTitleWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: parent.contrastTitle
            ? parent.colorTheme.primaryColor
            : MyConstants.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(parent.borderRadius * .825),
          bottomLeft: Radius.circular(parent.borderRadius * .825),
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
      child: Stack(
        children: [
          Center(
            child: Text(
              parent.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Sans Source Pro',
                color: parent.contrastTitle
                    ? parent.lightingTheme.backgroundColor
                    : parent.colorTheme.primaryColor,
                fontSize: 26 * parent.proportionality,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: parent.contrastTitle
                      ? Colors.black38
                      : parent.colorTheme.primaryColor,
                  width: 3 * parent.proportionality,
                  height: parent.contrastTitle
                      ? double.infinity
                      : parent.height * .875,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
