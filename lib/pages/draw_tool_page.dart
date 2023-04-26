import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/my_constants.dart';

import '../components/general/advanced_scaffold.dart';

class DrawToolPage extends StatefulWidget {
  const DrawToolPage({
    super.key,
  });

  @override
  State<DrawToolPage> createState() => DrawToolPageState();
}

class DrawToolPageState extends State<DrawToolPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return AdvancedScaffold(
      pageTitle: 'Draw Tool',
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(max(screenWidth * .05, screenHeight * .05)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: MyConstants.primaryColor,
              borderRadius: BorderRadius.circular(12.5),
              border: Border.all(
                color: MyConstants.borderColor,
                width: 3,
              ),
            ),
            child: GestureDetector(
              onPanDown: (details) {},
              onPanUpdate: (details) {},
              onPanEnd: (details) {},
              child: const CustomPaint(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: null,
    );
  }
}
