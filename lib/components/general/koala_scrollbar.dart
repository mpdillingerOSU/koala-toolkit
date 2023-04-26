import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const Color _kThumbColor = Color(0xFFE0E0E0);
const double _kScrollbarThickness = 32;
const double _kScrollbarThicknessWithTrack = 36;
const double _kScrollbarMargin = 2.0;
const double _kScrollbarMinLength = 48.0;
const Radius _kScrollbarRadius = Radius.circular(8.0);
const Duration _kScrollbarFadeDuration = Duration(milliseconds: 300);
const Duration _kScrollbarTimeToFade = Duration(milliseconds: 600);

/// A Material Design scrollbar.
///
/// To add a scrollbar to a [ScrollView], wrap the scroll view
/// widget in a [KoalaScrollbar] widget.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=DbkIQSvwnZc}
///
/// {@macro flutter.widgets.Scrollbar}
///
/// Dynamically changes to a [CupertinoScrollbar], an iOS style scrollbar, by
/// default on the iOS platform.
///
/// The color of the Scrollbar thumb will change when [MaterialState.dragged],
/// or [MaterialState.hovered] on desktop and web platforms. These stateful
/// color choices can be changed using [ScrollbarThemeData.thumbColor].
///
/// {@tool dartpad}
///
/// This sample shows a [KoalaScrollbar] that executes a fade animation as scrolling
/// occurs. The Scrollbar will fade into view as the user scrolls, and fade out
/// when scrolling stops.
///
/// ** See code in examples/api/lib/material/scrollbar/scrollbar.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// When [thumbVisibility] is true, the scrollbar thumb will remain visible
/// without the fade animation. This requires that a [ScrollController] is
/// provided to controller, or that the [PrimaryScrollController] is available.
///
/// When a [ScrollView.scrollDirection] is [Axis.horizontal], it is recommended
/// that the [KoalaScrollbar] is always visible, since scrolling in the horizontal
/// axis is less discoverable.
///
/// ** See code in examples/api/lib/material/scrollbar/scrollbar.1.dart **
/// {@end-tool}
///
/// A scrollbar track can be added using [trackVisibility]. This can also be
/// drawn when triggered by a hover event, or based on any [MaterialState] by
/// using [ScrollbarThemeData.trackVisibility].
///
/// The [thickness] of the track and scrollbar thumb can be changed dynamically
/// in response to [MaterialState]s using [ScrollbarThemeData.thickness].
///
/// See also:
///
///  * [RawScrollbar], a basic scrollbar that fades in and out, extended
///    by this class to add more animations and behaviors.
///  * [ScrollbarTheme], which configures the Scrollbar's appearance.
///  * [ListView], which displays a linear, scrollable list of children.
///  * [GridView], which displays a 2 dimensional, scrollable array of children.
class KoalaScrollbar extends StatelessWidget {
  /// Creates a material design scrollbar that by default will connect to the
  /// closest Scrollable descendant of [child].
  ///
  /// The [child] should be a source of [ScrollNotification] notifications,
  /// typically a [Scrollable] widget.
  ///
  /// If the [controller] is null, the default behavior is to
  /// enable scrollbar dragging using the [PrimaryScrollController].
  ///
  /// When null, [thickness] defaults to 8.0 pixels on desktop and web, and 4.0
  /// pixels when on mobile platforms. A null [radius] will result in a default
  /// of an 8.0 pixel circular radius about the corners of the scrollbar thumb,
  /// except for when executing on [TargetPlatform.android], which will render the
  /// thumb without a radius.
  const KoalaScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.thumbColor,
    this.notificationPredicate,
    this.interactive,
    this.scrollbarOrientation,
  }) : assert(
            thumbVisibility == null,
            'Scrollbar thumb appearance should only be controlled with thumbVisibility, '
            'isAlwaysShown is deprecated.');

  /// {@macro flutter.widgets.Scrollbar.child}
  final Widget child;

  /// {@macro flutter.widgets.Scrollbar.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.Scrollbar.thumbVisibility}
  ///
  /// If this property is null, then [ScrollbarThemeData.thumbVisibility] of
  /// [ThemeData.scrollbarTheme] is used. If that is also null, the default value
  /// is false.
  ///
  /// If the thumb visibility is related to the scrollbar's material state,
  /// use the global [ScrollbarThemeData.thumbVisibility] or override the
  /// sub-tree's theme data.
  final bool? thumbVisibility;

  /// {@macro flutter.widgets.Scrollbar.trackVisibility}
  ///
  /// If this property is null, then [ScrollbarThemeData.trackVisibility] of
  /// [ThemeData.scrollbarTheme] is used. If that is also null, the default value
  /// is false.
  ///
  /// If the track visibility is related to the scrollbar's material state,
  /// use the global [ScrollbarThemeData.trackVisibility] or override the
  /// sub-tree's theme data.
  final bool? trackVisibility;

  /// The thickness of the scrollbar in the cross axis of the scrollable.
  ///
  /// If null, the default value is 24.0 pixels.
  final double? thickness;

  /// The color of the thumb when it is visible.
  ///
  /// If null, the default color is #FFE0E0E0.
  final Color? thumbColor;

  /// {@macro flutter.widgets.Scrollbar.interactive}
  final bool? interactive;

  /// {@macro flutter.widgets.Scrollbar.notificationPredicate}
  final ScrollNotificationPredicate? notificationPredicate;

  /// {@macro flutter.widgets.Scrollbar.scrollbarOrientation}
  final ScrollbarOrientation? scrollbarOrientation;

  @override
  Widget build(BuildContext context) {
    return _MaterialScrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      thickness: thickness,
      thumbColor: thumbColor,
      notificationPredicate: notificationPredicate,
      interactive: interactive,
      scrollbarOrientation: scrollbarOrientation,
      child: child,
    );
  }
}

class _MaterialScrollbar extends RawScrollbar {
  const _MaterialScrollbar({
    super.key,
    required Widget child,
    ScrollController? controller,
    bool? thumbVisibility,
    bool? trackVisibility,
    double? thickness,
    Color? thumbColor,
    ScrollNotificationPredicate? notificationPredicate,
    bool? interactive,
    ScrollbarOrientation? scrollbarOrientation,
  }) : super(
          child: child,
          controller: controller,
          thumbVisibility: thumbVisibility,
          thickness: thickness ?? _kScrollbarThickness,
          thumbColor: thumbColor ?? _kThumbColor,
          shape: const CircleBorder(),
          trackVisibility: trackVisibility,
          fadeDuration: _kScrollbarFadeDuration,
          timeToFade: _kScrollbarTimeToFade,
          pressDuration: Duration.zero,
          notificationPredicate:
              notificationPredicate ?? defaultScrollNotificationPredicate,
          interactive: interactive,
          scrollbarOrientation: scrollbarOrientation,
        );

  @override
  _MaterialScrollbarState createState() => _MaterialScrollbarState();
}

class _MaterialScrollbarState extends RawScrollbarState<_MaterialScrollbar> {
  late AnimationController _hoverAnimationController;
  bool _dragIsActive = false;
  bool _hoverIsActive = false;
  late ColorScheme _colorScheme;
  late ScrollbarThemeData _scrollbarTheme;
  // On Android, scrollbars should match native appearance.
  late bool _useAndroidScrollbar;

  @override
  bool get showScrollbar =>
      widget.thumbVisibility ??
      _scrollbarTheme.thumbVisibility?.resolve(_states) ??
      false;

  @override
  bool get enableGestures =>
      widget.interactive ??
      _scrollbarTheme.interactive ??
      !_useAndroidScrollbar;

  MaterialStateProperty<bool> get _trackVisibility =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        return widget.trackVisibility ??
            _scrollbarTheme.trackVisibility?.resolve(states) ??
            false;
      });

  Set<MaterialState> get _states => <MaterialState>{
        if (_dragIsActive) MaterialState.dragged,
        if (_hoverIsActive) MaterialState.hovered,
      };

  MaterialStateProperty<Color> get _trackColor {
    final Color onSurface = _colorScheme.onSurface;
    final Brightness brightness = _colorScheme.brightness;
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (showScrollbar && _trackVisibility.resolve(states)) {
        return _scrollbarTheme.trackColor?.resolve(states) ??
            (brightness == Brightness.light
                ? onSurface.withOpacity(0.03)
                : onSurface.withOpacity(0.05));
      }
      return const Color(0x00000000);
    });
  }

  MaterialStateProperty<Color> get _trackBorderColor {
    final Color onSurface = _colorScheme.onSurface;
    final Brightness brightness = _colorScheme.brightness;
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (showScrollbar && _trackVisibility.resolve(states)) {
        return _scrollbarTheme.trackBorderColor?.resolve(states) ??
            (brightness == Brightness.light
                ? onSurface.withOpacity(0.1)
                : onSurface.withOpacity(0.25));
      }
      return const Color(0x00000000);
    });
  }

  MaterialStateProperty<double> get _thickness {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) &&
          _trackVisibility.resolve(states)) {
        return _scrollbarTheme.thickness?.resolve(states) ??
            _kScrollbarThicknessWithTrack;
      }
      // The default scrollbar thickness is smaller on mobile.
      return widget.thickness ??
          _scrollbarTheme.thickness?.resolve(states) ??
          (_kScrollbarThickness / (_useAndroidScrollbar ? 2 : 1));
    });
  }

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _hoverAnimationController.addListener(() {
      updateScrollbarPainter();
    });
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _colorScheme = theme.colorScheme;
    _scrollbarTheme = theme.scrollbarTheme;
    switch (theme.platform) {
      case TargetPlatform.android:
        _useAndroidScrollbar = true;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        _useAndroidScrollbar = false;
        break;
    }
    super.didChangeDependencies();
  }

  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = widget.thumbColor ?? _kThumbColor
      ..trackColor = _trackColor.resolve(_states)
      ..trackBorderColor = _trackBorderColor.resolve(_states)
      ..textDirection = Directionality.of(context)
      ..thickness = _thickness.resolve(_states)
      ..radius = widget.radius ??
          _scrollbarTheme.radius ??
          (_useAndroidScrollbar ? null : _kScrollbarRadius)
      ..crossAxisMargin = _scrollbarTheme.crossAxisMargin ??
          (_useAndroidScrollbar ? 0.0 : _kScrollbarMargin)
      ..mainAxisMargin = _scrollbarTheme.mainAxisMargin ?? 0.0
      ..minLength = _scrollbarTheme.minThumbLength ?? _kScrollbarMinLength
      ..padding = MediaQuery.of(context).padding
      ..scrollbarOrientation = widget.scrollbarOrientation
      ..ignorePointer = !enableGestures;
  }

  @override
  void handleThumbPressStart(Offset localPosition) {
    super.handleThumbPressStart(localPosition);
    setState(() {
      _dragIsActive = true;
    });
  }

  @override
  void handleThumbPressEnd(Offset localPosition, Velocity velocity) {
    super.handleThumbPressEnd(localPosition, velocity);
    setState(() {
      _dragIsActive = false;
    });
  }

  @override
  void handleHover(PointerHoverEvent event) {
    super.handleHover(event);
    // Check if the position of the pointer falls over the painted scrollbar
    if (isPointerOverScrollbar(event.position, event.kind, forHover: true)) {
      // Pointer is hovering over the scrollbar
      setState(() {
        _hoverIsActive = true;
      });
      _hoverAnimationController.forward();
    } else if (_hoverIsActive) {
      // Pointer was, but is no longer over painted scrollbar.
      setState(() {
        _hoverIsActive = false;
      });
      _hoverAnimationController.reverse();
    }
  }

  @override
  void handleHoverExit(PointerExitEvent event) {
    super.handleHoverExit(event);
    setState(() {
      _hoverIsActive = false;
    });
    _hoverAnimationController.reverse();
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    super.dispose();
  }
}
