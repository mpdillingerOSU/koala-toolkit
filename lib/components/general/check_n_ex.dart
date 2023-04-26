import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';

const double _kHeightFactor = .09;

class CheckNEx extends StatelessWidget {
  final void Function() onAccept;
  final void Function() onDeny;
  final double? height;
  final Color? color;

  const CheckNEx({
    super.key,
    required this.onAccept,
    required this.onDeny,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultHeight = _getDefaultHeight(context);
    return Container(
      height: height ?? defaultHeight,
      color: color ?? Colors.lightBlue,
      child: Row(
        children: [
          TapDetector(
            onTap: onAccept,
            isExpanded: true,
            child: Center(
              child: Icon(
                Icons.check_rounded,
                size: (height ?? defaultHeight) * .5,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: 3,
            height: double.infinity,
            color: Colors.white,
          ),
          TapDetector(
            onTap: onDeny,
            isExpanded: true,
            child: Center(
              child: Icon(
                Icons.close_rounded,
                size: (height ?? defaultHeight) * .5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getDefaultHeight(BuildContext context) =>
      max(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ) *
      _kHeightFactor;
}

class Closer extends StatelessWidget {
  final double? height;
  final Color? color;
  final void Function() onClose;

  const Closer({
    super.key,
    required this.onClose,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultHeight = _getDefaultHeight(context);
    return Container(
      height: height ?? defaultHeight,
      color: color ?? Colors.lightBlue,
      child: TapDetector(
        onTap: onClose,
        isExpanded: true,
        child: Center(
          child: Icon(
            Icons.close_rounded,
            size: (height ?? defaultHeight) * .5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  double _getDefaultHeight(BuildContext context) =>
      max(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ) *
          _kHeightFactor;
}
