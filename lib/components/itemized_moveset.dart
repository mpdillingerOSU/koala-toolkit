import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/check_n_ex.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/data/moves/move_list.dart';

import '../koala_toolkit_back_end/data/moves/move.dart';
import '../koala_toolkit_back_end/data/moves/moveset.dart';
import '../koala_toolkit_back_end/project_packet.dart';
import '../my_constants.dart';
import '../pages/koala_toolkit_pages/popups/koala_alert.dart';
import 'general/tap_detector.dart';

const double _kSelectionDividerHeight = 3;
const double _kSelectionHeightFactor = .09;

class ItemizedMoveset extends StatelessWidget {
  late final Moveset initialMoveset;
  final ProjectPacket project;
  final double childrenHeight;
  TickerLightingTheme lightingTheme;
  final void Function(Moveset moveset)? onChange;
  final List<ItemizedMoveGroup> _groups = [];

  ItemizedMoveset({
    super.key,
    required Moveset moveset,
    required this.project,
    this.childrenHeight = 100,
    required this.lightingTheme,
    this.onChange,
  }) {
    initialMoveset = moveset;
    List<MoveList> lists = project.moveLists;
    if (initialMoveset.isNotEmpty) {
      for (MoveGroup group in initialMoveset.groups) {
        MoveList? list;
        for (MoveList search in lists) {
          if (search.name == group.name) {
            list = search;
            break;
          }
        }
        if (list != null) {
          _groups.add(ItemizedMoveGroup(group, this, list));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _generateList(),
    );
  }

  List<Widget> _generateList() {
    List<Widget> returnList = [];
    if (_groups.isNotEmpty) {
      returnList.add(_groups.first);
      for (int i = 1; i < _groups.length; i++) {
        returnList.add(const SizedBox(height: 2));
        returnList.add(_groups[i]);
      }
    }
    return returnList;
  }

  Moveset toMoveset() {
    List<MoveGroup> groups = [];
    for (ItemizedMoveGroup group in _groups) {
      groups.add(group._group);
    }
    return Moveset(groups);
  }
}

class ItemizedMoveGroup extends StatefulWidget {
  final ItemizedMoveset parent;
  MoveGroup _group;
  final MoveList moveList;

  MoveGroupPair? get first => _group.pairs.isNotEmpty ? _group.first : null;
  MoveGroupPair? get last => _group.pairs.isNotEmpty ? _group.last : null;

  ItemizedMoveGroup(
    MoveGroup group,
    this.parent,
    this.moveList, {
    super.key,
  }) : _group = group;

  @override
  State<ItemizedMoveGroup> createState() => ItemizedMoveGroupState();
}

class ItemizedMoveGroupState extends State<ItemizedMoveGroup> {
  @override
  Widget build(BuildContext context) {
    double titleHeight = widget.parent.childrenHeight * 1.325;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(
                0,
                2,
              ),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.5),
          child: Column(
            children: <Widget>[
                  Container(
                    height: titleHeight,
                    width: double.infinity,
                    color: Colors.lightBlue,
                    child: Row(
                      children: [
                        SizedBox(
                          width: widget.parent.childrenHeight * .45,
                        ),
                        Expanded(
                          child: Text(
                            widget._group.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleHeight * .35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: widget.parent.childrenHeight * .3,
                        ),
                        TapDetector(
                          onTap: () async {
                            MoveGroup? modGroup = await showDialog(
                              context: context,
                              builder: (context) =>
                                  _MultiSelectPopup(parent: widget),
                            );
                            if (modGroup != null &&
                                !modGroup.equals(widget._group)) {
                              setState(() {
                                widget._group = modGroup;
                                if (widget.parent.onChange != null) {
                                  widget.parent
                                      .onChange!(widget.parent.toMoveset());
                                }
                              });
                            }
                          },
                          child: Icon(
                            Icons.add_rounded,
                            size: titleHeight * .525,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: widget.parent.childrenHeight * .3,
                        ),
                      ],
                    ),
                  ),
                ] +
                _buildPairs(),
          ),
        ),
      ),
    );
  }

  List<ItemizedMoveGroupPair> _buildPairs() {
    List<ItemizedMoveGroupPair> pairs = [];
    if (widget._group.pairs.isNotEmpty) {
      for (MoveGroupPair pair in widget._group.pairs) {
        pairs.add(
          ItemizedMoveGroupPair(
            pair,
            widget,
            height: widget.parent.childrenHeight,
          ),
        );
      }
    } else {
      pairs.add(
        ItemizedMoveGroupPair(
          null,
          widget,
          height: widget.parent.childrenHeight,
        ),
      );
    }
    return pairs;
  }
}

class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        150 ~/ 4,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.white : Colors.grey,
            height: 2,
          ),
        ),
      ),
    );
  }
}

class ItemizedMoveGroupPair extends StatefulWidget {
  final ItemizedMoveGroup group;
  final MoveGroupPair? pair;
  final double height;

  const ItemizedMoveGroupPair(
    this.pair,
    this.group, {
    super.key,
    this.height = 100,
  });

  @override
  State<ItemizedMoveGroupPair> createState() => ItemizedMoveGroupPairState();
}

class ItemizedMoveGroupPairState extends State<ItemizedMoveGroupPair> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.pair == null ||
                (widget.group.first != null &&
                    widget.pair!.equals(widget.group.first!))
            ? const SizedBox()
            : const DashedLine(),
        TapDetector(
          onTap: () {
            if (widget.pair != null) {
              showDialog(
                context: context,
                builder: (context) => _MoveInfoPopup(widget.pair!.move.info()),
              );
            }
          },
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: widget.height * .7,
                ),
                Text(
                  widget.pair?.move.name ?? 'None',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: widget.height * .375,
                    fontWeight: FontWeight.bold,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MultiSelectPopup extends StatelessWidget {
  final ItemizedMoveGroup parent;
  final List<_Selection> _selections = [];

  _MultiSelectPopup({
    required this.parent,
  });

  @override
  Widget build(final BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double sizeFactor = max(screenWidth, screenHeight);
    final double selectionHeight = sizeFactor * _kSelectionHeightFactor;
    final Color textColor = Colors.lightBlue.shade700;

    final List<MoveGroupPair> pairs = [];
    for (Move move in parent.parent.project.getMoves(parent.moveList) ?? []) {
      pairs.add(MoveGroupPair(move, parent.moveList));
    }

    _selections.clear();
    for (MoveGroupPair pair in pairs) {
      _selections.add(
        _Selection(
          pair: pair,
          height: selectionHeight,
          isSelected: parent._group.contains(pair),
          color: textColor,
        ),
      );
    }

    final List<Widget> widgets =
        _selections.isNotEmpty ? [_selections.first] : [];

    for (int i = 1; i < _selections.length; i++) {
      widgets.add(
        Container(
          width: double.infinity,
          height: _kSelectionDividerHeight,
          color: Colors.grey.shade400,
        ),
      );
      widgets.add(_selections[i]);
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
                  (max(2, (pairs.length + 1)) * selectionHeight) +
                      (max(0, (pairs.length - 1)) * _kSelectionDividerHeight),
                ),
              ),
              decoration: BoxDecoration(
                color: MyConstants.primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _selections.isNotEmpty
                      ? Expanded(
                          child: ListView(
                            children: widgets,
                          ),
                        )
                      : SizedBox(
                          height: selectionHeight,
                          child: Center(
                            child: Text(
                              'Empty',
                              style: TextStyle(
                                fontFamily: 'Sans Source Pro',
                                color: textColor,
                                fontSize: selectionHeight * .325,
                              ),
                            ),
                          ),
                        ),
                  CheckNEx(
                    height: sizeFactor * _kSelectionHeightFactor,
                    onAccept: () {
                      List<MoveGroupPair> pairs = [];
                      for (_Selection selection in _selections) {
                        if (selection._isSelected) {
                          pairs.add(selection.pair);
                        }
                      }
                      MoveGroup group = MoveGroup(
                        parent._group.name,
                        pairs,
                      );
                      Navigator.pop(
                        context,
                        group.equals(parent._group)
                            ? null
                            : MoveGroup(parent._group.name, pairs),
                      );
                    },
                    onDeny: () async {
                      List<MoveGroupPair> pairs = [];
                      for (_Selection selection in _selections) {
                        if (selection._isSelected) {
                          pairs.add(selection.pair);
                        }
                      }
                      if (MoveGroup(parent._group.name, pairs)
                              .equals(parent._group) ||
                          (await showDialog(
                                context: context,
                                builder: (context) => const KoalaAlert(
                                  title: 'Discard Changes',
                                  text:
                                      'Do you wish to discard all changes made to the moveset group?',
                                ),
                              ) ??
                              false)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
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

class _Selection extends StatefulWidget {
  final MoveGroupPair pair;
  final double height;
  bool _isSelected;
  final Color color;

  _Selection({
    required this.pair,
    required this.height,
    required bool isSelected,
    required this.color,
  }) : _isSelected = isSelected;

  @override
  State<_Selection> createState() => _SelectionState();
}

class _SelectionState extends State<_Selection> {
  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _MoveInfoPopup(widget.pair.move.info()),
        );
      },
      child: SizedBox(
        height: widget.height,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: widget.height * .35),
            Expanded(
              child: Text(
                widget.pair.move.name,
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: widget.color,
                  fontSize: widget.height * .325,
                ),
              ),
            ),
            TapDetector(
              onTap: () {
                setState(() {
                  widget._isSelected = !widget._isSelected;
                });
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: widget.height * .35,
                  right: widget.height * .25,
                ),
                child: Center(
                  child: Icon(
                    widget._isSelected
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    size: widget.height * .5,
                    color: widget.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoveInfoPopup extends StatelessWidget {
  final List<List<String>> _info = [];

  _MoveInfoPopup(List<List<String>> info) {
    for (List<String> str in info) {
      _info.add([...str]);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double sizeFactor = max(screenWidth, screenHeight);
    final double selectionHeight = sizeFactor * _kSelectionHeightFactor;
    final Color textColor = Colors.lightBlue.shade700;

    final List<Widget> widgets = [];

    for (List<String> str in _info) {
      widgets.add(
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: selectionHeight * .1,
            horizontal: selectionHeight * .325,
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Sans Source Pro',
                shadows: [
                  Shadow(
                    color: textColor,
                    offset: const Offset(0, -3),
                  )
                ],
                color: Colors.transparent,
                fontSize: selectionHeight * .325,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: str[1].isNotEmpty || str[0] == 'Description'
                      ? '${str[0]}:'
                      : str[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: textColor,
                    decorationThickness: 2,
                  ),
                ),
                TextSpan(text: str[1].isNotEmpty ? ' ${str[1]}' : str[1]),
              ],
            ),
          ),
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: screenHeight - sizeFactor * .2,
              ),
              child: Container(
                width: screenWidth - sizeFactor * .15,
                color: MyConstants.primaryColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: selectionHeight * .2,
                      ),
                      child: Column(
                        children: widgets,
                      ),
                    ),
                    Container(
                      height: selectionHeight,
                      color: Colors.lightBlue,
                      child: Row(
                        children: [
                          TapDetector(
                            onTap: () => Navigator.pop(context),
                            isExpanded: true,
                            child: Center(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: selectionHeight * .5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
