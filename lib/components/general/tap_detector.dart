import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class TapDetector extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final bool? isExpanded;
  final bool flipFocusCheck;

  const TapDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.isExpanded,
    this.flipFocusCheck = false,
  });

  @override
  State<TapDetector> createState() => _TapDetectorState();
}

class _TapDetectorState extends State<TapDetector> {
  late final StreamSubscription<bool> _keyboardSubscription;
  late bool _keyboardIsVisible;
  bool _hasFocus = false;

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
    Focus focus = Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
        _ensureVisible(context);
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (currentFocus.hasPrimaryFocus == widget.flipFocusCheck &&
              MediaQuery.of(context).viewInsets.bottom != 0) {
            currentFocus.unfocus();
          } else if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        onDoubleTap:  () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (currentFocus.hasPrimaryFocus == widget.flipFocusCheck &&
              MediaQuery.of(context).viewInsets.bottom != 0) {
            currentFocus.unfocus();
          } else if (widget.onDoubleTap != null) {
            widget.onDoubleTap!();
          }
        },
        child: IgnorePointer(
          ignoring: _hasFocus == widget.flipFocusCheck && _keyboardIsVisible,
          child: Container(
            //A 'color' is needed, as the TapDetector needs to touch something that
            // has been drawn, so the fully transparent color creates something
            // that is drawn, but not visible...
            color: const Color(0x00FFFFFF),
            child: (widget.isExpanded ?? false)
                ? Center(child: widget.child)
                : widget.child,
          ),
        ),
      ),
    );

    return (widget.isExpanded ?? false) ? Expanded(child: focus) : focus;
  }

  Future<void> _keyboardToggled() async {
    if (mounted){
      EdgeInsets edgeInsets = MediaQuery.of(context).viewInsets;
      do {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      while (mounted && MediaQuery.of(context).viewInsets != edgeInsets);
    }

    return;
  }

  Future<void> _ensureVisible(BuildContext context) async {
    // Wait for the keyboard to come into view
    await Future.any([Future.delayed(const Duration(milliseconds: 300)), _keyboardToggled()]);

    // No need to go any further if the node has not the focus
    if (!_hasFocus){
      return;
    }

    // Find the object which has the focus
    if(!mounted) return;
    final RenderObject? object = context.findRenderObject();
    if(object == null) return;
    final RenderAbstractViewport? viewport = RenderAbstractViewport.of(object);

    // If we are not working in a Scrollable, skip this routine
    if (viewport == null) { return; }

    // Get the Scrollable state (in order to retrieve its offset)
    ScrollableState? scrollableState = Scrollable.of(context);
    if (scrollableState == null) { return; }

    // Get its offset
    ScrollPosition position = scrollableState.position;
    double alignment;

    if (position.pixels > viewport.getOffsetToReveal(object, 0.0).offset) {
      // Move down to the top of the viewport
      alignment = 0.0;
    } else if (position.pixels < viewport.getOffsetToReveal(object, 1.0).offset){
      // Move up to the bottom of the viewport
      alignment = 1.0;
    } else {
      // No scrolling is necessary to reveal the child
      return;
    }

    position.ensureVisible(
      object,
      alignment: alignment,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }
}
