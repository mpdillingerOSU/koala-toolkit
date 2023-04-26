import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';

import '../../my_constants.dart';

const double _kSelectionHeightFactor = .09;
const double _kSelectionDividerHeight = 3;
const double _kUnderlineHeight = 2;

class PopupList<T> extends StatefulWidget {
  late final List<PopupListItem<T>> _items;
  late PopupListItem<T>? _selection;
  final double width;
  final double height;
  final Color? textColor;
  final Color? popupTextColor;
  final FontWeight? fontWeight;
  final bool? underline;
  final void Function(T)? onChanged;

  PopupList({
    super.key,
    required List<PopupListItem<T>> items,
    required T? selection,
    required this.width,
    required this.height,
    this.textColor,
    this.popupTextColor,
    this.fontWeight,
    this.underline,
    this.onChanged,
  }) {
    _items = [...items];
    if (_items.isEmpty) {
      _selection = null;
    } else {
      bool isInitialized = false;
      for (PopupListItem<T> item in _items) {
        if (selection == item.value) {
          _selection = item;
          isInitialized = true;
          break;
        }
      }
      if (!isInitialized) {
        _selection = _items.first;
      }
    }
  }

  @override
  State<PopupList<T>> createState() => _PopupListState<T>();
}

class _PopupListState<T> extends State<PopupList<T>> {
  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () async {
        if (widget._items.isNotEmpty) {
          final PopupListItem<T>? result = await showDialog(
            context: context,
            builder: (context) => _SelectionPopup(parent: widget),
          );
          if (result != null && result != widget._selection) {
            setState(() {
              widget._selection = result;
              if (widget.onChanged != null) {
                widget.onChanged!(result.value);
              }
            });
          }
        }
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: widget.height * .25),
                  Expanded(
                    child: Text(
                      widget._selection?.key ?? '-',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Sans Source Pro',
                        color: widget.textColor ?? Colors.lightBlue,
                        fontSize: widget.height * .8,
                        fontWeight: widget.fontWeight,
                      ),
                    ),
                  ),
                  SizedBox(width: widget.height * .25),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    size: widget.height,
                    color: widget.textColor ?? Colors.lightBlue,
                  ),
                  SizedBox(width: widget.height * .25),
                ],
              ),
            ),
            widget.underline == true
                ? Container(
                    width: double.infinity,
                    height: _kUnderlineHeight,
                    color: Colors.lightBlue,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class _SelectionPopup<T> extends StatelessWidget {
  final PopupList<T> parent;

  const _SelectionPopup({
    required this.parent,
  });

  @override
  Widget build(final BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double sizeFactor = max(screenWidth, screenHeight);

    final List<Widget> widgets = parent._items.isNotEmpty
        ? [
            _Selection(
              item: parent._items.first,
              height: sizeFactor * _kSelectionHeightFactor,
              isSelected: parent._items.first == parent._selection,
              color: parent.popupTextColor ?? Colors.lightBlue.shade700,
            ),
          ]
        : [];

    for (int i = 1; i < parent._items.length; i++) {
      widgets.add(
        Container(
          width: double.infinity,
          height: _kSelectionDividerHeight,
          color: Colors.grey.shade400,
        ),
      );
      widgets.add(
        _Selection(
          item: parent._items[i],
          height: sizeFactor * _kSelectionHeightFactor,
          isSelected: parent._items[i] == parent._selection,
          color: parent.popupTextColor ?? Colors.lightBlue.shade700,
        ),
      );
    }

    /// First [TapDetector] allows us to close the popup when clicking outside
    /// of the popup itself
    return TapDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: screenWidth - sizeFactor * .1,
              height: min(
                screenHeight - sizeFactor * .15,
                max(
                  0,
                  (parent._items.length *
                          sizeFactor *
                          _kSelectionHeightFactor) +
                      ((parent._items.length - 1) * _kSelectionDividerHeight),
                ),
              ),
              decoration: BoxDecoration(
                color: MyConstants.primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView(
                children: widgets,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PopupListItem<T> {
  final String key;
  final T value;

  PopupListItem({
    required this.key,
    required this.value,
  });
}

class _Selection<T> extends StatelessWidget {
  final PopupListItem<T> item;
  final double height;
  final bool isSelected;
  final Color color;

  const _Selection({
    required this.item,
    required this.height,
    required this.isSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Icon icon = Icon(
      Icons.circle_outlined,
      size: height * .5,
      color: color,
    );

    return TapDetector(
      onTap: () {
        Navigator.pop(context, item);
      },
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: height * .35),
            Expanded(
              child: Text(
                item.key,
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: color,
                  fontSize: height * .325,
                ),
              ),
            ),
            SizedBox(width: height * .35),
            isSelected
                ? Stack(
                    children: [
                      icon,
                      Positioned.fill(
                        child: Center(
                          child: Icon(
                            Icons.circle,
                            size: height * .25,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  )
                : icon,
            SizedBox(width: height * .25),
          ],
        ),
      ),
    );
  }
}
