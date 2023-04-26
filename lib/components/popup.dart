import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/check_n_ex.dart';

import '../my_constants.dart';
import 'general/tap_detector.dart';

class Popup extends StatelessWidget {
  final Widget child;
  final String title;
  final double borderRadius;
  final void Function()? onContinue;
  late final double sizeFactor;
  late final double bodyHeight;

  Popup({
    super.key,
    required BuildContext context,
    this.child = const SizedBox(),
    this.title = '',
    this.borderRadius = 25,
    double? bodyHeight,
    required this.onContinue,
  }) {
    sizeFactor = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    this.bodyHeight = max(
        sizeFactor * .1, min(bodyHeight ?? sizeFactor * .7, sizeFactor * .7));
  }

  @override
  Widget build(BuildContext context) {
    /// First [TapDetector] allows us to close the popup when clicking outside
    /// of the popup itself
    return TapDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: SingleChildScrollView(
            /// Second [TapDetector] allows us to simply exits the keyboard
            /// when clicking within the dialogue itself
            child: TapDetector(
              flipFocusCheck: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  width: sizeFactor * .8,
                  height: sizeFactor * .235 + bodyHeight,
                  decoration: BoxDecoration(
                    color: MyConstants.primaryColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: sizeFactor * .094,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadius * .825),
                            topRight: Radius.circular(borderRadius * .825),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: sizeFactor * .04725,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: sizeFactor * .006,
                        width: double.infinity,
                        color: Colors.blue.shade800,
                      ),
                      SizedBox(
                        width: sizeFactor * .8,
                        height: bodyHeight,
                        child: child,
                      ),
                      CheckNEx(
                        height: sizeFactor * .135,
                        color: Colors.blue,
                        onAccept: () {
                          if (onContinue != null) onContinue!();
                        },
                        onDeny: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
