import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_notification.dart';

import '../../../koala_strings.dart';
import '../../general/tap_detector.dart';
import '../aesthetics/ticker_color_theme.dart';
import '../aesthetics/ticker_lighting_theme.dart';

class Counter extends StatefulWidget {
  static const double defaultWidth = 120;
  static const double defaultHeight = 44;

  late final double width;
  late final double height;
  late final double proportionality;
  final bool hasKeyboardEntry;
  final TextAlign textAlign;
  final int startingValue;
  final int lowerBound;
  final int upperBound;
  late int _value;
  CounterState? _currentState;
  Counter? _minPartner;
  Counter? _maxPartner;
  final TickerColorTheme colorTheme;
  final TickerLightingTheme lightingTheme;
  final Function(int)? onChange;
  final bool alignedBottom;

  Counter.fromWidth({
    super.key,
    this.width = defaultWidth,
    this.hasKeyboardEntry = true,
    this.textAlign = TextAlign.center,
    this.startingValue = 0,
    this.lowerBound = 0,
    this.upperBound = 100,
    Counter? minPartner,
    Counter? maxPartner,
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
    this.onChange,
    this.alignedBottom = true,
  }) {
    proportionality = width / defaultWidth;
    height = defaultHeight * proportionality;
    _value = max(lowerBound, min(startingValue, upperBound));
    _minPartner = minPartner;
    _minPartner?._maxPartner = this;
    _maxPartner = maxPartner;
    _maxPartner?._minPartner = this;
  }

  Counter.fromProportionality({
    super.key,
    this.proportionality = 1,
    this.hasKeyboardEntry = true,
    this.textAlign = TextAlign.center,
    this.startingValue = 0,
    this.lowerBound = 0,
    this.upperBound = 100,
    Counter? minPartner,
    Counter? maxPartner,
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
    this.onChange,
    this.alignedBottom = true,
  }) {
    width = defaultWidth * proportionality;
    height = defaultHeight * proportionality;
    _value = max(lowerBound, min(startingValue, upperBound));
    _minPartner = minPartner;
    _maxPartner = maxPartner;
    _minPartner = minPartner;
    _minPartner?._maxPartner = this;
    _maxPartner = maxPartner;
    _maxPartner?._minPartner = this;
  }

  int getValue() {
    return _value;
  }

  CounterState? getCurrentState() {
    return _currentState;
  }

  @override
  State<Counter> createState() => CounterState();
}

class CounterState extends State<Counter> {
  final TextEditingController _textController = TextEditingController();
  late final StreamSubscription<bool> _keyboardSubscription;
  String? _checkValue;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((isVisible) {
      if (!isVisible) {
        bound();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._currentState = this;
    _textController.text = widget._value.toString();
    _checkValue = _textController.text;
    //When "text" is reset above, then "selection" is removed, so resetting
    // "selection" here becomes necessary...
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.text.length,
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            bound();
          }
        },
        child: TapDetector(
          child: TextFormField(
            enabled: widget.hasKeyboardEntry,
            controller: _textController,
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: [
              FilteringTextInputFormatter.allow(numeric)
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: widget.alignedBottom ? EdgeInsets.zero : const EdgeInsets.fromLTRB(0, 0, 0, 5),
              isDense: true,
            ),
            textAlign: widget.textAlign,
            style: TextStyle(
              fontFamily: 'Sans Source Pro',
              color: widget.colorTheme.primaryColor,
              fontSize: 44 * widget.proportionality,
              fontWeight: FontWeight.bold,
            ),
            onTap: () {
              _textController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _textController.text.length,
              );
            },
            onFieldSubmitted: (String text) {
              bound();
            },
          ),
        ),
      ),
    );
  }

  bool _isInt() {
    return int.tryParse(_textController.text) != null;
  }

  void bound({int shift = 0}) {
    if (_checkValue != _textController.text || shift != 0) {
      _checkValue = _textController.text;
      setState(() {
        widget._value = _bounded(
                widget._minPartner == null
                    ? widget.lowerBound
                    : widget._minPartner!._value + 1,
                widget._maxPartner == null
                    ? widget.upperBound
                    : widget._maxPartner!._value - 1,
                shift: shift) ??
            widget._value;
        if (widget.onChange != null) {
          widget.onChange!(widget._value);
        }
        TickerNotification().dispatch(context);
      });
    }
  }

  int? _bounded(int lowerBound, int upperBound, {int shift = 0}) {
    if (_isInt()) {
      return max(
          lowerBound, min(int.parse(_textController.text) + shift, upperBound));
    }
    return null;
  }
}
