import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'advanced_scaffold.dart';

class KeyboardPadding extends StatefulWidget {
  AdvancedScaffold scaffold;
  KeyboardPadding(
    this.scaffold, {
    super.key,
  });

  @override
  State<KeyboardPadding> createState() => _KeyboardPaddingState();
}

class _KeyboardPaddingState extends State<KeyboardPadding> {
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
    return SizedBox(
        height: _keyboardIsVisible
            ? max(
                0,
                MediaQuery.of(context).viewInsets.bottom -
                    (widget.scaffold.bottomNavigationBar?.height ?? 0))
            : 0);
  }
}
