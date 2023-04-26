import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/components/counter_subtraction_button.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/components/tickers/components/ticker_title.dart';

import 'components/counter_add_button.dart';

class TickerFatRow extends Ticker {
  static const double defaultWidth = 380;
  static const double defaultHeight = 127.5;

  late final Counter _counter;

  void Function(int)? onChanged;

  TickerFatRow({
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
          onChanged!(value);
        }
      },
    );
  }

  int getValue() {
    return _counter.getValue();
  }

  @override
  State<TickerFatRow> createState() => TickerFatRowState();
}

class TickerFatRowState extends State<TickerFatRow> {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height:
                      85 * widget.proportionality - (widget.borderWidth * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CounterSubtractionButton.fromProportionality(
                        dependency: widget._counter,
                        proportionality: widget.proportionality,
                        colorTheme: widget.colorTheme,
                        lightingTheme: widget.lightingTheme,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                            height: 15 * widget.proportionality,
                          ),
                        ],
                      ),
                      CounterAddButton.fromProportionality(
                        dependency: widget._counter,
                        proportionality: widget.proportionality,
                        colorTheme: widget.colorTheme,
                        lightingTheme: widget.lightingTheme,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
