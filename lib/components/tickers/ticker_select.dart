import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/koala_scrollbar.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_notification.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/components/tickers/components/ticker_title.dart';

import '../../my_constants.dart';
import 'dart:math';

import '../general/koala_snack_bar.dart';
import '../general/tap_detector.dart';
import '../popup.dart';

class TickerSelect extends Ticker {
  static const double defaultWidth = 180;
  static const double defaultHeight = 197.5;

  late final Map<String, IconData> _selections;
  late final List<String> _selectionsList;
  late String _currentSelection;

  //TODO: Although this has an onChanged, it has not been tested for update to
  // the parent's setState that may affect it if it is build dynamically in the
  // build method, instead of being held as a variable...
  final void Function(String)? onChanged;
  final Future<bool> Function(String)? onValidate;

  TickerSelect({
    super.key,
    super.title,
    super.colorTheme,
    required super.lightingTheme,
    super.width = defaultWidth,
    super.contrastTitle,
    super.hasMenu,
    this.onChanged,
    this.onValidate,
    super.canDelete,
    super.onSetToDefault,
    super.onRestore,
    super.onDelete,
    required Map<String, IconData> selections,
    String? currentSelection,
  }) : super(
          defaultWidth: defaultWidth,
          defaultHeight: defaultHeight,
        ) {
    _selections =
        selections.isEmpty ? {'Default': Icons.circle} : {...selections};
    _selectionsList = [..._selections.keys];
    _currentSelection = (_selectionsList.contains(currentSelection)
        ? currentSelection
        : _selectionsList[0])!;
  }

  String getCurrentSelection() {
    return _currentSelection;
  }

  @override
  State<TickerSelect> createState() => TickerSelectState();
}

class TickerSelectState extends State<TickerSelect> {
  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () => _makeSelection(context),
      child: Container(
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
                  SizedBox(
                    height: 5.75 * widget.proportionality,
                  ),
                  Icon(
                    widget._selections[widget._currentSelection],
                    size: 108 * widget.proportionality,
                    color: widget.colorTheme.primaryColor,
                    shadows: [
                      BoxShadow(
                        color: widget.colorTheme.lightShadowColor,
                        spreadRadius: 4 * widget.proportionality,
                        blurRadius: 4 * widget.proportionality,
                        offset: Offset(
                          0,
                          4 * widget.proportionality,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: getSelectionText(),
            ),
          ],
        ),
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
        SizedBox(height: 2 * widget.proportionality),
        Text(
          widget._currentSelection,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Sans Source Pro',
            color: widget.colorTheme.primaryColor,
            fontSize: 22 * widget.proportionality,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 4 * widget.proportionality,
        )
      ],
    );
  }

  Future<void> _makeSelection(BuildContext context) async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => _SelectionPopup(this),
    );

    if (result != null && result != widget._currentSelection) {
      setState(() {
        widget._currentSelection = result;
        if (widget.onChanged != null) {
          widget.onChanged!(widget._currentSelection);
        }
      });

      if (!mounted) return;
      TickerNotification().dispatch(context);
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            KoalaSnackBar(context, '${widget.title} Change: $result'));
    }
  }
}

class _SelectionPopup extends StatefulWidget {
  TickerSelectState parent;
  late String _currentSelection;

  _SelectionPopup(this.parent) {
    _currentSelection = parent.widget._currentSelection;
  }

  @override
  State<_SelectionPopup> createState() => _SelectionPopupState();
}

class _SelectionPopupState extends State<_SelectionPopup> {
  @override
  Widget build(BuildContext context) {
    double sizeFactor = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    int rowCount = (widget.parent.widget._selectionsList.length / 3).ceil();
    double popupWidth = sizeFactor * .8;
    double selectionSize = popupWidth * .875 / 3;
    double dividerSpace = popupWidth * .125;
    double dividerWidth = dividerSpace / 4;

    return Popup(
      context: context,
      onContinue: () async {
        final bool isValid = widget.parent.widget.onValidate == null ||
            await widget.parent.widget.onValidate!(widget._currentSelection);
        if (isValid) {
          if (!mounted) return;
          Navigator.pop(context, widget._currentSelection);
        }
      },
      title: 'Select ${widget.parent.widget.title}',
      borderRadius: widget.parent.widget.borderRadius,
      bodyHeight: (selectionSize * rowCount) + (dividerWidth * (rowCount + 1)),
      child: generateGrid(selectionSize, dividerWidth),
    );
  }

  Scrollbar generateGrid(
    double selectionSize,
    dividerWidth,
  ) {
    List<List<_SelectionCard>> lists = [[]];
    int selectionCount = widget.parent.widget._selectionsList.length;
    for (int i = 0; i < selectionCount; i++) {
      if (lists.last.length == 3) {
        lists.add([]);
      }
      lists.last.add(
        _SelectionCard(
          this,
          widget.parent.widget._selectionsList[i],
          widget.parent.widget
                  ._selections[widget.parent.widget._selectionsList[i]] ??
              Icons.circle,
          selectionSize,
          EdgeInsets.only(
            left: dividerWidth / (lists.last.isEmpty ? 1 : 2),
            top: dividerWidth / (i < 3 ? 1 : 2),
            right: dividerWidth / (lists.last.length == 2 ? 1 : 2),
            bottom: dividerWidth /
                (i > ((selectionCount / 3).ceil() * 3) - 3 - 1 ? 1 : 2),
          ),
        ),
      );
    }

    List<Row> rows = [];
    for (List<_SelectionCard> list in lists) {
      rows.add(
        Row(
          children: list,
        ),
      );
    }
    return Scrollbar(
      child: ListView(
        children: rows,
      ),
    );
  }

  void _select(String selection) {
    setState(() {
      widget._currentSelection = selection;
    });
  }
}

class _SelectionCard extends StatelessWidget {
  final _SelectionPopupState parent;
  final String title;
  final IconData icon;
  final double size;
  final EdgeInsetsGeometry padding;

  const _SelectionCard(
    this.parent,
    this.title,
    this.icon,
    this.size,
    this.padding,
  );

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () => parent._select(title),
      child: Padding(
        padding: padding,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: title == parent.widget._currentSelection
                ? parent.widget.parent.widget.colorTheme.primaryColor
                : MyConstants.primaryColor,
            borderRadius:
                BorderRadius.circular(parent.widget.parent.widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: parent.widget.parent.widget.lightingTheme.shadowColor,
                spreadRadius: 4 * parent.widget.parent.widget.proportionality,
                blurRadius: 4 * parent.widget.parent.widget.proportionality,
                offset: Offset(
                  0,
                  4 * parent.widget.parent.widget.proportionality,
                ),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: title == parent.widget._currentSelection
                          ? MyConstants.primaryColor
                          : parent.widget.parent.widget.colorTheme.primaryColor,
                      size: size * .65,
                      shadows: [
                        BoxShadow(
                          color: parent
                              .widget.parent.widget.colorTheme.lightShadowColor,
                          spreadRadius:
                              3 * parent.widget.parent.widget.proportionality,
                          blurRadius:
                              3 * parent.widget.parent.widget.proportionality,
                          offset: Offset(
                            0,
                            3 * parent.widget.parent.widget.proportionality,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size * .175,
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size * .025,
                    ),
                    Container(
                      width: size * .85,
                      height: size * .025,
                      color: title == parent.widget._currentSelection
                          ? MyConstants.primaryColor
                          : parent.widget.parent.widget.colorTheme.primaryColor,
                    ),
                    SizedBox(
                      height: size * .025,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Sans Source Pro',
                        color: title == parent.widget._currentSelection
                            ? MyConstants.primaryColor
                            : parent
                                .widget.parent.widget.colorTheme.primaryColor,
                        fontSize: size * .125,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size * .025,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
