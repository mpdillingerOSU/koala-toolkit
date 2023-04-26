import 'dart:math';

import 'package:flutter/material.dart';
import '../koala_popup.dart';

class KoalaAlert extends StatelessWidget {
  final String title;
  final String text;

  const KoalaAlert({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double sizeFactor = min(screenWidth, screenHeight);

    return KoalaPopup(
      height: sizeFactor * .7,
      onAccept: () => Navigator.pop(context, true),
      onDeny: () => Navigator.pop(context, false),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              textAlign: TextAlign.left,
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                fontFamily: 'Sans Source Pro',
                color: const Color(0xC4000000),
                fontSize: sizeFactor * .08,
              ),
            ),
          ),
          SizedBox(
            height: sizeFactor * .045,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(sizeFactor * .01),
            child: SingleChildScrollView(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: const Color(0xC4000000),
                  fontSize: sizeFactor * .04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KoalaSimpleAlert extends StatelessWidget {
  final String title;
  final String text;

  const KoalaSimpleAlert({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double sizeFactor = min(screenWidth, screenHeight);

    return KoalaSimplePopup(
      height: sizeFactor * .7,
      onClose: () => Navigator.pop(context),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              textAlign: TextAlign.left,
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                fontFamily: 'Sans Source Pro',
                color: const Color(0xC4000000),
                fontSize: sizeFactor * .08,
              ),
            ),
          ),
          SizedBox(
            height: sizeFactor * .045,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(sizeFactor * .01),
            child: SingleChildScrollView(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: const Color(0xC4000000),
                  fontSize: sizeFactor * .04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
