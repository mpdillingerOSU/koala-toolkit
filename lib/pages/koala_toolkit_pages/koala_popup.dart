import 'dart:math';

import 'package:flutter/material.dart';

import '../../../components/general/check_n_ex.dart';
import '../../../components/general/tap_detector.dart';
import '../../../my_constants.dart';

class KoalaPopup extends StatelessWidget {
  final Widget child;
  final double height;
  final void Function() onAccept;
  final void Function() onDeny;

  const KoalaPopup({
    super.key,
    required this.child,
    required this.height,
    required this.onAccept,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double sizeFactor = min(screenWidth, screenHeight);

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
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: screenWidth - sizeFactor * .1,
              height: height,
              decoration: BoxDecoration(
                color: MyConstants.primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(sizeFactor * .05),
                      child: child,
                    ),
                  ),
                  CheckNEx(
                    onAccept: onAccept,
                    onDeny: onDeny,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KoalaSimplePopup extends StatelessWidget {
  final Widget child;
  final double height;
  final void Function() onClose;

  const KoalaSimplePopup({
    super.key,
    required this.child,
    required this.height,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double sizeFactor = min(screenWidth, screenHeight);

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
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: screenWidth - sizeFactor * .1,
              height: height,
              decoration: BoxDecoration(
                color: MyConstants.primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(sizeFactor * .05),
                      child: child,
                    ),
                  ),
                  Closer(
                    onClose: onClose,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}