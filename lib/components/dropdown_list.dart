import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuHorizontalPadding = 16.0;
const double _kMenuDividerHeight = 16.0;
const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const double _kMenuVerticalPadding = 8.0;
const double _kMenuWidthStep = 56.0;
const double _kMenuScreenPadding = 8.0;
const double _kDefaultIconSize = 24.0;

class DropdownSelection<T> extends PopupMenuItem<T> {
  final Color color;

  const DropdownSelection({
    super.key,
    super.value,
    super.enabled,
    super.child,
    this.color = const Color(0x00FFFFFF),
  });

  @override
  DropdownSelectionState<T> createState() => DropdownSelectionState<T>();
}

class DropdownSelectionState<T> extends PopupMenuItemState<T, DropdownSelection<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: super.build(context),
    );
  }
}

/// Signature for the callback invoked when a menu item is selected. The
/// argument is the value of the [DropdownSelection] that caused its menu to be
/// dismissed.
///
/// Used by [DropdownList.onSelected].
typedef DropdownSelectionSelected<T> = void Function(T value);

/// Signature used by [DropdownList] to lazily construct the items shown when
/// the button is pressed.
///
/// Used by [DropdownList.itemBuilder].
typedef DropdownSelectionBuilder<T> = List<DropdownSelection<T>> Function(
    BuildContext context);

class DropdownList<DropdownSelection> extends StatefulWidget {
  const DropdownList({
    super.key,
    required this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.isExpanded,
    this.splashRadius,
    this.offset = Offset.zero,
    this.enabled = true,
    this.borderWidth = 2,
    this.borderRadius = 15,
    this.color,
    this.enableFeedback,
    this.constraints,
    this.position = PopupMenuPosition.over,
  });

  final DropdownSelectionBuilder<DropdownSelection> itemBuilder;

  /// The value of the menu item, if any, that should be highlighted when the menu opens.
  final DropdownSelection? initialValue;

  /// Called when the user selects a value from the popup menu created by this button.
  ///
  /// If the popup menu is dismissed without selecting a value, [onCanceled] is
  /// called instead.
  final DropdownSelectionSelected<DropdownSelection>? onSelected;

  /// Called when the user dismisses the popup menu without selecting an item.
  ///
  /// If the user selects a value, [onSelected] is called instead.
  final PopupMenuCanceled? onCanceled;

  /// Text that describes the action that will occur when the button is pressed.
  ///
  /// This text is displayed when the user long-presses on the button and is
  /// used for accessibility.
  final String? tooltip;

  /// The z-coordinate at which to place the menu when open. This controls the
  /// size of the shadow below the menu.
  ///
  /// Defaults to 8, the appropriate elevation for popup menus.
  final double? elevation;

  /// Matches IconButton's 8 dps padding by default. In some cases, notably where
  /// this button appears as the trailing element of a list item, it's useful to be able
  /// to set the padding to zero.
  final EdgeInsetsGeometry padding;

  /// The splash radius.
  ///
  /// If null, default splash radius of [InkWell] or [IconButton] is used.
  final double? splashRadius;

  /// If provided, [child] is the widget used for this button
  /// and the button will utilize an [InkWell] for taps.
  final Widget? child;

  final bool? isExpanded;

  /// The offset is applied relative to the initial position
  /// set by the [position].
  ///
  /// When not set, the offset defaults to [Offset.zero].
  final Offset offset;

  /// Whether this popup menu button is interactive.
  ///
  /// Must be non-null, defaults to `true`
  ///
  /// If `true` the button will respond to presses by displaying the menu.
  ///
  /// If `false`, the button is styled with the disabled color from the
  /// current [Theme] and will not respond to presses or show the popup
  /// menu and [onSelected], [onCanceled] and [itemBuilder] will not be called.
  ///
  /// This can be useful in situations where the app needs to show the button,
  /// but doesn't currently have anything to show in the menu.
  final bool enabled;

  final double borderWidth;
  final double borderRadius;

  /// If provided, the background color used for the menu.
  ///
  /// If this property is null, then [PopupMenuThemeData.color] is used.
  /// If [PopupMenuThemeData.color] is also null, then
  /// Theme.of(context).cardColor is used.
  final Color? color;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// Optional size constraints for the menu.
  ///
  /// When unspecified, defaults to:
  /// ```dart
  /// const BoxConstraints(
  ///   minWidth: 2.0 * 56.0,
  ///   maxWidth: 5.0 * 56.0,
  /// )
  /// ```
  ///
  /// The default constraints ensure that the menu width matches maximum width
  /// recommended by the material design guidelines.
  /// Specifying this parameter enables creation of menu wider than
  /// the default maximum width.
  final BoxConstraints? constraints;

  /// Whether the popup menu is positioned over or under the popup menu button.
  ///
  /// [offset] is used to change the position of the popup menu relative to the
  /// position set by this parameter.
  ///
  /// When not set, the position defaults to [PopupMenuPosition.over] which makes the
  /// popup menu appear directly over the button that was used to create it.
  final PopupMenuPosition position;

  @override
  DropdownListState<DropdownSelection> createState() => DropdownListState<DropdownSelection>();
}

/// The [State] for a [DropdownList].
///
/// See [showButtonMenu] for a way to programmatically open the popup menu
/// of your button state.
class DropdownListState<T> extends State<DropdownList<T>> {
  /// A method to show a popup menu with the items supplied to
  /// [DropdownList.itemBuilder] at the position of your [DropdownList].
  ///
  /// By default, it is called when the user taps the button and [DropdownList.enabled]
  /// is set to `true`. Moreover, you can open the button by calling the method manually.
  ///
  /// You would access your [DropdownListState] using a [GlobalKey] and
  /// show the menu of the button with `globalKey.currentState.showButtonMenu`.
  void showButtonMenu() {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final Offset offset;
    switch (widget.position) {
      case PopupMenuPosition.over:
        offset = widget.offset;
        break;
      case PopupMenuPosition.under:
        offset =
            Offset(0.0, button.size.height - (widget.padding.vertical / 2)) +
                widget.offset;
        break;
    }
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final List<DropdownSelection<T>> items = widget.itemBuilder(context);
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      showMenu<T?>(
        context: context,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        items: items,
        initialValue: widget.initialValue,
        position: position,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: widget.borderWidth,
            color: const Color(0xFF919191),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
        ),
        color: widget.color ?? popupMenuTheme.color,
        constraints: widget.constraints,
        borderRadius: widget.borderRadius,
      ).then<void>((T? newValue) {
        if (!mounted) return null;
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            MediaQuery.of(context).viewInsets.bottom != 0) {
          currentFocus.unfocus();
        } else {
          widget.enabled ? showButtonMenu() : null;
        }
      },
      isExpanded: widget.isExpanded ?? false,
      child: widget.child ?? const SizedBox(),
    );
  }
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({
    super.key,
    required this.onLayout,
    required Widget? child,
  }) : super(child: child);

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return Size.zero;
    }
    return child!.getDryLayout(constraints);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset.zero;
    }
    onLayout(size);
  }
}

class _PopupMenu<T> extends StatelessWidget {
  const _PopupMenu({
    super.key,
    required this.route,
    required this.semanticLabel,
    this.constraints,
    required this.borderRadius,
  });

  final _PopupMenuRoute<T> route;
  final String? semanticLabel;
  final BoxConstraints? constraints;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 / (route.items.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final List<Widget> children = <Widget>[];
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);

    for (int i = 0; i < route.items.length; i += 1) {
      final double start = (i + 1) * unit;
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      final CurvedAnimation opacity = CurvedAnimation(
        parent: route.animation!,
        curve: Interval(start, end),
      );
      Widget item = route.items[i];
      if (route.initialValue != null && route.items[i].represents(route.initialValue)) {
        item = Container(
          color: Theme.of(context).highlightColor,
          child: item,
        );
      }
      children.add(
        _MenuItem(
          onLayout: (Size size) {
            route.itemSizes[i] = size;
          },
          child: FadeTransition(
            opacity: opacity,
            child: item,
          ),
        ),
      );
    }

    final CurveTween opacity = CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height = CurveTween(curve: Interval(0.0, unit * route.items.length));

    final Widget child = ConstrainedBox(
      constraints: constraints ?? const BoxConstraints(
        minWidth: _kMenuMinWidth,
        maxWidth: _kMenuMaxWidth,
      ),
      child: IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: semanticLabel,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: _kMenuVerticalPadding,
            ),
            child: ListBody(children: children),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacity.animate(route.animation!),
          child: Material(
            shape: route.shape ?? popupMenuTheme.shape,
            color: route.color ?? popupMenuTheme.color,
            type: MaterialType.card,
            elevation: route.elevation ?? popupMenuTheme.elevation ?? 8.0,
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(route.animation!),
              heightFactor: height.evaluate(route.animation!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Stack(
                  children: [
                    Positioned.directional(
                      start: 0,
                      end: 0,
                      top: 0,
                      textDirection: TextDirection.ltr,
                      child: Container(
                        height: _kMenuVerticalPadding + 1,
                        color: route.items.first.color,
                      ),
                    ),
                    Positioned.directional(
                      start: 0,
                      end: 0,
                      bottom: 0,
                      textDirection: TextDirection.ltr,
                      child: Container(
                        height: _kMenuVerticalPadding + 1,
                        color: route.items.last.color,
                      ),
                    ),
                    child ?? const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    required this.position,
    required this.items,
    this.initialValue,
    this.elevation,
    required this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.color,
    required this.capturedThemes,
    this.constraints,
    required this.borderRadius,
  }) : itemSizes = List<Size?>.filled(items.length, null);

  final RelativeRect position;
  final List<DropdownSelection<T>> items;
  final List<Size?> itemSizes;
  final T? initialValue;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? color;
  final CapturedThemes capturedThemes;
  final BoxConstraints? constraints;
  final double borderRadius;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {

    int? selectedItemIndex;
    if (initialValue != null) {
      for (int index = 0; selectedItemIndex == null && index < items.length; index += 1) {
        if (items[index].represents(initialValue)) {
          selectedItemIndex = index;
        }
      }
    }

    final Widget menu = _PopupMenu<T>(
      route: this,
      semanticLabel: semanticLabel,
      constraints: constraints,
      borderRadius: borderRadius,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              position,
              itemSizes,
              selectedItemIndex,
              Directionality.of(context),
              mediaQuery.padding,
              _avoidBounds(mediaQuery),
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }
}

Future<T?> showMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<DropdownSelection<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
  BoxConstraints? constraints,
  required double borderRadius,
}) {
  assert(items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final NavigatorState navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(_PopupMenuRoute<T>(
    position: position,
    items: items,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: semanticLabel,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    shape: shape,
    color: color,
    capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
    constraints: constraints,
    borderRadius: borderRadius,
  ));
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
      this.position,
      this.itemSizes,
      this.selectedItemIndex,
      this.textDirection,
      this.padding,
      this.avoidBounds,
      );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The sizes of each item are computed when the menu is laid out, and before
  // the route is laid out.
  List<Size?> itemSizes;

  // The index of the selected item, or null if PopupMenuButton.initialValue
  // was not specified.
  final int? selectedItemIndex;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    final double buttonHeight = size.height - position.top - position.bottom;
    // Find the ideal vertical position.
    double y = position.top;
    if (selectedItemIndex != null) {
      double selectedItemOffset = _kMenuVerticalPadding;
      for (int index = 0; index < selectedItemIndex!; index += 1) {
        selectedItemOffset += itemSizes[index]!.height;
      }
      selectedItemOffset += itemSizes[selectedItemIndex!]!.height / 2;
      y = y + buttonHeight / 2.0 - selectedItemOffset;
    }

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }
    final Offset wantedPosition = Offset(x, y);
    final Offset originCenter = position.toRect(Offset.zero & size).center;
    final Iterable<Rect> subScreens = DisplayFeatureSubScreen.subScreensInBounds(Offset.zero & size, avoidBounds);
    final Rect subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance < (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition){
    double x = wantedPosition.dx;
    double y = wantedPosition.dy;
    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < screen.left + _kMenuScreenPadding + padding.left) {
      x = screen.left + _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width > screen.right - _kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - _kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height > screen.bottom - _kMenuScreenPadding - padding.bottom) {
      y = screen.bottom - childSize.height - _kMenuScreenPadding - padding.bottom;
    }

    return Offset(x,y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position
        || selectedItemIndex != oldDelegate.selectedItemIndex
        || textDirection != oldDelegate.textDirection
        || !listEquals(itemSizes, oldDelegate.itemSizes)
        || padding != oldDelegate.padding
        || !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }
}