import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_notification.dart';

import '../../../pages/koala_toolkit_pages/popups/koala_alert.dart';
import '../aesthetics/ticker_color_theme.dart';
import '../aesthetics/ticker_lighting_theme.dart';

class TickerGridTitle extends StatefulWidget {
  late String _rebuildValue;
  final TickerColorTheme colorTheme;
  final TickerLightingTheme lightingTheme;
  final double width;
  late final double proportionality;

  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool Function(String)? validate;
  final String? validationTextTitle;
  final String? validationText;

  TickerGridTitleState? _currentState;
  late bool _isRebuild;

  TickerGridTitle({
    super.key,
    String title = '',
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
    this.width = 380,
    this.onChanged,
    this.onSubmitted,
    this.validate,
    this.validationTextTitle,
    this.validationText,
  }) {
    _rebuildValue = title;
    proportionality = width / 380;
    _isRebuild = true;
  }

  String get value {
    return _currentState?._textController.text ?? _rebuildValue;
  }

  bool get isValid => validate == null || validate!(value);

  @override
  State<TickerGridTitle> createState() => TickerGridTitleState();
}

class TickerGridTitleState extends State<TickerGridTitle> {
  final TextEditingController _textController = TextEditingController();
  late final StreamSubscription<bool> _keyboardSubscription;
  String? _lastEditedValue;
  String? _lastSubmittedValue;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((isVisible) {
      if (!isVisible) {
        _submitValue();
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

    if (widget._isRebuild) {
      _textController.text = widget._rebuildValue;
      _lastEditedValue = _textController.text;
      _lastSubmittedValue = _lastEditedValue;
      _textController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _textController.text.length,
      );
      widget._isRebuild = false;
    }

    return SizedBox(
      width: widget.width,
      child: Column(
        children: [
          SizedBox(
            width: 360 * widget.proportionality,
            child: Row(
              children: [
                Expanded(child: getTextField()),
                Visibility(
                  visible: !widget.isValid,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 7.5 * widget.proportionality,
                      right: 12.5 * widget.proportionality,
                    ),
                    child: Center(
                      child: TapDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => KoalaSimpleAlert(
                              title:
                                  widget.validationTextTitle ?? 'Invalid Text',
                              text: widget.validationText ??
                                  'The given text is invalid.',
                            ),
                          );
                        },
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 64 * widget.proportionality,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10 * widget.proportionality,
          ),
          Container(
            color: widget.colorTheme.primaryColor,
            width: 320 * widget.proportionality,
            height: 3 * widget.proportionality,
          ),
          SizedBox(
            height: 15 * widget.proportionality,
          ),
        ],
      ),
    );
  }

  Widget getTextField() {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          _submitValue();
        }
      },
      child: TapDetector(
        child: TextFormField(
          maxLines: null,
          controller: _textController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Sans Source Pro',
            color:
                widget.isValid ? widget.colorTheme.primaryColor : Colors.orange,
            fontSize: 48 * widget.proportionality,
            fontWeight: FontWeight.bold,
          ),
          onTap: () {
            _textController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _textController.text.length,
            );
          },
          onChanged: (String text) {
            if (text != _lastEditedValue) {
              _lastEditedValue = text;
              setState(() {
                if (widget.onChanged != null) {
                  setState(() {
                    widget.onChanged!(widget.value);
                  });
                }
                TickerNotification().dispatch(context);
              });
            }
          },
          onFieldSubmitted: (String value) => _submitValue(),
        ),
      ),
    );
  }

  void _submitValue() {
    if (_textController.text != _lastSubmittedValue) {
      _lastSubmittedValue = _textController.text;
      if (widget.onSubmitted != null) {
        setState(() {
          widget.onSubmitted!(widget.value);
        });
        TickerNotification().dispatch(context);
      }
    }
  }
}
