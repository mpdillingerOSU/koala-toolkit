import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/polygon_container.dart';

const double _kDefaultButtonSize = 100;

class HexagonButton {
  final String title;
  final IconData icon;
  final void Function() onTap;

  const HexagonButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class _ColumnedHexagonButton extends StatelessWidget {
  final HexagonButton info;
  final double size;

  const _ColumnedHexagonButton({
    required this.info,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return PolygonContainer(
      size: size,
      borderWidth: size * .05,
      borderColor: const Color(0xFF295B73),
      onTap: info.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            info.icon,
            color: Colors.lightBlue,
            size: size * .5,
            shadows: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: size * .015,
                blurRadius: size * .015,
                offset: Offset(
                  0,
                  size * .015,
                ),
              ),
            ],
          ),
          Text(
            info.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Sans Source Pro',
              color: Colors.lightBlue,
              fontSize: size * .09,
              fontWeight: FontWeight.bold,
              shadows: [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: size * .006,
                  blurRadius: size * .006,
                  offset: Offset(
                    0,
                    size * .006,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size * .075,
          ),
        ],
      ),
    );
  }
}

class HexagonColumn extends StatelessWidget {
  final List<_ColumnedHexagonButton> _buttons = [];
  late final double buttonSize;

  HexagonColumn({
    super.key,
    required List<HexagonButton> buttons,
    double? buttonSize,
  }) {
    this.buttonSize = buttonSize ?? _kDefaultButtonSize;
    for (HexagonButton button in buttons) {
      _buttons.add(_ColumnedHexagonButton(
        info: button,
        size: this.buttonSize,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_buttons.length < 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buttons,
      );
    }

    return SizedBox(
      width: buttonSize * 1.875,
      height: buttonSize * (_buttons.length + 1) / 2,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: _generateColumn(0),
          ),
          Positioned(
            top: buttonSize / 2,
            right: 0,
            child: _generateColumn(1),
          ),
        ],
      ),
    );
  }

  Column _generateColumn(int startIndex) {
    List<_ColumnedHexagonButton> buttons = [];
    for (int i = startIndex; i < _buttons.length; i += 2) {
      buttons.add(_buttons[i]);
    }
    return Column(
      children: buttons,
    );
  }
}
