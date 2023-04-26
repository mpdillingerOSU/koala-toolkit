import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/user_preferences.dart';

import 'general/tap_detector.dart';

class ExpandableList extends StatefulWidget {
  final String title;
  final List<String> _items;
  final double childrenHeight;

  String? get first => _items.isNotEmpty ? _items.first : null;
  String? get last => _items.isNotEmpty ? _items.last : null;

  ExpandableList({
    super.key,
    required this.title,
    required List<String> items,
    this.childrenHeight = 100,
  }) : _items = [...items];

  @override
  State<ExpandableList> createState() => ExpandableListState();
}

class ExpandableListState extends State<ExpandableList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double titleHeight = widget.childrenHeight * 1.325;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: UserPreferences.getLightingTheme().shadowColor,
            spreadRadius: 3.2,
            blurRadius: 3.2,
            offset: const Offset(
              0,
              3.2,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: <Widget>[
            Container(
              height: titleHeight,
              width: double.infinity,
              color: _isExpanded ? Colors.lightBlue : Colors.white,
              child: Row(
                children: [
                  SizedBox(
                    width: titleHeight * .3,
                  ),
                  TapDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Transform.rotate(
                      angle: _isExpanded ? pi / 2 : 0,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: titleHeight * .35,
                        color: _isExpanded ? Colors.white : Colors.lightBlue,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: titleHeight * .2,
                  ),
                  Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: _isExpanded ? Colors.white : Colors.lightBlue,                        fontSize: titleHeight * .35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isExpanded,
              child: _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildList() {
    List<_ListItem> list = [];
    if (widget._items.isNotEmpty) {
      list.add(_ListItem(widget._items.first, widget.childrenHeight, true));
      for (int i = 1; i < widget._items.length; i++) {
        list.add(
          _ListItem(
            widget._items[i],
            widget.childrenHeight,
            false,
          ),
        );
      }
    } else {
      list.add(
        _ListItem(
          null,
          widget.childrenHeight,
          true,
        ),
      );
    }
    return Column(children: list);
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

class _ListItem extends StatelessWidget {
  final String? val;
  final double height;
  final bool isFirst;

  const _ListItem(this.val, this.height, this.isFirst);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isFirst ? const SizedBox() : const DashedLine(),
        SizedBox(
          height: height,
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(
                width: height * .7,
              ),
              Text(
                val ?? 'None',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: height * .375,
                  fontWeight: FontWeight.bold,
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
