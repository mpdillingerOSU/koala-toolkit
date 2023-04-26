import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/components/block_counter_button.dart';
import 'package:gaming_toolkit/components/tickers/components/counter.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_listener.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import '../../my_constants.dart';
import '../../pages/koala_toolkit_pages/popups/koala_alert.dart';
import '../general/tap_detector.dart';
import 'interactables/ticker_notification.dart';

class _BlockTickerTitle extends StatelessWidget {
  final Ticker parent;
  late final double width;
  late final double proportionality;
  final String clickableTitle;
  final String clickableText;

  _BlockTickerTitle({
    required this.parent,
    required this.clickableTitle,
    required this.clickableText,
  }) {
    width = parent.sideTitleWidth;
    proportionality = width / Ticker.defaultSideTitleWidth;
  }

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => KoalaSimpleAlert(
            title: clickableTitle,
            text: clickableText,
          ),
        );
      },
      child: Container(
        width: width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: parent.contrastTitle
              ? parent.colorTheme.primaryColor
              : MyConstants.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10 * parent.proportionality),
            bottomLeft: Radius.circular(10 * parent.proportionality),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 2 * proportionality,
              blurRadius: 2 * proportionality,
              offset: Offset(
                2 * proportionality,
                0,
              ),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                parent.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: parent.contrastTitle
                      ? parent.lightingTheme.backgroundColor
                      : parent.colorTheme.primaryColor,
                  fontSize: 24 * parent.proportionality,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: parent.contrastTitle
                        ? Colors.black38
                        : parent.colorTheme.primaryColor,
                    width: 3 * parent.proportionality,
                    height: parent.contrastTitle
                        ? double.infinity
                        : parent.height * .875,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockTickerBones extends StatelessWidget {
  final BlockTicker parent;
  final Widget child;
  final VoidCallback? onUpdate;
  final String clickableTitle;
  final String clickableText;

  const _BlockTickerBones({
    this.onUpdate,
    required this.parent,
    required this.child,
    required this.clickableTitle,
    required this.clickableText,
  });

  @override
  Widget build(BuildContext context) {
    return TickerListener(
      onNotification: (TickerNotification notification) {
        if (onUpdate != null) {
          onUpdate!();
        }
        return false;
      },
      child: Container(
        width: parent.width,
        height: parent.height,
        decoration: BoxDecoration(
          color: parent.lightingTheme.backgroundColor,
          borderRadius: BorderRadius.circular(10 * parent.proportionality),
          border: parent.hasBorder
              ? Border.all(
                  color: MyConstants.borderColor,
                  width: parent.borderWidth,
                )
              : null,
          boxShadow: parent.hasShadow ? [parent.boxShadow] : null,
        ),
        child: Row(
          children: [
            _BlockTickerTitle(
              parent: parent,
              clickableTitle: clickableTitle,
              clickableText: clickableText,
            ),
            SizedBox(
              width: 10 * parent.proportionality,
            ),
            Expanded(
              child: Container(
                height: parent.height * .8,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(10 * parent.proportionality),
                  border: Border.all(
                    color: Ticker.defaultColorTheme.buttonBorderColor
                        .withOpacity(.85),
                    width: 3 * parent.proportionality,
                  ),
                ),
                child: child,
              ),
            ),
            SizedBox(
              width: 10 * parent.proportionality,
            ),
          ],
        ),
      ),
    );
  }
}

abstract class BlockTicker extends Ticker {
  static const double defaultWidth = 380;
  static const double defaultHeight = 65;

  BlockTicker({
    super.key,
    super.title,
    super.colorTheme,
    required super.lightingTheme,
    super.width = defaultWidth,
  }) : super(
          defaultWidth: defaultWidth,
          defaultHeight: defaultHeight,
        );
}

class BlockTickerRow extends BlockTicker {
  final void Function(int)? onChange;
  late final Counter _counter;
  final String clickableTitle;
  final String clickableText;

  BlockTickerRow({
    super.key,
    super.title,
    super.colorTheme,
    required super.lightingTheme,
    super.width,
    this.onChange,
    int startingValue = 0,
    int lowerBound = 0,
    int upperBound = 100,
    bool hasKeyboardEntry = true,
    required this.clickableTitle,
    required this.clickableText,
  }) {
    _counter = Counter.fromProportionality(
      proportionality: proportionality * .875,
      startingValue: startingValue,
      lowerBound: lowerBound,
      upperBound: upperBound,
      colorTheme: colorTheme,
      lightingTheme: lightingTheme,
      alignedBottom: false,
    );
  }

  int getValue() {
    return _counter.getValue();
  }

  @override
  State<BlockTickerRow> createState() => BlockTickerRowState();
}

class BlockTickerRowState extends State<BlockTickerRow> {
  @override
  Widget build(BuildContext context) {
    return _BlockTickerBones(
      onUpdate: () {
        if (widget.onChange != null) {
          widget.onChange!(widget.getValue());
        }
      },
      parent: widget,
      clickableTitle: widget.clickableTitle,
      clickableText: widget.clickableText,
      child: Row(
        children: [
          BlockCounterSubtractionButton(
            dependency: widget._counter,
            size: widget.height * .8,
            lightingTheme: widget.lightingTheme,
          ),
          Container(
            width: 3 * widget.proportionality,
            height: widget.height * .8,
            color: Ticker.defaultColorTheme.buttonBorderColor.withOpacity(.85),
          ),
          Expanded(
            child: widget._counter,
          ),
          Container(
            width: 3 * widget.proportionality,
            height: widget.height * .8,
            color: Ticker.defaultColorTheme.buttonBorderColor.withOpacity(.85),
          ),
          BlockCounterAddButton(
            dependency: widget._counter,
            size: widget.height * .8,
            lightingTheme: widget.lightingTheme,
          ),
        ],
      ),
    );
  }
}

class BlockTickerSelect extends BlockTicker {
  final void Function(String)? onChange;
  late final List<String> _selections;
  late int _currentSelection;
  final String clickableTitle;
  final String clickableText;

  BlockTickerSelect({
    super.key,
    super.title,
    super.colorTheme,
    required super.lightingTheme,
    super.width,
    this.onChange,
    required List<String> selections,
    String? currentSelection,
    required this.clickableTitle,
    required this.clickableText,
  }) {
    _selections = [...selections];
    _currentSelection = currentSelection != null
        ? max(0, _selections.indexOf(currentSelection))
        : 0;
  }

  String get currentSelection => _selections[_currentSelection];

  @override
  State<BlockTickerSelect> createState() => BlockTickerSelectState();
}

class BlockTickerSelectState extends State<BlockTickerSelect> {
  @override
  Widget build(BuildContext context) {
    return _BlockTickerBones(
      parent: widget,
      clickableTitle: widget.clickableTitle,
      clickableText: widget.clickableText,
      child: Row(
        children: [
          BlockEventButton(
            onPressed: () {
              setState(() {
                widget._currentSelection = (widget._currentSelection > 0
                        ? widget._currentSelection
                        : widget._selections.length) -
                    1;
                if (widget.onChange != null) {
                  widget.onChange!(widget.currentSelection);
                }
                TickerNotification().dispatch(context);
              });
            },
            icon: Icons.arrow_left_sharp,
            size: widget.height * .8,
            borderType: BlockButtonBorderType.right,
            lightingTheme: widget.lightingTheme,
          ),
          Container(
            width: 3 * widget.proportionality,
            height: widget.height * .8,
            color: Ticker.defaultColorTheme.buttonBorderColor.withOpacity(.85),
          ),
          Expanded(
            child: Text(
              widget.currentSelection,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Sans Source Pro',
                color: widget.lightingTheme.standardTextColor,
                fontSize: 20 * widget.proportionality,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Container(
            width: 3 * widget.proportionality,
            height: widget.height * .8,
            color: Ticker.defaultColorTheme.buttonBorderColor.withOpacity(.85),
          ),
          BlockEventButton(
            onPressed: () {
              setState(() {
                widget._currentSelection =
                    (widget._currentSelection > widget._selections.length - 2
                            ? -1
                            : widget._currentSelection) +
                        1;
                if (widget.onChange != null) {
                  widget.onChange!(widget.currentSelection);
                }
                TickerNotification().dispatch(context);
              });
            },
            icon: Icons.arrow_right_sharp,
            size: widget.height * .8,
            borderType: BlockButtonBorderType.left,
            lightingTheme: widget.lightingTheme,
          ),
        ],
      ),
    );
  }
}
