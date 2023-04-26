import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_color_theme.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';
import 'package:gaming_toolkit/koala_strings.dart';

import '../../koala_toolkit_back_end/move_element.dart';
import '../../koala_toolkit_back_end/data/moves/move.dart';
import '../../koala_toolkit_back_end/move_type.dart';
import '../dropdown_list.dart';
import '../general/flex_box.dart';
import '../general/tap_detector.dart';

class MoveCard extends StatelessWidget {
  final Move move;
  final double itemWidth;
  final double itemHeight;
  final TickerLightingTheme lightingTheme;
  late final Color moveColor;
  late final Color moveTextColor;
  final String? subtext;
  final bool isSubtextInside;

  final Future<void> Function(int newIndex) onIndexChange;
  final Future<void> Function() onEdit;
  final Future<void> Function() onRename;
  final Future<void> Function() onDuplicate;
  final Future<void> Function() onCopyTo;
  final Future<void> Function() onMoveTo;
  final Future<void> Function() onDelete;

  MoveCard({
    super.key,
    required this.move,
    required this.itemWidth,
    required this.itemHeight,
    required this.lightingTheme,
    this.subtext,
    this.isSubtextInside = false,
    required this.onIndexChange,
    required this.onEdit,
    required this.onRename,
    required this.onDuplicate,
    required this.onCopyTo,
    required this.onMoveTo,
    required this.onDelete,
  }) {

    moveColor = Colors.blueGrey;
    moveTextColor = Colors.blueGrey.shade700;

    /*
    Color windAccentColor = const Color(0xFF03F9A4);

    if (move.element == MoveElement.fire.name) {
      moveColor = const Color(0xFFFFA32A);
      moveTextColor = const Color(0xFFF57820);
    } else if (move.element == MoveElement.earth.name) {
      moveColor = const Color(0xFFA66A54);
      moveTextColor = const Color(0xFF8A5B4A);
    } else if (move.element == MoveElement.water.name) {
      moveColor = const Color(0xFF00B0FF);
      moveTextColor = Colors.lightBlue.shade700;
    } else if (move.element == MoveElement.wind.name) {
      moveColor = const Color(0xFF18E5A7);
      moveTextColor = Colors.teal;
    } else if (move.element == MoveElement.flora.name) {
      moveColor = const Color(0xFF60F86C);
      moveTextColor = const Color(0xFF419F5B);
    } else if (move.element == MoveElement.electric.name) {
      moveColor = const Color(0xFFFFEA31);
      moveTextColor = const Color(0xFFF8C408);
    } else if (move.element == MoveElement.ice.name) {
      moveColor = Colors.tealAccent;
      moveTextColor = Colors.lightBlue;
    } else if (move.element == MoveElement.steel.name) {
      moveColor = Colors.blueGrey;
      moveTextColor = Colors.blueGrey.shade700;
    } else {
      moveColor = Colors.black;
      moveTextColor = Colors.black;
    }
     */
    Colors.tealAccent;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    Container mainWidget = Container(
      width: itemWidth,
      height: itemHeight,
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
              decoration: BoxDecoration(
                color: moveColor,
                borderRadius: const BorderRadius.only(
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
                        color: moveTextColor,
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
                          value: move.moveNum,
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
                        Center(
                          child: Container(
                            width: screenHeight * .1,
                            height: screenHeight * .05,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FlexBox(4),
                                Expanded(
                                  flex: 44,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: const Color(0x00FFFFFF),
                                    child: Center(
                                      child: Icon(
                                        MoveElement.map[move.element],
                                        color: moveColor,
                                        size: screenHeight * .04,
                                        shadows: [
                                          BoxShadow(
                                            color: lightingTheme.shadowColor,
                                            spreadRadius: screenHeight * .0015,
                                            blurRadius: screenHeight * .0015,
                                            offset: Offset(
                                              0,
                                              screenHeight * .0015,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      const FlexBox(1),
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          width: double.infinity,
                                          height: screenHeight * .045,
                                          color: moveTextColor,
                                        ),
                                      ),
                                      const FlexBox(1),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 44,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: const Color(0x00FFFFFF),
                                    child: Center(
                                      child: Icon(
                                        MoveType.map[move.moveType],
                                        color: moveColor,
                                        size: screenHeight * .04,
                                        shadows: [
                                          BoxShadow(
                                            color: lightingTheme.shadowColor,
                                            spreadRadius: screenHeight * .0015,
                                            blurRadius: screenHeight * .0015,
                                            offset: Offset(
                                              0,
                                              screenHeight * .0015,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const FlexBox(4),
                              ],
                            ),
                          ),
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
              onTap: onEdit,
              onDoubleTap: onRename,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          move.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: moveTextColor,
                            fontSize: screenHeight * .035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    subtext != null && isSubtextInside
                        ? Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: screenHeight * .035,
                                child: Text(
                                  subtext!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Sans Source Pro',
                                    color: Colors.grey.shade700,
                                    fontSize: screenHeight * .022,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: moveColor,
                borderRadius: const BorderRadius.only(
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
                        color: moveTextColor,
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

    return Column(
      children: [
        mainWidget,
        subtext != null && !isSubtextInside
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * .009,
                    ),
                    Text(
                      subtext!,
                      style: TextStyle(
                        fontFamily: 'Sans Source Pro',
                        color: Colors.grey.shade700,
                        fontSize: screenHeight * .022,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
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
          value: 'Edit',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.edit,
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
          value: 'Copy to',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Copy to',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.folder_copy_outlined,
                color: Colors.black,
              ),
            ],
          ),
        ),
        DropdownSelection(
          value: 'Move to',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Move to',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.drive_file_move_outlined,
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
        if (value == 'Edit') {
          onEdit();
        } else if (value == 'Rename') {
          onRename();
        } else if (value == 'Duplicate') {
          onDuplicate();
        } else if (value == 'Copy to') {
          onCopyTo();
        } else if (value == 'Move to') {
          onMoveTo();
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
        bound();
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
            bound();
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
                bound();
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
