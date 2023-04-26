import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/toggle.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_notification.dart';

import '../../general/tap_detector.dart';
import '../aesthetics/ticker_color_theme.dart';
import '../aesthetics/ticker_lighting_theme.dart';

class BlockToggle extends Toggle<String> {
  static const double defaultWidth = 180;
  static const double defaultHeight = 43.75;
  static const double defaultBorderWidth = 4.5;
  static const double defaultBorderRadius = 15.625;

  final String firstOption;
  final String secondOption;
  late bool _positionedLeft;
  final double width;
  late final double widthProportionality;
  late final double height;
  late final double heightProportionality;
  late final double borderRadius;
  late final double borderWidth;
  final void Function(bool)? onChanged;
  final TickerColorTheme colorTheme;
  final TickerLightingTheme lightingTheme;
  late bool _isActive;
  _BlockToggleState? _currentState;

  BlockToggle({
    super.key,
    required super.title,
    required this.firstOption,
    required this.secondOption,
    bool positionedLeft = true,
    this.width = BlockToggle.defaultWidth,
    double? height,
    this.onChanged,
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
    bool startActive = true,
  }) {
    _positionedLeft = positionedLeft;
    widthProportionality = width / defaultWidth;
    this.height = height ?? defaultHeight * widthProportionality;
    heightProportionality = this.height / defaultHeight;
    borderRadius = defaultBorderRadius * heightProportionality;
    borderWidth = defaultBorderWidth * heightProportionality;
    _isActive = startActive;
  }

  String getTitle() {
    return title;
  }

  @override
  String getValue(){
    return _positionedLeft ? firstOption : secondOption;
  }

  setIsActive(bool value){
    _currentState?._setIsActive(value);
  }

  @override
  State<BlockToggle> createState() => _BlockToggleState();
}

class _BlockToggleState extends State<BlockToggle> {
  @override
  Widget build(BuildContext context) {
    widget._currentState = this;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: Colors.black38,
              width: widget.borderWidth,
            ),
          ),
          child: Row(
            children: [
              _generateSelection(context, widget.firstOption, true),
              _generateSelection(context, widget.secondOption, false),
            ],
          ),
        ),
      ],
    );
  }

  void _setIsActive(bool value){
    setState((){
      widget._isActive = value;
    });
  }

  Expanded _generateSelection(
      BuildContext context, String selection, bool isLeftSelection) {
    return Expanded(
      child: TapDetector(
        onTap: () {
          if(widget._isActive){
            setState(() {
              widget._positionedLeft = isLeftSelection;
              TickerNotification().dispatch(context);
            });
            if (widget.onChanged != null) {
              widget.onChanged!(isLeftSelection);
            }
          }
        },
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius * .825),
            color: widget._positionedLeft == isLeftSelection && widget._isActive
                ? widget.lightingTheme.contrastColor
                : const Color(0x00FFFFFF),
            boxShadow: widget._positionedLeft == isLeftSelection && widget._isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF656565),
                      spreadRadius: 2 * widget.heightProportionality,
                      offset: Offset(
                        3 *
                            widget.heightProportionality *
                            (isLeftSelection ? 1 : -1),
                        0,
                      ),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  2 * widget.heightProportionality,
                  1 * widget.heightProportionality,
                  2 * widget.heightProportionality,
                  1 * widget.heightProportionality),
              child: Text(
                selection,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: widget._positionedLeft == isLeftSelection && widget._isActive
                      ? widget.colorTheme.primaryColor
                      : Colors.black26,
                  fontSize: 18 * widget.heightProportionality,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
