import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/range.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';
import 'package:gaming_toolkit/components/tickers/components/block_toggle.dart';

import 'general/koala_scrollbar.dart';
import 'general/popup_list.dart';
import 'general/tap_detector.dart';

class Checklist extends StatelessWidget {
  final List<ChecklistItem> _children = [];
  late final double childrenHeight;
  TickerLightingTheme lightingTheme;

  Checklist({
    super.key,
    required List<ChecklistItem> children,
    this.childrenHeight = 100,
    required this.lightingTheme,
  }) {
    for (ChecklistItem item in children) {
      _children.add(item);
      item._parent = this;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Scrollbar(
        child: ListView(
          children: _generateList(),
        ),
      ),
    );
  }

  List<Widget> _generateList() {
    List<Widget> returnList = [];
    if (_children.isNotEmpty) {
      returnList.add(_children.first);
    }
    for (int i = 1; i < _children.length; i++) {
      returnList.add(
        Container(
          width: double.infinity,
          height: 3,
          color: Colors.black38,
        ),
      );
      returnList.add(_children[i]);
    }
    return returnList;
  }
}

class ChecklistItem extends StatefulWidget {
  Checklist? _parent;
  final String text;
  late bool _isSelected;
  final Function? onSelection;
  final Function? onDeselection;
  final Function(bool)? onToggled;
  late final List<ChecklistSubItem> _subItems;
  final bool hasBlockToggle;
  late final ChecklistToggle _blockToggle;
  late bool _showSubItems;
  ChecklistItemState? _currentState;

  ChecklistSubItem? get firstSubItem => hasBlockToggle
      ? _blockToggle
      : _subItems.isNotEmpty
          ? _subItems.first
          : null;
  ChecklistSubItem? get lastSubItem => _subItems.isNotEmpty && _showSubItems
      ? _subItems.last
      : hasBlockToggle
          ? _blockToggle
          : null;

  ChecklistItem({
    super.key,
    required this.text,
    bool isSelected = false,
    this.onSelection,
    this.onDeselection,
    this.onToggled,
    List<ChecklistSubItem>? subItems,
    this.hasBlockToggle = false,
    bool blockToggleStart = true,
  }) {
    _isSelected = isSelected;
    _subItems = [...?subItems];
    for (ChecklistSubItem subItem in _subItems) {
      subItem._parent = this;
    }
    _showSubItems = hasBlockToggle ? blockToggleStart : true;
    _blockToggle = ChecklistToggle(
      text: 'Has',
      isToggledOn: _showSubItems,
      onToggle: (value) {
        if (value != null) {
          _currentState?._setToggle(value);
        }
      },
    );
    _blockToggle._parent = this;
  }

  @override
  State<ChecklistItem> createState() => ChecklistItemState();
}

class ChecklistItemState extends State<ChecklistItem> {
  @override
  Widget build(BuildContext context) {
    widget._currentState = this;
    double height = widget._parent?.childrenHeight ?? 100;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            const BoxShadow(
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
            children: [
              Container(
                height: height,
                width: double.infinity,
                color:
                    widget._isSelected ? Colors.lightBlue : Colors.transparent,
                child: Row(
                  children: [
                    SizedBox(
                      width: height * .3,
                    ),
                    TapDetector(
                      onTap: () {
                        setState(() {
                          widget._isSelected = !widget._isSelected;
                          if (widget._isSelected) {
                            if (widget.onSelection != null) {
                              widget.onSelection!();
                            }
                          } else {
                            if (widget.onDeselection != null) {
                              widget.onDeselection!();
                            }
                          }
                        });
                      },
                      child: Icon(
                        widget._isSelected
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        size: height * .35,
                        color: widget._isSelected
                            ? Colors.white
                            : Colors.lightBlue,
                      ),
                    ),
                    SizedBox(
                      width: height * .2,
                    ),
                    Center(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          color: widget._isSelected
                              ? Colors.white
                              : Colors.lightBlue,
                          fontSize: height * .3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.hasBlockToggle && widget._isSelected,
                child: widget._blockToggle,
              ),
              Visibility(
                visible: widget._isSelected && widget._showSubItems,
                child: Column(
                  children: widget._subItems,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setToggle(bool value) {
    setState(() {
      widget._showSubItems = value;
      if (widget.onToggled != null) {
        widget.onToggled!(value);
      }
    });
  }
}

abstract class ChecklistSubItem extends StatefulWidget {
  final String text;
  ChecklistItem? _parent;

  String _getSubtext();

  ChecklistSubItem({
    super.key,
    required this.text,
  });
}

class ChecklistSublist extends ChecklistSubItem {
  late final AnyCheckbox? anyCheckbox;
  final bool fillOnEmpty;
  late final List<ChecklistSubCheckbox> _checkboxes;
  ChecklistSublistState? _currentState;

  ChecklistSublist({
    super.key,
    required super.text,
    bool hasAnyCheckbox = false,
    this.fillOnEmpty = false,
    required List<ChecklistSubCheckbox> checkboxes,
  }) {
    _checkboxes = [...checkboxes];
    bool isAnySelected = true;
    for (ChecklistSubCheckbox item in _checkboxes) {
      item._parent = this;
      if (!item._isSelected) {
        isAnySelected = false;
      }
    }

    if (hasAnyCheckbox) {
      anyCheckbox = AnyCheckbox(
        isSelected: isAnySelected,
      );
      anyCheckbox!._parent = this;
    }
  }

  bool isEmpty() {
    for (ChecklistSubCheckbox item in _checkboxes) {
      if (item._isSelected) {
        return false;
      }
    }
    return true;
  }

  void selectAll() {
    for (ChecklistSubCheckbox item in _checkboxes) {
      item._select();
    }
  }

  void deselectAll() {
    for (ChecklistSubCheckbox item in _checkboxes) {
      item._deselect();
    }
  }

  @override
  String _getSubtext() {
    if (anyCheckbox?._isSelected ?? false) {
      return 'Any';
    }
    String str = '';
    for (ChecklistSubCheckbox checkbox in _checkboxes) {
      if (checkbox._isSelected) {
        if (str != '') {
          str += ', ';
        }
        str += checkbox.text;
      }
    }
    return str;
  }

  void resetState() {
    _currentState?.resetState();
  }

  @override
  State<ChecklistSublist> createState() => ChecklistSublistState();
}

class ChecklistSublistState extends State<ChecklistSublist> {
  @override
  Widget build(BuildContext context) {
    widget._currentState = this;
    double height = widget._parent?._parent?.childrenHeight ?? 100;
    List<Widget> initialBox = [];
    if (widget.anyCheckbox != null) {
      initialBox.add(widget.anyCheckbox!);
    }
    return ExpandableTab(
      parent: widget,
      height: height,
      child: Column(
        children: <Widget>[SizedBox(height: height * .15)] +
            initialBox +
            widget._checkboxes +
            [SizedBox(height: height * .1)],
      ),
    );
  }

  void resetState() {
    setState(() {});
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

class ChecklistSubCheckbox extends StatefulWidget {
  ChecklistSublist? _parent;
  final String text;
  late bool _isSelected;
  final Function? onSelection;
  final Function? onDeselection;
  ChecklistSubCheckboxState? _currentState;

  ChecklistSubCheckbox({
    super.key,
    required this.text,
    bool isSelected = false,
    this.onSelection,
    this.onDeselection,
  }) {
    _isSelected = isSelected;
  }

  void _select() {
    _currentState?._select();
  }

  void _deselect() {
    _currentState?._deselect();
  }

  @override
  State<ChecklistSubCheckbox> createState() => ChecklistSubCheckboxState();
}

class ChecklistSubCheckboxState extends State<ChecklistSubCheckbox> {
  @override
  Widget build(BuildContext context) {
    widget._currentState = this;
    double parentHeight =
        widget._parent?._parent?._parent?.childrenHeight ?? 100;
    return SizedBox(
      height: parentHeight * .625,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: parentHeight * 1.15,
          ),
          TapDetector(
            onTap: () {
              if (widget._isSelected) {
                if (widget._parent?.anyCheckbox?._isSelected ?? false) {
                  setState(() {
                    widget._parent?.anyCheckbox?._uncheck();
                    for (ChecklistSubCheckbox item
                        in widget._parent!._checkboxes) {
                      if (item != widget) {
                        item._deselect();
                      }
                    }
                    widget._parent?.resetState();
                  });
                } else {
                  _deselect();
                }
              } else {
                _select();
              }
            },
            child: Icon(
              widget._isSelected &&
                      !(widget._parent?.anyCheckbox?._isSelected ?? false)
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              size: parentHeight * .35,
              color: Colors.lightBlue,
            ),
          ),
          SizedBox(
            width: parentHeight * .2,
          ),
          Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: parentHeight * .3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _select() {
    setState(() {
      widget._isSelected = true;
      if (widget.onSelection != null) {
        widget.onSelection!();
      }
      widget._parent?.resetState();
    });
  }

  void _deselect() {
    setState(() {
      widget._isSelected = false;
      if (widget.onDeselection != null) {
        widget.onDeselection!();
      }
      if (widget._parent != null &&
          widget._parent!.fillOnEmpty &&
          widget._parent!.isEmpty()) {
        widget._parent!.anyCheckbox?._check();
        widget._parent!.selectAll();
      }
      widget._parent?.resetState();
    });
  }
}

class AnyCheckbox extends StatefulWidget {
  ChecklistSublist? _parent;
  late bool _isSelected;
  AnyCheckboxState? _currentState;

  AnyCheckbox({
    super.key,
    bool isSelected = false,
  }) {
    _isSelected = isSelected;
  }

  void _check() {
    _currentState?._check();
  }

  void _uncheck() {
    _currentState?._uncheck();
  }

  @override
  State<AnyCheckbox> createState() => AnyCheckboxState();
}

class AnyCheckboxState extends State<AnyCheckbox> {
  @override
  Widget build(BuildContext context) {
    widget._currentState = this;
    double parentHeight =
        widget._parent?._parent?._parent?.childrenHeight ?? 100;
    return SizedBox(
      height: parentHeight * .625,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: parentHeight * 1.15,
          ),
          TapDetector(
            onTap: _select,
            child: Icon(
              widget._isSelected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              size: parentHeight * .35,
              color: Colors.lightBlue,
            ),
          ),
          SizedBox(
            width: parentHeight * .2,
          ),
          Center(
            child: Text(
              'Any',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: parentHeight * .3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _select() {
    if (!widget._isSelected) {
      setState(() {
        widget._isSelected = true;
        widget._parent?.selectAll();
      });
    }
  }

  void _check() {
    setState(() {
      widget._isSelected = true;
    });
  }

  void _uncheck() {
    setState(() {
      widget._isSelected = false;
    });
  }
}

class ExpandableTab extends StatefulWidget {
  final ChecklistSubItem parent;
  final Widget? child;
  final double height;

  const ExpandableTab({
    super.key,
    required this.parent,
    this.child,
    this.height = 100,
  });

  @override
  State<ExpandableTab> createState() => ExpandableTabState();
}

class ExpandableTabState extends State<ExpandableTab> {
  late bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.parent == widget.parent._parent?.firstSubItem
            ? const SizedBox()
            : const DashedLine(),
        TapDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: widget.height * .7,
                ),
                Transform.rotate(
                  angle: _isExpanded ? pi / 2 : 0,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: widget.height * .35,
                    color: Colors.lightBlue,
                  ),
                ),
                SizedBox(
                  width: widget.height * .2,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${widget.parent.text}${widget.parent._getSubtext() == '' ? '' : ': '}',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: widget.height * .3,
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                    Text(
                      widget.parent._getSubtext(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: widget.height * .25,
                        fontStyle: FontStyle.italic,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isExpanded,
          child: Container(
            color: const Color(0xFFE7F6FF),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class ChecklistRange extends ChecklistSubItem {
  final Range range;
  int? _lowerVal;
  int? _upperVal;
  final List<PopupListItem<int?>> _selections = [];
  final Function(Range)? onChange;

  ChecklistRange({
    super.key,
    required super.text,
    required this.range,
    int? lowerVal,
    int? upperVal,
    this.onChange,
  }) {
    _lowerVal = range.bound(lowerVal);
    _upperVal = Range(_lowerVal, range.upperBound).bound(upperVal);

    _selections.add(
      PopupListItem(
        key: 'Any',
        value: null,
      ),
    );
    for (int i = range.lowerBound!; i <= range.upperBound!; i++) {
      _selections.add(
        PopupListItem(
          key: '$i',
          value: i,
        ),
      );
    }
  }

  @override
  String _getSubtext() {
    return _lowerVal == null
        ? (_upperVal == null ? 'Any' : 'Up to $_upperVal')
        : _upperVal == null
            ? 'At least $_lowerVal'
            : '$_lowerVal to $_upperVal';
  }

  @override
  State<ChecklistRange> createState() => ChecklistRangeState();
}

class ChecklistRangeState extends State<ChecklistRange> {
  @override
  Widget build(BuildContext context) {
    double height = widget._parent?._parent?.childrenHeight ?? 100;
    return ExpandableTab(
      parent: widget,
      height: height,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: height * 1.15,
            ),
            TapDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  height * .2,
                  height * .1,
                  height * .2,
                  height * .1,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.5 * height / 100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: height * .025,
                      blurRadius: height * .025,
                      offset: Offset(
                        0,
                        height * .025,
                      ),
                    ),
                  ],
                ),
                child: PopupList<int?>(
                  items: widget._selections,
                  selection: widget._lowerVal,
                  width: height * 1.1,
                  height: height * .325,
                  fontWeight: FontWeight.bold,
                  underline: true,
                  onChanged: (value) {
                    setState(() {
                      widget._lowerVal = Range(
                        widget.range.lowerBound,
                        widget._upperVal,
                      ).bound(value);
                    });
                    if (widget.onChange != null) {
                      widget.onChange!(
                        Range(
                          widget._lowerVal,
                          widget._upperVal,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              width: height * .55,
              child: Center(
                child: Text(
                  'to',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: height * .25,
                  ),
                ),
              ),
            ),
            TapDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  height * .2,
                  height * .1,
                  height * .2,
                  height * .1,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.5 * height / 100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: height * .025,
                      blurRadius: height * .025,
                      offset: Offset(
                        0,
                        height * .025,
                      ),
                    ),
                  ],
                ),
                child: PopupList<int?>(
                  items: widget._selections,
                  selection: widget._lowerVal,
                  width: height * 1.1,
                  height: height * .325,
                  fontWeight: FontWeight.bold,
                  underline: true,
                  onChanged: (value) {
                    setState(() {
                      widget._upperVal = Range(
                        widget._lowerVal,
                        widget.range.upperBound,
                      ).bound(value);
                    });
                    if (widget.onChange != null) {
                      widget.onChange!(
                        Range(
                          widget._lowerVal,
                          widget._upperVal,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChecklistToggle extends ChecklistSubItem {
  final Function(bool?)? onToggle;
  late bool _isToggledOn;
  final bool canToggleActivation;
  late bool _isActive;

  ChecklistToggle({
    super.key,
    required super.text,
    required bool isToggledOn,
    this.canToggleActivation = false,
    bool? isActive,
    this.onToggle,
  }) {
    _isToggledOn = isToggledOn;
    _isActive = canToggleActivation ? (isActive ?? false) : true;
  }

  @override
  State<ChecklistToggle> createState() => ChecklistToggleState();

  @override
  String _getSubtext() {
    return !_isActive
        ? 'Any'
        : _isToggledOn
            ? 'Yes'
            : 'No';
  }
}

class ChecklistToggleState extends State<ChecklistToggle> {
  @override
  Widget build(BuildContext context) {
    double height = widget._parent?._parent?.childrenHeight ?? 100;
    return ExpandableTab(
      parent: widget,
      height: height,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: height * 1.15,
            ),
            Visibility(
              visible: widget.canToggleActivation,
              child: Row(
                children: [
                  TapDetector(
                    onTap: () {
                      setState(() {
                        widget._isActive = !widget._isActive;
                        if (widget.onToggle != null) {
                          widget.onToggle!(
                              widget._isActive ? widget._isToggledOn : null);
                        }
                      });
                    },
                    child: Icon(
                      widget._isActive
                          ? Icons.check_box_outline_blank_rounded
                          : Icons.check_box_rounded,
                      size: height * .35,
                      color: Colors.lightBlue,
                    ),
                  ),
                  SizedBox(
                    width: height * .1,
                  ),
                  Center(
                    child: Text(
                      'Any',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: height * .3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: height * .25,
                  ),
                ],
              ),
            ),
            BlockToggle(
              title: '',
              firstOption: 'Yes',
              secondOption: 'No',
              positionedLeft: widget._isToggledOn,
              startActive: widget._isActive,
              width: BlockToggle.defaultWidth * .8,
              onChanged: (value) {
                setState(() {
                  widget._isToggledOn = value;
                  if (widget.onToggle != null) {
                    widget.onToggle!(value);
                  }
                });
              },
              lightingTheme: widget._parent?._parent?.lightingTheme ??
                  TickerLightingTheme.lightTheme,
            ),
          ],
        ),
      ),
    );
  }
}
