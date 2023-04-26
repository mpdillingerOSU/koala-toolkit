import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';

import '../public_app_bar.dart';
import 'keyboard_padding.dart';
import 'nav_bar.dart';

class AdvancedScaffold extends StatelessWidget {
  final String pageTitle;
  final Widget? titleAlt;
  final void Function()? onTitleTap;
  late final List<Widget> _actions;
  final Color barColor;
  final Color barTextColor;
  final Widget? appBarExpansion;
  final Widget body;
  final NavBar? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  late final List<Color> _backgroundGradient;
  late final List<IconData>? _backgroundIcons;
  final String? overlayImage;
  final Future<bool> Function()? onWillPop;

  AdvancedScaffold({
    super.key,
    this.pageTitle = '',
    List<Widget> actions = const [],
    this.barColor = Colors.white,
    this.barTextColor = Colors.lightBlue,
    double actionMargin = 20,
    this.titleAlt,
    this.onTitleTap,
    this.appBarExpansion,
    required this.body,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.bottomNavigationBar,
    List<Color> backgroundGradient = const [
      Color(0xFF1976D2),
      Color(0xFF2196F3),
      Color(0xFF03A9F3),
      Color(0xFF40C4FF),
      Color(0xFF40C4FF),
      Color(0xFF40C4FF),
    ],
    List<IconData>? backgroundIcons,
    this.overlayImage,
    this.onWillPop,
  }) {
    _actions = [...actions] + [SizedBox(width: actionMargin)];
    _backgroundGradient = [...backgroundGradient];
    _backgroundIcons = backgroundIcons == null ? null : [...backgroundIcons];
  }

  Future<bool> _defaultOnWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double sizeFactor = min(screenWidth, screenHeight);

    return WillPopScope(
      onWillPop: onWillPop ?? _defaultOnWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _TapAppBar(
          centerTitle: true,
          title: TapDetector(
            onTap: onTitleTap,
            child: titleAlt ??
                Text(
                  pageTitle,
                  style: TextStyle(
                    color: barTextColor,
                  ),
                ),
          ),
          actions: _actions,
          backgroundColor: barColor,
          iconTheme: IconThemeData(
            color: barTextColor,
          ),
          elevation: appBarExpansion == null ? null : 0,
        ),
        body: TapDetector(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _backgroundGradient,
                  ),
                ),
              ),
              _backgroundIcons == null
                  ? const SizedBox()
                  : _AnimatedBackground(
                      backgroundIcons: _backgroundIcons!,
                    ),
              overlayImage != null
                  ? Positioned.fill(
                      child: Opacity(
                        opacity: .38,
                        child: Image.asset(
                          overlayImage!,
                          repeat: ImageRepeat.repeat,
                          scale: .55,
                        ),
                      ),
                    )
                  : const SizedBox(),
              Column(
                children: [
                  /// Use of [Visibility] widget allows us to ensure that the
                  /// height of [appBarExpansion] is taken into account when
                  /// calculating the offset of the body from the top
                  appBarExpansion != null
                      ? Visibility(
                          visible: false,
                          maintainState: true,
                          maintainAnimation: true,
                          maintainSize: true,
                          child: appBarExpansion ?? const SizedBox(),
                        )
                      : const SizedBox(),
                  Expanded(child: body),
                  KeyboardPadding(this),
                ],
              ),
              Column(
                children: [
                  appBarExpansion != null
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 0,
                                blurRadius: screenHeight * .006,
                                offset: Offset(
                                  0,
                                  screenHeight * .006,
                                ),
                              ),
                            ],
                          ),
                          child: appBarExpansion,
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

class _AnimatedBackground extends StatefulWidget {
  late final List<IconData> _backgroundIcons;

  _AnimatedBackground({
    required List<IconData> backgroundIcons,
  }) {
    _backgroundIcons = [...backgroundIcons];
  }

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animator;

  @override
  initState() {
    super.initState();
    _animator = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  dispose() {
    _animator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double sizeFactor = min(screenWidth, screenHeight);
    double iconHeight = sizeFactor / 5;
    double boxWidth = screenWidth * 1.2;
    double iconWidth = boxWidth / 5;

    return OverflowBox(
      maxWidth: boxWidth,
      child: SizedBox(
        width: boxWidth,
        height: screenHeight,
        child: Wrap(
          children: List<Widget>.generate(
            2000,
            (int index) {
              return SizedBox(
                width: iconWidth,
                height: iconHeight,
                child: Center(
                  child: Icon(
                    widget._backgroundIcons[
                        (index ~/ 2) % widget._backgroundIcons.length],
                    color: index % 2 == 0 ? Colors.white38 : Colors.transparent,
                    size: iconHeight,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    /*
    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromLTRB(0, 0, 0, 0),
        end: RelativeRect.fromLTRB(-sizeFactor, 0, 0, 0),
      ).animate(
        CurvedAnimation(
          parent: _animator,
          curve: Curves.linear,
        ),
      ),
      child: OverflowBox(
        maxWidth: boxWidth,
        child: SizedBox(
          width: boxWidth,
          height: screenHeight,
          child: Wrap(
            children: List<Widget>.generate(
              2000,
              (int index) {
                return SizedBox(
                  width: iconWidth,
                  height: iconHeight,
                  child: Icon(
                    widget._backgroundIcons[
                        (index ~/ 2) % widget._backgroundIcons.length],
                    color: index % 2 == 0 ? Colors.white38 : Colors.transparent,
                    size: iconHeight,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    */
  }
}

class _TapAppBar extends PublicAppBar {
  _TapAppBar({
    super.title,
    super.actions,
    super.elevation,
    super.backgroundColor,
    super.iconTheme,
    super.centerTitle,
  });

  @override
  _TapAppBarState createState() => _TapAppBarState();
}

class _TapAppBarState extends PublicAppBarState {
  late final StreamSubscription<bool> _keyboardSubscription;
  late bool _keyboardIsVisible;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardIsVisible = keyboardVisibilityController.isVisible;
    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((isVisible) {
      setState(() {
        _keyboardIsVisible = isVisible;
      });
    });
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        super.build(context),
        /*
        Positioned.fill(
          child: TapDetector(
            onTap: () {
              print('I\'m here!');
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
         */
      ],
    );
  }
}
