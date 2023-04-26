import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_color_theme.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';

import '../../my_constants.dart';

abstract class Ticker extends StatefulWidget {
  static const double defaultBorderWidth = 3.75;
  static const double defaultBorderRadius = 25;
  static const double defaultTitleHeight = 42.5;
  static const double defaultSideTitleWidth = 135;
  static const TickerColorTheme defaultColorTheme = TickerColorTheme.blueSmooth;
  static const TickerLightingTheme defaultLightingTheme = TickerLightingTheme.lightTheme;

  final String title;
  final TickerColorTheme colorTheme;
  final TickerLightingTheme lightingTheme;
  final double width;
  late final double proportionality;
  late final double height;
  late final double borderWidth;
  late final double borderRadius;
  late final double titleHeight;
  late final double sideTitleWidth;
  final bool contrastTitle;
  final bool hasBorder;
  final bool hasShadow;
  late final BoxShadow boxShadow;
  late final BoxDecoration decoration;
  late final BoxDecoration popupDecoration;

  final bool hasMenu;
  final bool canDelete;
  final void Function()? onSetToDefault;
  final void Function()? onRestore;
  final void Function()? onDelete;

  Ticker({
    super.key,
    this.title = '',
    this.colorTheme = defaultColorTheme,
    required this.lightingTheme,
    required this.width,
    required double defaultWidth,
    required double defaultHeight,
    this.contrastTitle = true,
    this.hasBorder = false,
    this.hasShadow = true,
    this.hasMenu = false,
    this.canDelete = false,
    this.onSetToDefault,
    this.onRestore,
    this.onDelete,
  }) {
    proportionality = width / defaultWidth;
    height = defaultHeight * proportionality;
    borderWidth = defaultBorderWidth * proportionality;
    borderRadius = defaultBorderRadius * proportionality;
    titleHeight = defaultTitleHeight * proportionality;
    sideTitleWidth = defaultSideTitleWidth * proportionality;
    boxShadow = BoxShadow(
      color: lightingTheme.shadowColor,
      spreadRadius: 4 * proportionality,
      blurRadius: 4 * proportionality,
      offset: Offset(
        0,
        4 * proportionality,
      ),
    );
    decoration = BoxDecoration(
      color: lightingTheme.backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: hasBorder
          ? Border.all(
              color: MyConstants.borderColor,
              width: borderWidth,
            )
          : null,
      boxShadow: hasShadow ? [boxShadow] : null,
    );
    popupDecoration = BoxDecoration(
      color: lightingTheme.deepBackgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: hasBorder
          ? Border.all(
        color: MyConstants.borderColor,
        width: borderWidth,
      )
          : null,
      boxShadow: hasShadow ? [boxShadow] : null,
    );
  }
}
