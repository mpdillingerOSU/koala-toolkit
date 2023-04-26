import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/components/tickers/components/ticker_title.dart';

import 'components/block_toggle.dart';

class TickerSwitch extends Ticker {
  static const double defaultWidth = 180;
  static const double defaultHeight = 197.5;

  final IconData icon;
  late bool _isActive;

  void Function(bool)? onChanged;

  TickerSwitch({
    super.key,
    super.title,
    super.colorTheme,
    required super.lightingTheme,
    super.width = defaultWidth,
    super.contrastTitle,
    super.hasMenu,
    this.onChanged,
    super.canDelete,
    super.onSetToDefault,
    super.onRestore,
    super.onDelete,
    required this.icon,
    bool isSelected = true,
  }) : super(defaultWidth: defaultWidth, defaultHeight: defaultHeight) {
    _isActive = isSelected;
  }

  bool isActive() {
    return _isActive;
  }

  @override
  State<TickerSwitch> createState() => TickerSwitchState();
}

class TickerSwitchState extends State<TickerSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      child: Stack(
        children: [
          TickerTitle(parent: widget),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 94 * widget.proportionality,
                  color: widget.colorTheme.primaryColor,
                ),
                SizedBox(
                  height: 15 * widget.proportionality,
                ),
              ],
            ),
          ),
          Center(
            child: getSelectionText(),
          ),
        ],
      ),
    );
  }

  Column getSelectionText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: widget.colorTheme.titleColor,
          width: 120 * widget.proportionality,
          height: 3 * widget.proportionality,
        ),
        SizedBox(height: 5 * widget.proportionality),
        BlockToggle(
          title: widget.title,
          width: BlockToggle.defaultWidth * widget.proportionality * .75,
          height: BlockToggle.defaultHeight * widget.proportionality,
          firstOption: 'No',
          secondOption: 'Yes',
          positionedLeft: !widget._isActive,
          onChanged: (value) {
            setState(() {
              widget._isActive = !value;
              if(widget.onChanged != null){
                widget.onChanged!(value);
              }
            });
          },
          colorTheme: widget.colorTheme,
          lightingTheme: widget.lightingTheme,
        ),
        SizedBox(
          height: 8 * widget.proportionality,
        )
      ],
    );
  }
}
