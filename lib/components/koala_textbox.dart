import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';

class KoalaTextBox extends StatefulWidget {
  static const double defaultSize = 200;

  final String title;
  final double size;
  final bool autofocus;
  final Function(String)? onChange;
  final bool Function(String)? validate;

  late String _rebuildValue;
  final String? validationTextTitle;
  final String? validationText;

  final double fontSize;
  final double titleFontSize;
  final bool selectAllOnTap;
  late final List<TextInputFormatter>? _inputFormatters;
  final TextCapitalization textCapitalization;
  final int? maxLines;

  KoalaTextBoxState? _currentState;
  late bool _isRebuild;

  KoalaTextBox({
    super.key,
    required this.title,
    this.size = defaultSize,
    this.autofocus = false,
    this.onChange,
    this.validate,
    this.validationTextTitle,
    this.validationText,
    String initialValue = '...',
    this.fontSize = 12,
    this.titleFontSize = 18,
    this.selectAllOnTap = false,
    List<TextInputFormatter>? inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines,
  }) {
    _rebuildValue = initialValue;
    _isRebuild = true;
    _inputFormatters = inputFormatters == null ? null : [...inputFormatters];
  }

  String get value {
    return _currentState?._textController.text ?? _rebuildValue;
  }

  bool get isValid => validate == null || validate!(value);

  @override
  State<KoalaTextBox> createState() => KoalaTextBoxState();
}

class KoalaTextBoxState extends State<KoalaTextBox> {
  final TextEditingController _textController = TextEditingController();
  late final StreamSubscription<bool> _keyboardSubscription;
  String? _checkValue;
  int? _cursorSelection;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((isVisible) {
      if (!isVisible) {
        _cursorSelection = null;
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
      _checkValue = _textController.text;
      _placeCursor();
      widget._isRebuild = false;
    }

    double borderWidth = 6;
    double paddingValue = 15;
    double textBoxBorderWidth = 2;
    double textBoxBorderRadius = 8.75;

    return Container(
      padding: EdgeInsets.only(
        left: paddingValue,
        top: paddingValue / 2,
        right: paddingValue,
        bottom: paddingValue,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFDBF3FF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.lightBlue,
          width: borderWidth,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: widget.titleFontSize * 1.4,
            width: widget.size -
                ((paddingValue + borderWidth) * 2) -
                textBoxBorderRadius,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: widget.isValid ? Colors.black : Colors.orange,
                    fontSize: widget.titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Visibility(
                  visible: !widget.isValid,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: widget.titleFontSize * .3,
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
                          size: widget.titleFontSize * 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: paddingValue / 2,
          ),
          Container(
            width: widget.size - ((paddingValue + borderWidth) * 2),
            height: widget.maxLines == null
                ? widget.size - ((paddingValue + borderWidth) * 2)
                : null,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(textBoxBorderRadius),
              border: Border.all(
                color: Colors.black54,
                width: textBoxBorderWidth,
              ),
            ),
            child: SingleChildScrollView(
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    _cursorSelection = null;
                  }
                },
                child: TapDetector(
                  child: TextFormField(
                    maxLines: widget.maxLines,
                    controller: _textController,
                    autofocus: widget.autofocus,
                    keyboardType: TextInputType.name,
                    inputFormatters: widget._inputFormatters,
                    textCapitalization: widget.textCapitalization,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(15),
                      isDense: true,
                      constraints: widget.maxLines == null
                          ? BoxConstraints(
                              minHeight: widget.size -
                                  ((paddingValue +
                                          borderWidth +
                                          textBoxBorderWidth) *
                                      2),
                            )
                          : null,
                    ),
                    style: TextStyle(
                      fontFamily: 'Sans Source Pro',
                      color: widget.isValid ? Colors.black : Colors.orange,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    onTap: () {
                      _cursorSelection = _textController.selection.baseOffset;
                      _placeCursor();
                    },
                    onChanged: (text) {
                      if (text != _checkValue) {
                        _checkValue = text;
                        _cursorSelection = _textController.selection.baseOffset;
                        if (widget.onChange != null) {
                          setState(() {
                            widget.onChange!(widget.value);
                          });
                        }
                      }
                    },
                    onFieldSubmitted: (text) {
                      _cursorSelection = null;
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _placeCursor() {
    if (widget.selectAllOnTap) {
      _textController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _textController.text.length,
      );
    } else if (_cursorSelection != null) {
      _textController.selection = TextSelection.collapsed(
        offset: _cursorSelection!,
      );
    }
  }
}
