import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/range.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/components/counter_button_column.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_notification.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/components/tickers/components/ticker_title.dart';

import 'dart:math';

import '../general/tap_detector.dart';

class TickerMinMax extends Ticker {
  static const double defaultWidth = 380;
  static const double defaultHeight = 197.5;

  late final Counter _minCounter;
  late final Counter _maxCounter;

  void Function(Range)? onChanged;
  late Range _previousValues;
  bool _isSliding = false;

  TickerMinMax({
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
    int lowerBound = 0,
    int upperBound = 100,
    int minStartingValue = 0,
    int maxStartingValue = 100,
    bool hasKeyboardEntry = true,
  }) : super(defaultWidth: defaultWidth, defaultHeight: defaultHeight) {
    upperBound = max(upperBound, lowerBound + 1);
    _minCounter = Counter.fromProportionality(
      proportionality: proportionality,
      startingValue: max(lowerBound, min(minStartingValue, upperBound - 1)),
      lowerBound: lowerBound,
      upperBound: upperBound - 1,
      textAlign: TextAlign.right,
      colorTheme: colorTheme,
      lightingTheme: lightingTheme,
      onChange: (value) => _confirmValues(),
    );
    _maxCounter = Counter.fromProportionality(
      proportionality: proportionality,
      startingValue: max(lowerBound + 1, min(maxStartingValue, upperBound)),
      lowerBound: lowerBound + 1,
      upperBound: upperBound,
      minPartner: _minCounter,
      textAlign: TextAlign.left,
      colorTheme: colorTheme,
      lightingTheme: lightingTheme,
      onChange: (value) => _confirmValues(),
    );
    _previousValues = Range(_minCounter.getValue(), _maxCounter.getValue());
  }

  int getMinValue() {
    return _minCounter.getValue();
  }

  int getMaxValue() {
    return _maxCounter.getValue();
  }

  void _confirmValues(){
    Range newValues = Range(_minCounter.getValue(), _maxCounter.getValue());
    if(onChanged != null && !_isSliding && !newValues.equals(_previousValues)){
      _previousValues = newValues;
      onChanged!(_previousValues);
    }
  }

  @override
  State<TickerMinMax> createState() => TickerMinMaxState();
}

class TickerMinMaxState extends State<TickerMinMax> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      child: Stack(
        children: [
          TickerTitle(
            parent: widget,
          ),
          Column(
            children: [
              SizedBox(
                height: 70 * widget.proportionality,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget._minCounter,
                  SizedBox(
                    width: 40 * widget.proportionality,
                    height: 44 * widget.proportionality,
                    child: Text(
                      '-',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Sans Source Pro',
                        color: widget.colorTheme.primaryColor,
                        fontSize: 44 * widget.proportionality,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  widget._maxCounter,
                ],
              ),
              SizedBox(
                height: 7.5 * widget.proportionality,
              ),
              Container(
                color: widget.colorTheme.titleColor,
                width: 150 * widget.proportionality,
                height: 3 * widget.proportionality,
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: widget.titleHeight + 6.75 * widget.proportionality,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10 * widget.proportionality,
                  ),
                  CounterButtonColumn.fromProportionality(
                    dependency: widget._minCounter,
                    proportionality: widget.proportionality,
                    colorTheme: widget.colorTheme,
                    lightingTheme: widget.lightingTheme,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: widget.titleHeight + 6.75 * widget.proportionality,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CounterButtonColumn.fromProportionality(
                    dependency: widget._maxCounter,
                    proportionality: widget.proportionality,
                    colorTheme: widget.colorTheme,
                    lightingTheme: widget.lightingTheme,
                  ),
                  SizedBox(
                    width: 10 * widget.proportionality,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: TapDetector(
                  child: SizedBox(
                    height: 40 * widget.proportionality,
                    width: widget.width * .675,
                    child: RangeSlider(
                      activeColor: widget.colorTheme.primaryColor,
                      values: RangeValues(widget.getMinValue().toDouble(),
                          widget.getMaxValue().toDouble()),
                      min: widget._minCounter.lowerBound.toDouble(),
                      max: widget._maxCounter.upperBound.toDouble(),
                      onChangeStart: (values) {
                        widget._isSliding = true;
                      },
                      onChanged: (values) {
                        setState(() {
                          widget._minCounter.getCurrentState()?.bound(
                              shift: values.start.round() -
                                  widget._minCounter.getValue());
                          widget._maxCounter.getCurrentState()?.bound(
                              shift: values.end.round() -
                                  widget._maxCounter.getValue());
                          TickerNotification().dispatch(context);
                        });
                      },
                      onChangeEnd: (values) {
                        widget._isSliding = false;
                        widget._confirmValues();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10 * widget.proportionality,
              )
            ],
          ),
        ],
      ),
    );
  }
}
