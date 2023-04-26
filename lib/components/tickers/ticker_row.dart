import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/components/counter_subtraction_button.dart';
import 'package:gaming_toolkit/components/tickers/components/ticker_side_title.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_listener.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import 'components/counter_add_button.dart';
import 'interactables/ticker_notification.dart';

class TickerRow extends Ticker {
  static const double defaultWidth = 380;
  static const double defaultHeight = 65;

  final Function(int)? onChange;

  late final Counter _counter;

  TickerRow({
    super.key,
    super.title,
    super.colorTheme,
    required super.lightingTheme,
    super.width = defaultWidth,
    super.contrastTitle,
    this.onChange,
    super.hasMenu,
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
      proportionality: proportionality * .875,
      startingValue: startingValue,
      lowerBound: lowerBound,
      upperBound: upperBound,
      colorTheme: colorTheme,
      lightingTheme: lightingTheme,
    );
  }

  int getValue() {
    return _counter.getValue();
  }

  @override
  State<TickerRow> createState() => TickerRowState();
}

class TickerRowState extends State<TickerRow> {
  @override
  Widget build(BuildContext context) {
    return TickerListener(
      onNotification: (TickerNotification notification) {
        if (widget.onChange != null) {
          widget.onChange!(widget.getValue());
        }
        return false;
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: widget.decoration,
        child: Row(
          children: [
            TickerSideTitle(
              parent: widget,
            ),
            SizedBox(
              width: 10 * widget.proportionality,
            ),
            CounterSubtractionButton.fromProportionality(
              dependency: widget._counter,
              proportionality: widget.proportionality * .875,
              lightingTheme: widget.lightingTheme,
            ),
            SizedBox(
              width: 84 * widget.proportionality,
              child: widget._counter,
            ),
            CounterAddButton.fromProportionality(
              dependency: widget._counter,
              proportionality: widget.proportionality * .875,
              lightingTheme: widget.lightingTheme,
            ),
          ],
        ),
      ),
    );
  }
}
