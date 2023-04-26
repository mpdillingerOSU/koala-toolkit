import 'dart:math';
import 'package:flutter/material.dart';

import 'general/tap_detector.dart';

const double _kDefaultSize = 100;
const Color _kDefaultColor = Colors.white;
const int _kDefaultSides = 6;
const double _kDefaultRotation = 90;
const double _kDefaultBorderWidth = 0;
const double _kDefaultBorderRadiusAngle = 5;
const Color _kDefaultBorderColor = Color(0xFF737373);
const List<PolygonShadow> _kDefaultShadows = [
  PolygonShadow(color: Colors.black, elevation: 1.0),
  PolygonShadow(color: Colors.grey, elevation: 5.0),
];

class PolygonContainer extends StatelessWidget {
  final Widget? child;
  late final double size;
  final Color? color;
  final int? sides;
  final double? rotation;
  late final double borderWidth;
  final double? borderRadius;
  final Color? borderColor;
  late final List<PolygonShadow>? _boxShadows;
  final void Function()? onTap;

  PolygonContainer({
    super.key,
    this.child,
    double? size,
    this.color,
    this.sides,
    this.rotation,
    double? borderWidth,
    this.borderRadius,
    this.borderColor,
    List<PolygonShadow>? boxShadows,
    this.onTap,
  }) {
    this.size = max(1, size ?? _kDefaultSize);
    this.borderWidth = max(0, min(borderWidth ?? _kDefaultBorderWidth, (this.size / 2) - 1));
    _boxShadows = boxShadows == null ? null : [...boxShadows];
  }

  @override
  Widget build(BuildContext context) {
    _PolygonPathSpecs specs = _PolygonPathSpecs(
      sides: sides,
      rotation: rotation,
      borderRadiusAngle: borderRadius,
    );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CustomPaint(
            painter: _ShadowPainter(specs, _boxShadows ?? _kDefaultShadows),
            child: ClipPath(
              clipper: _Polygon(specs),
              child: TapDetector(
                onTap: onTap,
                child: Container(
                  width: size,
                  height: size,
                  color: borderColor ?? _kDefaultBorderColor,
                ),
              ),
            ),
          ),
          Center(
            child: ClipPath(
              clipper: _Polygon(specs),

              ///Use of a second [TapDetector] is necessary, as the first
              /// allows the border to detect touch, while the second allows
              /// inside of the border to detect touch. This is due to the
              /// [Stack] stopping detection.
              child: TapDetector(
                onTap: onTap,
                child: Container(
                  width: size - (borderWidth * 2),
                  height: size - (borderWidth * 2),
                  color: color ?? _kDefaultColor,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Polygon extends CustomClipper<Path> {
  final _PolygonPathSpecs specs;

  _Polygon(this.specs);

  @override
  Path getClip(Size size) =>
      _PolygonPathDrawer(size: size, specs: specs).draw();

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _ShadowPainter extends CustomPainter {
  final _PolygonPathSpecs specs;
  final List<PolygonShadow> boxShadows;

  _ShadowPainter(this.specs, this.boxShadows);

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    Path path = _PolygonPathDrawer(size: size, specs: specs).draw();

    for (PolygonShadow shadow in boxShadows) {
      canvas.drawShadow(path, shadow.color, shadow.elevation, false);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PolygonShadow {
  final Color color;
  final double elevation;

  const PolygonShadow({
    required this.color,
    required this.elevation,
  });
}

class _PolygonPathDrawer {
  final Path path;
  final Size size;
  final _PolygonPathSpecs specs;

  _PolygonPathDrawer({
    required this.size,
    required this.specs,
  }) : path = Path();

  Path draw() {
    final anglePerSide = 360 / specs.sides;

    final radius =
        (size.width - specs.borderRadiusAngle) /
            2;
    final arcLength = (radius *
            _angleToRadian(
                specs.borderRadiusAngle)) +
        (specs.sides * 2);

    Path path = Path();

    for (var i = 0; i <= specs.sides; i++) {
      double currentAngle = anglePerSide * i;
      bool isFirst = i == 0;

      if (specs.borderRadiusAngle > 0) {
        _drawLineAndArc(path, currentAngle, radius, arcLength, isFirst);
      } else {
        _drawLine(path, currentAngle, radius, isFirst);
      }
    }

    return path;
  }

  _drawLine(
    Path path,
    double currentAngle,
    double radius,
    bool move,
  ) {
    Offset current = _getOffset(currentAngle, radius);
    move
        ? path.moveTo(current.dx, current.dy)
        : path.lineTo(current.dx, current.dy);
  }

  _drawLineAndArc(
    Path path,
    double currentAngle,
    double radius,
    double arcLength,
    bool isFirst,
  ) {
    double prevAngle = currentAngle - specs.halfBorderRadiusAngle;
    double nextAngle = currentAngle + specs.halfBorderRadiusAngle;

    Offset previous = _getOffset(prevAngle, radius);
    Offset next = _getOffset(nextAngle, radius);

    if (isFirst) {
      path.moveTo(next.dx, next.dy);
    } else {
      path.lineTo(previous.dx, previous.dy);
      path.arcToPoint(next, radius: Radius.circular(arcLength));
    }
  }

  double _angleToRadian(double angle) => angle * (pi / 180);

  Offset _getOffset(double angle, double radius) {
    final rotationAwareAngle =
        angle - 90 + specs.rotation;

    final radian = _angleToRadian(rotationAwareAngle);
    final x = cos(radian) * radius + radius + specs.halfBorderRadiusAngle;
    final y = sin(radian) * radius + radius + specs.halfBorderRadiusAngle;

    return Offset(x, y);
  }
}

class _PolygonPathSpecs {
  late final int sides;
  late final double rotation;
  late final double borderRadiusAngle;
  late final double halfBorderRadiusAngle;

  _PolygonPathSpecs({
    required int? sides,
    required double? rotation,
    required double? borderRadiusAngle,
  }){
    this.sides = max(3, sides ?? _kDefaultSides);
    this.rotation = rotation ?? _kDefaultRotation;
    this.borderRadiusAngle = borderRadiusAngle ?? _kDefaultBorderRadiusAngle;
    halfBorderRadiusAngle =
        (borderRadiusAngle ?? _kDefaultBorderRadiusAngle) / 2;
  }
}
