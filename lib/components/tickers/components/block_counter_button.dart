import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import '../../general/tap_detector.dart';
import '../aesthetics/ticker_color_theme.dart';
import '../aesthetics/ticker_lighting_theme.dart';

const double _kDefaultSize = 66;
const double _kDefaultIconRatio = 75;
const double _kDefaultBorderWidth = 3;

class BlockEventButton extends _BlockButton {
  BlockEventButton({
    required super.onPressed,
    required super.icon,
    super.size,
    super.iconRatio,
    TickerColorTheme? colorTheme,
    required TickerLightingTheme lightingTheme,
    super.borderType,
  }) : super(
    iconColor: Colors.white,
    buttonColor: (colorTheme ?? Ticker.defaultColorTheme).buttonColor,
    hasShadow: false,
  );
}

class BlockCounterSubtractionButton extends _BlockCounterButton {
  BlockCounterSubtractionButton({
    required super.dependency,
    super.size,
    super.iconRatio,
    super.colorTheme,
    required super.lightingTheme,
  }) : super(
          shift: -1,
          icon: Icons.remove,
          borderType: BlockButtonBorderType.right,
        );
}

class BlockCounterAddButton extends _BlockCounterButton {
  BlockCounterAddButton({
    required super.dependency,
    super.size,
    super.iconRatio,
    super.colorTheme,
    required super.lightingTheme,
  }) : super(
          shift: 1,
          icon: Icons.add,
          borderType: BlockButtonBorderType.left,
        );
}

abstract class _BlockCounterButton extends _BlockButton {
  final Counter dependency;
  final int shift;

  _BlockCounterButton({
    required this.dependency,
    required this.shift,
    required super.icon,
    super.size,
    super.iconRatio,
    TickerColorTheme? colorTheme,
    required TickerLightingTheme lightingTheme,
    super.borderType,
  }) : super(
          onPressed: () {
            dependency.getCurrentState()?.bound(shift: shift);
          },
          iconColor: Colors.white,
          buttonColor: (colorTheme ?? Ticker.defaultColorTheme).buttonColor,
          hasShadow: false,
        );
}

class _BlockButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double? size;
  final int? iconRatio;
  final Color? buttonColor;
  final Color? iconColor;
  final BlockButtonBorderType? borderType;
  final bool? hasShadow;

  double get proportionality => size != null ? size! / _kDefaultSize : 1;
  double get borderWidth => _kDefaultBorderWidth * proportionality;

  const _BlockButton({
    required this.onPressed,
    required this.icon,
    this.size,
    this.buttonColor,
    this.iconRatio,
    this.iconColor,
    this.borderType,
    this.hasShadow,
  });

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: buttonColor ?? Ticker.defaultColorTheme.buttonColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
                borderType == BlockButtonBorderType.right ? 8.25 * proportionality : 0),
            bottomLeft: Radius.circular(
                borderType == BlockButtonBorderType.right ? 8.25 * proportionality : 0),
            topRight: Radius.circular(
                borderType == BlockButtonBorderType.left ? 8.25 * proportionality : 0),
            bottomRight: Radius.circular(
                borderType == BlockButtonBorderType.left ? 8.25 * proportionality : 0),
          ),
          boxShadow: (hasShadow ?? true)
              ? [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 2 * proportionality,
                    blurRadius: 2 * proportionality,
                    offset: Offset(
                      0,
                      4 * proportionality,
                    ),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size:
              (size ?? _kDefaultSize) * (iconRatio ?? _kDefaultIconRatio) / 100,
          color: iconColor,
        ),
      ),
    );
  }
}

enum BlockButtonBorderType {
  left,
  right,
  none;
}
