import 'dart:math';

import 'package:flutter/cupertino.dart';

class MarginedColumn extends StatelessWidget {
  late final int margin;
  late final List<Widget> _children;

  MarginedColumn({
    super.key,
    int margin = 15,
    List<Widget> children = const <Widget>[],
  }) {
    this.margin = max(0, min(margin, 49));
    _children = [...children];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: margin,
          child: Container(),
        ),
        Expanded(
          flex: 100 - (margin * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _children,
          ),
        ),
        Expanded(
          flex: margin,
          child: Container(),
        )
      ],
    );
  }
}
