import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/components/counter_button_row.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/components/tickers/components/ticker_title.dart';

class TickerBox extends Ticker {
  static const double defaultWidth = 180;
  static const double defaultHeight = 197.5;

  late final Counter _counter;

  void Function(int)? onChanged;

  TickerBox({
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
  State<TickerBox> createState() => NewTickerBoxState();
}

class NewTickerBoxState extends State<TickerBox> {
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
                height: 50 * widget.proportionality,
              ),
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
        ],
      ),
    );
  }
}
