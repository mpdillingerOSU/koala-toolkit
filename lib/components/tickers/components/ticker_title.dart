import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/ticker.dart';

import '../../../my_constants.dart';
import '../../dropdown_list.dart';

class TickerTitle extends StatelessWidget {
  final Ticker parent;
  late final double height;
  late final double proportionality;

  TickerTitle({
    super.key,
    required this.parent,
  }) {
    height = parent.titleHeight;
    proportionality = height / Ticker.defaultTitleHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: parent.contrastTitle
            ? parent.colorTheme.titleColor
            : MyConstants.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(parent.borderRadius * .825),
          topRight: Radius.circular(parent.borderRadius * .825),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 2 * proportionality,
            blurRadius: 2 * proportionality,
            offset: Offset(
              0,
              2 * proportionality,
            ),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              SizedBox(width: height * .6),
              Expanded(
                child: Center(
                  child: Text(
                    parent.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Sans Source Pro',
                      color: parent.contrastTitle
                          ? parent.lightingTheme.backgroundColor
                          : parent.colorTheme.primaryColor,
                      fontSize: 26 * parent.proportionality,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: height * .6,
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: parent.contrastTitle
                      ? Colors.black38
                      : parent.colorTheme.primaryColor,
                  width: parent.contrastTitle
                      ? double.infinity
                      : parent.width * .875,
                  height: 3 * parent.proportionality,
                ),
              ],
            ),
          ),
          parent.hasMenu
              ? Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: height * .8,
                        child: Icon(
                          Icons.adaptive.more,
                          color: Colors.white,
                          size: height * .8,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          _buildDropdownMenu(context),
        ],
      ),
    );
  }

  Widget _buildDropdownMenu(BuildContext context) {
    if (!parent.hasMenu) return SizedBox(width: height * .6);

    double screenHeight = MediaQuery.of(context).size.height;

    List<DropdownSelection<String>> selections = [
      DropdownSelection(
        value: 'Set to Default',
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenHeight * .125,
              child: Text(
                'Set to Default',
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: Colors.black,
                  fontSize: screenHeight * .025,
                ),
              ),
            ),
            const Icon(
              Icons.factory_outlined,
              color: Colors.black,
            ),
          ],
        ),
      ),
      DropdownSelection(
        value: 'Restore',
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenHeight * .125,
              child: Text(
                'Restore',
                style: TextStyle(
                  fontFamily: 'Sans Source Pro',
                  color: Colors.black,
                  fontSize: screenHeight * .025,
                ),
              ),
            ),
            const Icon(
              Icons.restore_rounded,
              color: Colors.black,
            ),
          ],
        ),
      ),
    ];

    if (parent.canDelete) {
      selections.add(
        DropdownSelection(
          color: Colors.red,
          value: 'Delete',
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.white,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
    }

    ///Use of [Column] ensures no error for having an [Expanded] widget, the
    /// highest child of the [DropdownList] widget, being the child of the
    /// parent [Stack].
    return Column(
      children: [
        DropdownList(
          padding: EdgeInsets.zero,
          color: Colors.white,
          borderWidth: 2,
          borderRadius: 15,
          isExpanded: true,
          itemBuilder: (context) => selections,
          onSelected: (String value) {
            if (value == 'Set to Default') {
              if (parent.onSetToDefault != null) {
                parent.onSetToDefault!();
              }
            } else if (value == 'Restore') {
              if (parent.onRestore != null) {
                parent.onRestore!();
              }
            } else if (value == 'Delete') {
              if (parent.onDelete != null) {
                parent.onDelete!();
              }
            }
          },
        ),
      ],
    );
  }
}
