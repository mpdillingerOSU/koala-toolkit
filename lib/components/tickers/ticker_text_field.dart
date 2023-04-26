import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';
import 'package:gaming_toolkit/components/tickers/components/ticker_side_title.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_notification.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';

class TickerTextField extends Ticker {
  static const double defaultWidth = 380;
  static const double defaultHeight = 65;

  final bool autofocus;
  final Function(String)? onChange;
  final bool Function(String)? validate;

  late String _rebuildValue;
  final String? validationTextTitle;
  final String? validationText;

  TickerTextFieldState? _currentState;
  late bool _isRebuild;

  TickerTextField({
    super.key,
    super.title,
    super.colorTheme,
    required super.lightingTheme,
    super.width = defaultWidth,
    super.contrastTitle,
    super.hasMenu,
    super.canDelete,
    super.onSetToDefault,
    super.onRestore,
    super.onDelete,
    this.autofocus = false,
    this.onChange,
    this.validate,
    this.validationTextTitle,
    this.validationText,
    String initialValue = '...',
  }) : super(defaultWidth: defaultWidth, defaultHeight: defaultHeight) {
    _rebuildValue = initialValue;
    _isRebuild = true;
  }

  String get value {
    return _currentState?._textController.text ?? _rebuildValue;
  }

  bool get isValid => validate == null || validate!(value);

  @override
  State<TickerTextField> createState() => TickerTextFieldState();
}

class TickerTextFieldState extends State<TickerTextField> {
  final TextEditingController _textController = TextEditingController();
  String? _checkValue;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._currentState = this;

    if (widget._isRebuild) {
      _textController.text = widget._rebuildValue;
      _checkValue = _textController.text;
      _textController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _textController.text.length,
      );
      widget._isRebuild = false;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      child: Row(
        children: [
          TickerSideTitle(
            parent: widget,
          ),
          SizedBox(
            width: 20 * widget.proportionality,
          ),
          Expanded(
            child: TapDetector(
              child: TextFormField(
                maxLines: 1,
                controller: _textController,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: widget.isValid
                      ? widget.colorTheme.primaryColor
                      : Colors.orange,
                  fontSize: 24 * widget.proportionality,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  _textController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _textController.text.length,
                  );
                },
                onChanged: (String text) {
                  if (text != _checkValue) {
                    _checkValue = text;
                    if (widget.onChange != null) {
                      setState(() {
                        widget.onChange!(widget.value);
                      });
                    }
                    TickerNotification().dispatch(context);
                  }
                },
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
                left: 7.5 * widget.proportionality,
                right: 12.5 * widget.proportionality,
              ),
              child: Center(
                child: TapDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => KoalaSimpleAlert(
                        title: widget.validationTextTitle ?? 'Invalid Text',
                        text: widget.validationText ??
                            'The given text is invalid.',
                      ),
                    );
                  },
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 32 * widget.proportionality,
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
