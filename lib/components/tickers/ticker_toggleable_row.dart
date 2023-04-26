import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/components/tickers/components/ticker_title.dart';

import 'components/counter_button_row.dart';
import 'components/toggle.dart';

class TickerToggleableRow extends Ticker {
  static const double defaultWidth = 380;
  static const double defaultHeight = 197.5;

  late final Counter _counter;
  late List<Toggle> _toggles;

  //TODO: eventually make this function actually return an array of proper
  // values...
  void Function()? onChanged;

  TickerToggleableRow({
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
    int startingValue = 0,
    int lowerBound = 0,
    int upperBound = 100,
    bool hasKeyboardEntry = true,
    bool? switchBool1 = false,
    bool? switchBool2 = false,
    bool? switchBool3 = false,
    List<Toggle> toggles = const [],
  }) : super(defaultWidth: defaultWidth, defaultHeight: defaultHeight) {
    _counter = Counter.fromProportionality(
      proportionality: proportionality,
      startingValue: startingValue,
      lowerBound: lowerBound,
      upperBound: upperBound,
      colorTheme: colorTheme,
      lightingTheme: lightingTheme,
      onChange: (value) {
        if(onChanged != null){
          onChanged!();
        }
      },
    );
    _toggles = [...toggles];
  }

  int getValue() {
    return _counter.getValue();
  }

  Object? getToggleValue(String toggleTitle){
    for(Toggle toggle in _toggles){
      if(toggleTitle == toggle.title){
        return toggle.getValue();
      }
    }
    return null;
  }

  @override
  State<TickerToggleableRow> createState() => TickerToggleableRowState();
}

class TickerToggleableRowState extends State<TickerToggleableRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      child: Stack(
        children: [
          TickerTitle(parent: widget),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 42.5 * widget.proportionality,
              ),
              Row(
                children: [
                  SizedBox(
                    width:
                        (180 * widget.proportionality) - (widget.borderWidth * 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget._counter,
                        SizedBox(
                          height: 7.5 * widget.proportionality,
                        ),
                        Container(
                          color: widget.colorTheme.titleColor,
                          width: 60 * widget.proportionality,
                          height: 3 * widget.proportionality,
                        ),
                        SizedBox(
                          height: 12.5 * widget.proportionality,
                        ),
                        CounterButtonRow.fromProportionality(
                          dependency: widget._counter,
                          proportionality: widget.proportionality,
                          colorTheme: widget.colorTheme,
                          lightingTheme: widget.lightingTheme,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: widget.borderWidth * 2,
                    height: 155 * widget.proportionality - widget.borderWidth * 2,
                    child: Center(
                      child: Container(
                        color: widget.colorTheme.primaryColor,
                        width: widget.borderWidth,
                        height: 115 * widget.proportionality,
                      ),
                    ),
                  ),
                  SizedBox(
                    width:
                        (200 * widget.proportionality) - (widget.borderWidth * 2),
                    height: 155 * widget.proportionality  - widget.borderWidth * 2,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget._toggles,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
