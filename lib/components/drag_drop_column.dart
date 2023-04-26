import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const int kDefaultDragScrollSpeed = 5;
const int kDragScrollSpeedMin = 1;
const int kDragScrollSpeedMax = 10;
const int _kDragScrollSpeedFactor = 2;
const Duration _kDragScrollRefreshDuration = Duration(milliseconds: 10);

class DragDropColumn extends StatefulWidget {
  late final List<Widget> _children;
  final ScrollController scrollController;
  final List<_DragDropSeparator> _separators = [];
  final double itemWidth;
  final double itemHeight;
  final Axis? itemMovementAxis;
  final Future<void> Function(int oldIndex, int newIndex) onDragEnd;
  final bool? dragEnabled;
  final int? dragScrollSpeed;
  //TODO: final isScrollable, so the Column becomes a ListView as such

  DragDropColumnState? _currentState;

  DragDropColumn(
    BuildContext context, {
    super.key,
    required List<Widget> children,
    required this.scrollController,
    required this.itemWidth,
    required this.itemHeight,
    required this.onDragEnd,
    this.itemMovementAxis,
    this.dragEnabled,
    this.dragScrollSpeed,
  }) {
    _children = [...children];

    if (_children.isNotEmpty) {
      _separators.add(_DragDropSeparator.first(context, parent: this));
      if (_children.length > 1) {
        _separators.add(_DragDropSeparator.second(context, parent: this));
        for (int i = 0; i < _children.length - 2; i++) {
          _separators.add(_DragDropSeparator.middle(context, parent: this));
        }
      }
      _separators.add(_DragDropSeparator.last(context, parent: this));
    }
  }

  @override
  State<DragDropColumn> createState() => DragDropColumnState();
}

class DragDropColumnState extends State<DragDropColumn> {
  final GlobalKey _columnKey = GlobalKey();
  ScrollType _scrollType = ScrollType.none;
  Timer? _timer;
  int? _dragged;
  int? _dragIndex;
  List<_DragDropItem> _items = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._currentState = this;
    _items = [];
    List<Widget> actualized = [];
    for (int i = 0; i < widget._children.length; i++) {
      actualized.add(widget._separators[i]);
      _items.add(
        _DragDropItem(
          index: i,
          parent: this,
          width: widget.itemWidth,
          height: widget.itemHeight,
          child: widget._children[i],
        ),
      );
      actualized.add(_items.last);
    }
    actualized.add(widget._separators.last);

    return Column(
      key: _columnKey,
      children: actualized,
    );
  }

  set dragged(int? index) {
    _dragged = index;
    for (int i = 0; i < widget._separators.length; i++) {
      widget._separators[i].isActive = i != _dragged;
    }
  }

  int? get dragIndex => _dragIndex;

  set dragIndex(int? index) {
    _dragIndex = index;
    if (_dragged != null && _dragIndex != null && _dragIndex == _dragged) {
      _dragIndex = _dragIndex! + 1;
    }
    for (int i = 0; i < widget._separators.length; i++) {
      widget._separators[i].isDragSelected = i == _dragIndex;
    }
  }

  Future<void> dragDropItem() async {
    if (_dragged != null && _dragIndex != null) {
      await widget.onDragEnd(
          _dragged!, _dragIndex! - (_dragIndex! >= _dragged! ? 1 : 0));
      if (!mounted) return;
      dragged = null;
      dragIndex = null;
    }
  }
}

class _DragDropItem extends StatefulWidget {
  final DragDropColumnState parent;
  final Widget child;
  final double width;
  final double height;
  late final int _index;

  _DragDropItemState? _currentState;

  _DragDropItem({
    required int index,
    required this.parent,
    required this.child,
    required this.width,
    required this.height,
  }) {
    _index = index;
  }

  bool _detectDraggable(double draggableY) =>
      _currentState?._detectDraggable(draggableY) ?? false;

  @override
  State<_DragDropItem> createState() => _DragDropItemState();
}

class _DragDropItemState extends State<_DragDropItem> {
  final GlobalKey _topDetectionKey = GlobalKey();
  final GlobalKey _bottomDetectionKey = GlobalKey();
  final GlobalKey _draggableKey = GlobalKey();
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    widget._currentState = this;

    return widget.parent.widget.dragEnabled ?? true
        ? Listener(
            onPointerMove: _dragScroll,
            child: LongPressDraggable(
              axis: widget.parent.widget.itemMovementAxis,
              dragAnchorStrategy: widget.parent.widget.itemMovementAxis == null
                  ? (Draggable<Object> _, BuildContext __, Offset ___) =>
                      Offset(widget.width / 2, widget.height / 2)
                  : null,

              ///[Material] widget ensures that widgets with an inner [TextFormField]
              /// widget or others do not cause visual errors when being dragged...
              feedback: Padding(
                padding: _itemPadding(context),
                child: Material(
                  key: _draggableKey,
                  color: Colors.transparent,
                  child: Opacity(
                    opacity: .85,
                    child: widget.child,
                  ),
                ),
              ),
              childWhenDragging: const SizedBox(),
              child: Padding(
                padding: _itemPadding(context),
                child: Stack(
                  children: [
                    widget.child,
                    Column(
                      children: [
                        DragTarget<int>(
                          key: _topDetectionKey,
                          builder: (context, _, __) {
                            return SizedBox(
                              width: widget.width,
                              height: widget.height / 2,
                            );
                          },
                          onWillAccept: (index) {
                            widget.parent.dragIndex = widget._index;
                            return true;
                          },
                        ),
                        DragTarget<int>(
                          key: _bottomDetectionKey,
                          builder: (context, _, __) {
                            return SizedBox(
                              width: widget.width,
                              height: widget.height / 2,
                            );
                          },
                          onWillAccept: (index) {
                            widget.parent.dragIndex = widget._index + 1;
                            return true;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onDragStarted: () {
                _isDragging = true;
                widget.parent.dragged = widget._index;
                widget.parent.dragIndex = widget._index;
              },
              onDragEnd: (details) async {
                _isDragging = false;
                await widget.parent.dragDropItem();
              },
            ),
          )
        : Padding(
            padding: _itemPadding(context),
            child: widget.child,
          );
  }

  double? get draggableY {
    RenderBox? draggableRender =
        _draggableKey.currentContext?.findRenderObject() as RenderBox?;

    return (draggableRender == null)
        ? null
        : draggableRender.localToGlobal(Offset.zero).dy +
            (widget.parent._scrollType == ScrollType.down ? widget.height : 0);
  }

  bool _detectDraggable(double draggableY) {
    RenderBox? render =
        _topDetectionKey.currentContext?.findRenderObject() as RenderBox?;

    if (render == null) return false;

    double y = render.localToGlobal(Offset.zero).dy;

    if (draggableY < y + (widget.height / 2)) {
      if (widget.parent.dragIndex != widget._index) {
        widget.parent.dragIndex = widget._index;
      }
      return true;
    } else if (draggableY <= y + widget.height) {
      if (widget.parent.dragIndex != widget._index + 1) {
        widget.parent.dragIndex = widget._index + 1;
      }
      return true;
    }
    return false;
  }

  void _dragScroll(PointerMoveEvent event) {
    if (!_isDragging) return;

    RenderBox? render = widget.parent._columnKey.currentContext
        ?.findRenderObject() as RenderBox?;

    if (render == null) return;

    Offset position = render.localToGlobal(Offset.zero);
    double topY = position.dy;
    double bottomY = topY + render.size.height;

    final ScrollController scrollController =
        widget.parent.widget.scrollController;
    final double step = (_kDragScrollSpeedFactor *
            (widget.parent.widget.dragScrollSpeed == null
                ? kDefaultDragScrollSpeed
                : max(
                    kDragScrollSpeedMin,
                    min(
                      widget.parent.widget.dragScrollSpeed!,
                      kDragScrollSpeedMax,
                    ),
                  )))
        .toDouble();
    double detectionRange = widget.height / 2;

    if (event.position.dy - scrollController.offset < topY + detectionRange) {
      if (widget.parent._scrollType == ScrollType.none) {
        widget.parent._scrollType = ScrollType.up;
        widget.parent._timer = Timer.periodic(
          _kDragScrollRefreshDuration,
          (timer) {
            double dest = scrollController.offset - step;
            dest = (dest < 0) ? 0 : dest;
            scrollController.jumpTo(dest);

            double? draggableY = this.draggableY;
            if (draggableY != null) {
              for (_DragDropItem item in widget.parent._items) {
                if (item._detectDraggable(draggableY)) break;
              }
            }
            if (dest == 0) {
              widget.parent._scrollType = ScrollType.none;
              widget.parent._timer!.cancel();
            }
          },
        );
      }
    } else if (event.position.dy + scrollController.position.extentAfter >
        bottomY - detectionRange) {
      if (widget.parent._scrollType == ScrollType.none) {
        widget.parent._scrollType = ScrollType.down;
        widget.parent._timer = Timer.periodic(
          _kDragScrollRefreshDuration,
          (timer) {
            double dest = scrollController.offset + step;
            dest = (dest > scrollController.position.maxScrollExtent)
                ? scrollController.position.maxScrollExtent
                : dest;
            scrollController.jumpTo(dest);
            double? draggableY = this.draggableY;
            if (draggableY != null) {
              for (_DragDropItem item in widget.parent._items) {
                if (item._detectDraggable(draggableY)) break;
              }
            }
            if (dest == scrollController.position.maxScrollExtent) {
              widget.parent._scrollType = ScrollType.none;
              widget.parent._timer!.cancel();
            }
          },
        );
      }
    } else if (widget.parent._scrollType != ScrollType.none) {
      widget.parent._scrollType = ScrollType.none;
      widget.parent._timer?.cancel();
      widget.parent._timer = null;
    }
  }
}

class _DragDropSeparator extends StatefulWidget {
  final DragDropColumn parent;
  late final Widget upperChild;
  late final Widget? secondaryUpperChild;
  late final Widget lowerChild;
  late final bool upperAlwaysVisible;
  late final bool lowerAlwaysVisible;
  late final bool isSecond;
  late final bool isLast;
  bool _isDragSelected = false;
  bool _isActive = true;

  _DragDropSeparatorState? _currentState;

  _DragDropSeparator.first(
    BuildContext context, {
    required this.parent,
  }) {
    upperChild = _StandardCushion();
    secondaryUpperChild = null;
    lowerChild = _StandardDivider();
    upperAlwaysVisible = true;
    lowerAlwaysVisible = false;
    isSecond = false;
    isLast = false;
  }

  _DragDropSeparator.second(
    BuildContext context, {
    required this.parent,
  }) {
    upperChild = _StandardDivider();
    secondaryUpperChild = _StandardCushion();
    lowerChild = _StandardDivider();
    upperAlwaysVisible = true;
    lowerAlwaysVisible = false;
    isSecond = true;
    isLast = false;
  }

  _DragDropSeparator.middle(
    BuildContext context, {
    required this.parent,
  }) {
    upperChild = _StandardDivider();
    secondaryUpperChild = null;
    lowerChild = _StandardDivider();
    upperAlwaysVisible = true;
    lowerAlwaysVisible = false;
    isSecond = false;
    isLast = false;
  }

  _DragDropSeparator.last(
    BuildContext context, {
    required this.parent,
  }) {
    upperChild = _StandardDivider();
    secondaryUpperChild = null;
    lowerChild = _StandardCushion();
    upperAlwaysVisible = false;
    lowerAlwaysVisible = true;
    isSecond = false;
    isLast = true;
  }

  set isDragSelected(bool val) {
    _isDragSelected = val;
    _currentState?.resetState();
  }

  set isActive(bool val) {
    _isActive = val;
    _currentState?.resetState();
  }

  @override
  State<_DragDropSeparator> createState() => _DragDropSeparatorState();
}

class _DragDropSeparatorState extends State<_DragDropSeparator> {
  @override
  Widget build(BuildContext context) {
    widget._currentState = this;

    if (!widget._isActive) return const SizedBox();

    return Column(
      children: [
        widget.upperAlwaysVisible || widget._isDragSelected
            ? (widget.isSecond && widget.parent._currentState?._dragged == 0)
                ? (widget.secondaryUpperChild ?? widget.upperChild)
                : (widget.isLast && widget.parent._children.length < 2)
                    ? _StandardCushion()
                    : widget.upperChild
            : const SizedBox(),
        widget._isDragSelected
            ? Padding(
                padding: _itemPadding(context),
                child: Container(
                  width: widget.parent.itemWidth,
                  height: widget.parent.itemHeight,
                  decoration: BoxDecoration(
                    color: const Color(0x802196F3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0x800040B9),
                      width: 2,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        widget.lowerAlwaysVisible || widget._isDragSelected
            ? widget.lowerChild
            : const SizedBox(),
      ],
    );
  }

  void resetState() => setState(() {});
}

class _StandardCushion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * .0135);
  }
}

class _StandardDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        screenHeight * .075,
        screenHeight * .0135,
        screenHeight * .075,
        screenHeight * .0135,
      ),
      child: Container(
        height: screenHeight * .003,
        color: const Color(0xFF575757),
      ),
    );
  }
}

EdgeInsetsGeometry _itemPadding(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  return EdgeInsets.fromLTRB(
    screenHeight * .0135,
    screenHeight * .0045,
    screenHeight * .0135,
    screenHeight * .0045,
  );
}

enum ScrollType {
  none,
  up,
  down;
}
