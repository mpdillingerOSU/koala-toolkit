import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';

import 'flex_box.dart';

const Color _kDefaultActiveColor = Color(0xFF03A9F4);
const Color _kDefaultInactiveColor = Color(0xFF757575);
const Color _kDefaultBarColor = Color(0xFFFFFDE7);

/// The height of the navigation bar.
const double _kBottomNavigationBarHeight = 56.0;

class IconNavButton extends NavButton {
  IconNavButton(
    BuildContext context, {
    super.key,
    required super.label,
    required super.onPressed,
    required IconData icon,
    bool? isActive,
    super.activeColor,
    super.inactiveColor,
  }) : super(
          isExpanded: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: _kBottomNavigationBarHeight * .2,
              ),
              Icon(
                icon,
                color: (isActive != null && isActive)
                    ? (activeColor ?? _kDefaultActiveColor)
                    : (inactiveColor ?? _kDefaultInactiveColor),
                size: _kBottomNavigationBarHeight * .5,
              ),
              SizedBox(
                height: _kBottomNavigationBarHeight* .2,
                child: Column(
                  children: [
                    SizedBox(
                      height: _kBottomNavigationBarHeight * .025,
                    ),
                    (isActive != null && isActive)
                        ? Container(
                            height: _kBottomNavigationBarHeight * .035,
                            width: _kBottomNavigationBarHeight * .5,
                            color: activeColor ?? _kDefaultActiveColor,
                          )
                        : const SizedBox(),
                    const FlexBox(1),
                  ],
                ),
              ),
            ],
          ),
        );

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: onPressed,
      isExpanded: isExpanded,
      child: child,
    );
  }
}

class TextNavButton extends NavButton {
  TextNavButton(
    BuildContext context, {
    super.key,
    required super.label,
    required super.onPressed,
    required String text,
    Color? textColor,
  }) : super(
          activeColor: textColor,
          inactiveColor: textColor,
          isExpanded: true,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _kBottomNavigationBarHeight * .35,
              fontWeight: FontWeight.bold,
              color: textColor ?? _kDefaultActiveColor,
            ),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: onPressed,
      isExpanded: isExpanded,
      child: child,
    );
  }
}

abstract class NavButton extends StatelessWidget {
  final String label;
  NavBar? _parent;
  final VoidCallback onPressed;
  final Widget child;
  final bool isExpanded;
  final Color? activeColor;
  final Color? inactiveColor;

  NavButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.child,
    this.activeColor,
    this.inactiveColor,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: onPressed,
      isExpanded: isExpanded,
      child: child,
    );
  }
}

class IconNavBar extends NavBar {
  IconNavBar(
    super.context, {
    super.key,
    List<IconNavButton>? children,
    super.barColor,
  }) : super(
          children: children,
        );
}

class TextNavBar extends NavBar {
  TextNavBar(
    super.context, {
    super.key,
    required VoidCallback onPressed,
    required String text,
    Color? textColor,
    super.barColor,
  }) : super(
          children: [
            TextNavButton(
              context,
              label: text,
              onPressed: onPressed,
              text: text,
              textColor: textColor,
            ),
          ],
        );
}

abstract class NavBar extends StatelessWidget {
  late final List<NavButton> _children;
  late final Color barColor;
  double _bottomPadding = 0;

  NavBar(
    BuildContext context, {
    super.key,
    List<NavButton>? children,
    Color? barColor,
  }) {
    _children = [...?children];
    for (NavButton button in _children) {
      button._parent = this;
    }
    this.barColor = barColor ?? _kDefaultBarColor;
  }

  double get height => _kBottomNavigationBarHeight + _bottomPadding;

  @override
  Widget build(BuildContext context) {
    _bottomPadding = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: _kBottomNavigationBarHeight + _bottomPadding,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: _kBottomNavigationBarHeight,
            color: barColor,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _children,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
  static double calculateHeight(BuildContext context) {
    return (max(MediaQuery.of(context).size.height * .085,
            MediaQuery.of(context).size.width * .085))
        .round()
        .toDouble();
  }
   */
}
