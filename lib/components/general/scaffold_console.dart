import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';

import '../../my_constants.dart';
import '../tickers/interactables/ticker_listener.dart';

class ScaffoldConsole extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  late final BoxDecoration decoration;
  final String? message;
  final IconData? messageIcon;
  late final String? messagePopupTitle;
  final String? messagePopupText;

  ScaffoldConsole({
    super.key,
    required this.child,
    this.scrollController,
    BoxDecoration? decoration,
    this.message,
    this.messageIcon,
    String? messagePopupTitle,
    this.messagePopupText,
  }) {
    this.messagePopupTitle = messagePopupTitle ?? message;
    this.decoration = decoration ??
        BoxDecoration(
          color: MyConstants.primaryColor,
          borderRadius: BorderRadius.circular(25 * .8),
          border: Border.all(
            color: MyConstants.borderColor,
            width: 3,
          ),
        );
  }

  @override
  State<ScaffoldConsole> createState() => _ScaffoldConsoleState();
}

class _ScaffoldConsoleState extends State<ScaffoldConsole> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingValue = max(screenWidth * .05, screenHeight * .05);
    final double messageVertPadding = screenHeight * .025;
    final double messageHorzPadding = screenWidth * .15;
    final double messageHeight = screenHeight * .085;
    final bool hasMessage =
        widget.message != null || widget.messageIcon != null;
    final double topSpacing = paddingValue;

    return LayoutBuilder(builder: (context, constraints) {
      /// [minHeight] is calculated outside of the [ConstrainedBox], as
      /// that itself is contained in a [ListView], which then warps the
      /// necessary dimensions
      final double upperMaxHeight = constraints.maxHeight;
      final double upperMaxWidth = constraints.maxWidth;
      double minHeight = constraints.maxHeight - (paddingValue * 2);

      return SingleChildScrollView(
        controller: widget.scrollController ?? ScrollController(),
        padding: EdgeInsets.fromLTRB(
          paddingValue,
          hasMessage ? 0 : paddingValue,
          paddingValue,
          paddingValue,
        ),
        child: TickerListener(
          onNotification: (notification) {
            setState(() {});
            return true;
          },
          child: Column(
            children: [
              Visibility(
                visible: hasMessage,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    messageHorzPadding,
                    paddingValue,
                    messageHorzPadding,
                    messageVertPadding,
                  ),
                  child: TapDetector(
                    onTap: () {
                      if (widget.messagePopupTitle != null ||
                          widget.messagePopupText != null) {
                        showDialog(
                          context: context,
                          builder: (context) => KoalaSimpleAlert(
                            title: widget.messagePopupTitle ?? '',
                            text: widget.messagePopupText ?? '',
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: widget.decoration,
                      padding: EdgeInsets.symmetric(
                        vertical: messageHeight * .2,
                        horizontal: messageHeight * .275,
                      ),
                      child: LayoutBuilder(builder: (context, constraints) {
                        minHeight = upperMaxHeight -
                            (constraints.maxHeight +
                                paddingValue +
                                messageVertPadding);
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.messageIcon != null
                                ? Icon(
                                    widget.messageIcon,
                                    color: Colors.lightBlue,
                                    size: messageHeight * .525,
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: widget.messageIcon != null &&
                                      widget.message != null
                                  ? messageHeight * .1
                                  : 0,
                            ),
                            widget.message != null
                                ? ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: (upperMaxWidth -
                                              (messageHorzPadding * 2)) *
                                          .45,
                                    ),
                                    child: Text(
                                      widget.message!,
                                      textAlign: TextAlign.center,
                                      textWidthBasis:
                                          TextWidthBasis.longestLine,
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontFamily: 'Sans Source Pro',
                                        fontSize: messageHeight * .325,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: Container(
                  decoration: widget.decoration,
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
