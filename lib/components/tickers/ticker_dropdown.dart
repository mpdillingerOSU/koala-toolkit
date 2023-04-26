import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';
import 'package:gaming_toolkit/components/tickers/components/ticker_side_title.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_notification.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import '../general/popup_list.dart';

class TickerDropdown extends Ticker {
  static const double defaultWidth = 380;
  static const double defaultHeight = 65;

  final Function(String)? onChange;

  final List<PopupListItem<String>> _selections = [];
  late String _currentSelection;

  TickerDropdown({
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
    this.onChange,
    required List<String> selections,
    required String currentSelection,
  }) : super(defaultWidth: defaultWidth, defaultHeight: defaultHeight) {
    for (String selection in selections) {
      _selections.add(
        PopupListItem(
          key: selection,
          value: selection,
        ),
      );
    }
    if (_selections.isEmpty) {
      _selections.add(
        PopupListItem(
          key: 'empty',
          value: 'empty',
        ),
      );
    }
    _currentSelection = selections.contains(currentSelection) ? currentSelection : selections.first;
  }

  String getSelection() {
    return _currentSelection;
  }

  @override
  State<TickerDropdown> createState() => TickerDropdownState();
}

class TickerDropdownState extends State<TickerDropdown> {
  @override
  Widget build(BuildContext context) {
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
          TapDetector(
            child: PopupList(
              items: widget._selections,
              selection: widget._currentSelection,
              width: 200 * widget.proportionality,
              height: 30 * widget.proportionality,
              textColor: widget.colorTheme.primaryColor,
              fontWeight: FontWeight.bold,
              onChanged: (value) {
                if (value is String) {
                  setState(() {
                    widget._currentSelection = value;
                  });
                  if (widget.onChange != null) {
                    widget.onChange!(value);
                  }
                  TickerNotification().dispatch(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
