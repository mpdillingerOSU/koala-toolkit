import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_color_theme.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import '../../koala_strings.dart';
import '../../koala_toolkit_back_end/data/moves/move_list.dart';
import '../dropdown_list.dart';
import '../general/tap_detector.dart';

class MoveListCard extends StatelessWidget {
  final MoveList moveList;
  final double width;
  final double height;
  final TickerLightingTheme lightingTheme;

  final Future<void> Function(int newIndex) onIndexChange;
  final Future<void> Function() onOpen;
  final Future<void> Function() onRename;
  final Future<void> Function() onDuplicate;
  final Future<void> Function() onCopyAll;
  final Future<void> Function() onMerge;
  final Future<void> Function() onExport;
  final Future<void> Function() onDelete;

  const MoveListCard({
    super.key,
    required this.moveList,
    required this.width,
    required this.height,
    required this.lightingTheme,
    required this.onIndexChange,
    required this.onOpen,
    required this.onRename,
    required this.onDuplicate,
    required this.onCopyAll,
    required this.onMerge,
    required this.onExport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: lightingTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: lightingTheme.shadowColor,
            spreadRadius: 3.2,
            blurRadius: 3.2,
            offset: const Offset(
              0,
              3.2,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 27,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: screenHeight * .00375,
                        height: double.infinity,
                        color: Colors.blueGrey.shade700,
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MoveListNumber(
                          height: screenHeight * .0425,
                          value: moveList.listNum,
                          onChange: (value) {
                            onIndexChange(value);
                          },
                          lightingTheme: lightingTheme,
                        ),
                        SizedBox(
                          height: screenHeight * .005,
                        ),
                        Container(
                          width: screenHeight * .045,
                          height: screenHeight * .004,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: screenHeight * .00625,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 61,
            child: TapDetector(
              onTap: onOpen,
              onDoubleTap: onRename,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text(
                    moveList.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: screenHeight * .035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: screenHeight * .00375,
                        height: double.infinity,
                        color: Colors.blueGrey.shade700,
                      ),
                    ],
                  ),

                  ///Use of [Column] ensures no error for having an
                  /// [Expanded] widget, the highest child of the
                  /// [DropdownList] widget, being the child of the
                  /// parent [Stack].
                  Column(children: [_buildDropdownMenu(context)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownList<String> _buildDropdownMenu(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return DropdownList(
      padding: EdgeInsets.zero,
      color: Colors.white,
      borderWidth: 2,
      borderRadius: 15,
      isExpanded: true,
      child: Icon(
        Icons.adaptive.more_rounded,
        color: Colors.white,
        size: screenHeight * .055,
      ),
      itemBuilder: (context) => [
        DropdownSelection(
          value: 'Open',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Open',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.file_open_outlined,
                color: Colors.black,
              ),
            ],
          ),
        ),
        DropdownSelection(
          value: 'Rename',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Rename',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.abc_rounded,
                color: Colors.black,
              ),
            ],
          ),
        ),
        DropdownSelection(
          value: 'Duplicate',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Duplicate',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              Transform.rotate(
                angle: pi,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.copy_rounded,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        DropdownSelection(
          value: 'Copy All',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Copy All',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.copy_all_rounded,
                color: Colors.black,
              ),
            ],
          ),
        ),
        DropdownSelection(
          value: 'Merge',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Merge',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.merge_type_rounded,
                color: Colors.black,
              ),
            ],
          ),
        ),
        DropdownSelection(
          value: 'Export',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Export',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.download_rounded,
                color: Colors.black,
              ),
            ],
          ),
        ),
        DropdownSelection(
          color: Colors.red,
          value: 'Delete',
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.white,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == 'Open') {
          onOpen();
        } else if (value == 'Rename') {
          onRename();
        } else if (value == 'Duplicate') {
          onDuplicate();
        } else if (value == 'Copy All') {
          onCopyAll();
        } else if (value == 'Merge') {
          onMerge();
        } else if (value == 'Export') {
          onExport();
        } else if (value == 'Delete') {
          onDelete();
        }
      },
    );
  }
}

class MoveListNumber extends StatefulWidget {
  static const double defaultWidth = 64;
  static const double defaultHeight = 32;

  late final double width;
  late final double height;
  late final double proportionality;
  late int _value;
  MoveListNumberState? _currentState;
  final TickerColorTheme colorTheme;
  final TickerLightingTheme lightingTheme;
  final Function(int)? onChange;

  MoveListNumber({
    super.key,
    required int value,
    this.height = defaultHeight,
    this.colorTheme = Ticker.defaultColorTheme,
    required this.lightingTheme,
    this.onChange,
  }) {
    proportionality = height / defaultHeight;
    width = defaultWidth * proportionality;
    _value = value;
  }

  int getValue() {
    return _value;
  }

  MoveListNumberState? getCurrentState() {
    return _currentState;
  }

  @override
  State<MoveListNumber> createState() => MoveListNumberState();
}

class MoveListNumberState extends State<MoveListNumber> {
  final TextEditingController _textController = TextEditingController();
  late final StreamSubscription<bool> _keyboardSubscription;
  bool _hasFocus = false;
  String? _checkValue;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((isVisible) {
      if (!isVisible && _hasFocus && _checkValue != _textController.text) {
        setState(() {
          bound();
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._currentState = this;
    _textController.text = widget._value.toString();
    _checkValue = _textController.text;
    //When "text" is reset above, then "selection" is removed, so resetting
    // "selection" here becomes necessary...
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.text.length,
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Focus(
        onFocusChange: (hasFocus) {
          _hasFocus = hasFocus;
          if (!hasFocus && _checkValue != _textController.text) {
            setState(() {
              bound();
            });
          }
        },
        child: TapDetector(
          child: TextFormField(
            controller: _textController,
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: [
              FilteringTextInputFormatter.allow(numeric)
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Sans Source Pro',
              color: Colors.white,
              fontSize: widget.height,
              fontWeight: FontWeight.bold,
            ),
            onTap: () {
              _textController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _textController.text.length,
              );
            },
            onFieldSubmitted: (String text) {
              if (text != _checkValue) {
                _checkValue = text;
                setState(() {
                  bound();
                });
              }
            },
          ),
        ),
      ),
    );
  }

  bool _isInt() {
    return int.tryParse(_textController.text) != null;
  }

  void bound() {
    int? newValue = _bounded();
    if(newValue != null && newValue != widget._value){
      setState(() {
        widget._value = newValue;
        if (widget.onChange != null) {
          widget.onChange!(widget._value);
        }
      });
    }
  }

  int? _bounded() {
    if (_isInt()) {
      return int.parse(_textController.text);
    }
    return null;
  }
}
