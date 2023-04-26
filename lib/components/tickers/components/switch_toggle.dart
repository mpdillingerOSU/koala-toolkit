import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';
import 'package:gaming_toolkit/components/tickers/components/toggle.dart';

import '../../../my_constants.dart';
import '../aesthetics/ticker_color_theme.dart';
import '../aesthetics/ticker_lighting_theme.dart';
import '../interactables/ticker_notification.dart';
import '../ticker.dart';

class SwitchToggle extends Toggle<bool> {
  late bool _isActive;
  final TickerColorTheme colorTheme;
  final TickerLightingTheme lightingTheme;
  final double parentProportionality;

  final void Function(bool)? onChanged;

  SwitchToggle({
    super.key,
    required super.title,
    required this.parentProportionality,
    bool startsActive = false,
    this.onChanged,
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
  }) {
    _isActive = startsActive;
  }

  @override
  bool getValue() {
    return _isActive;
  }

  @override
  State<SwitchToggle> createState() => _SwitchToggleState();
}

class _SwitchToggleState extends State<SwitchToggle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: widget.parentProportionality * 1.25,
          child: SizedBox(
            height: 35,
            width: 60,
            child: Center(
              child: TapDetector(
                child: Switch(
                  value: widget._isActive,
                  onChanged: (value) {
                    setState(() {
                      widget._isActive = value;
                      if(widget.onChanged != null){
                        widget.onChanged!(value);
                      }
                      TickerNotification().dispatch(context);
                    });
                  },
                  activeColor: widget.colorTheme.buttonBorderColor,
                  activeTrackColor: widget.colorTheme.trackColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 35 * widget.parentProportionality,
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'Sans Source Pro',
                color: widget._isActive
                    ? widget.colorTheme.primaryColor
                    : MyConstants.borderColor,
                fontSize: 22 * widget.parentProportionality,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
