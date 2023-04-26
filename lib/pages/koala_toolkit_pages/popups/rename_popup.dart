import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../components/general/tap_detector.dart';
import '../koala_popup.dart';
import 'koala_alert.dart';

class RenamePopup extends StatefulWidget {
  final String title;

  final bool Function(String) validate;

  late String _rebuildValue;
  final String validationText;

  _RenamePopupState? _currentState;
  late bool _isRebuild;

  RenamePopup({
    super.key,
    required this.title,
    required String initialValue,
    required this.validate,
    required this.validationText,
  }) {
    _rebuildValue = initialValue;
    _isRebuild = true;
  }

  String get value {
    return _currentState?._textController.text ?? _rebuildValue;
  }

  bool get isValid => validate(value);

  @override
  State<RenamePopup> createState() => _RenamePopupState();
}

class _RenamePopupState extends State<RenamePopup> {
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

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double sizeFactor = min(screenWidth, screenHeight);
    double textBoxBorderWidth = 2;
    double textBoxBorderRadius = 8.75;

    return KoalaPopup(
      height: sizeFactor * .7,
      onAccept: () => widget.isValid
          ? Navigator.pop(context, _textController.text)
          : _showValidationDialog(),
      onDeny: () => Navigator.pop(context),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              widget.title,
              textAlign: TextAlign.left,
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                fontFamily: 'Sans Source Pro',
                color: const Color(0xC4000000),
                fontSize: sizeFactor * .08,
              ),
            ),
          ),
          SizedBox(
            height: sizeFactor * .09,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(sizeFactor * .01),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(textBoxBorderRadius),
              border: Border.all(
                color: Colors.black54,
                width: textBoxBorderWidth,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        _cursorSelection = null;
                      }
                    },
                    child: TapDetector(
                      child: TextFormField(
                        controller: _textController,
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        textCapitalization:
                        TextCapitalization.words,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15),
                          isDense: true,
                        ),
                        style: TextStyle(
                          fontFamily: 'Sans Source Pro',
                          color: widget.isValid
                              ? const Color(0xC4000000)
                              : Colors.orange,
                          fontSize: sizeFactor * .07,
                        ),
                        onTap: () {
                          _cursorSelection = _textController
                              .selection.baseOffset;
                          _placeCursor();
                        },
                        onChanged: (text) {
                          if (text != _checkValue) {
                            setState(() {
                              _checkValue = text;
                              _cursorSelection = _textController
                                  .selection.baseOffset;
                            });
                          }
                        },
                        onFieldSubmitted: (text) {
                          _cursorSelection = null;
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !widget.isValid,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: sizeFactor * .01 + 15,
                      right: 15,
                    ),
                    child: Center(
                      child: TapDetector(
                        onTap: () => _showValidationDialog(),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: sizeFactor * .1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (context) => KoalaSimpleAlert(
        title: 'Invalid Name',
        text: widget.validationText,
      ),
    );
  }

  void _placeCursor() {
    if (widget._isRebuild) {
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
