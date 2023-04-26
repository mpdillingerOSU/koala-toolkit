import 'dart:math';

import 'package:flutter/material.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/popup.dart';
import '../../../koala_toolkit_back_end/data/units/unit_list.dart';
import '../koala_page.dart';
import 'koala_alert.dart';

class UnitListSelectionPopup extends KoalaPage {
  final String title;
  final String actionText;
  final String confirmTitle;
  final String confirmText;
  final String popupAddendum;
  final List<UnitList> _unitLists = [];
  final UnitList? exclusion;

  UnitListSelectionPopup({
    super.key,
    required this.title,
    required this.actionText,
    required this.confirmTitle,
    required this.confirmText,
    required this.popupAddendum,
    required List<UnitList> unitLists,
    this.exclusion,
  }) {
    if (exclusion == null) {
      _unitLists.addAll(unitLists);
    } else {
      for (UnitList list in unitLists) {
        if (!list.equals(exclusion!)) {
          _unitLists.add(list);
        }
      }
    }
  }

  @override
  KoalaPageState<UnitListSelectionPopup> createState() =>
      UnitListSelectionPopupState();
}

class UnitListSelectionPopupState
    extends KoalaPageState<UnitListSelectionPopup> {
  UnitList? _selection;
  bool allowRedundancies = false;

  @override
  Future<void> subRefresh() async {}

  @override
  Widget build(BuildContext context) {
    double sizeFactor = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Popup(
      context: context,
      onContinue: () async {
        if (_selection == null) {
          bool? willCancel = await showDialog(
            context: context,
            builder: (context) => KoalaAlert(
              title: 'No Selection',
              text:
                  'No selection has been made. Do you wish to cancel ${widget.actionText}?',
            ),
          );
          if (willCancel ?? false) {
            if (!mounted) return;
            Navigator.pop(
              context,
            );
          }
        } else {
          bool? isConfirmed = await showDialog(
            context: context,
            builder: (context) => KoalaAlert(
              title: widget.confirmTitle,
              text: 'Do you wish to ${widget.confirmText} $_selection?',
            ),
          );

          if (isConfirmed ?? false) {
            if (!mounted) return;
            Navigator.pop(
              context,
              ULSPPacket(
                _selection!,
                allowRedundancies,
              ),
            );
          }
        }
      },
      title: widget.title,
      borderRadius: 25,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: sizeFactor * .01),
            child: SizedBox(
              height: sizeFactor * .1,
              child: Center(
                child: TapDetector(
                  onTap: () => setState(() {
                    allowRedundancies = !allowRedundancies;
                  }),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        allowRedundancies
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: Colors.lightBlue,
                        size: sizeFactor * .075,
                      ),
                      SizedBox(width: sizeFactor * .02),
                      Text(
                        'Allow Redundancies',
                        style: TextStyle(
                          fontFamily: 'Sans Source Pro',
                          color: Colors.blue.shade900,
                          fontSize: sizeFactor * .05,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: sizeFactor * .005,
            width: sizeFactor * .7,
            color: Colors.blue.shade900,
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              child: Column(
                children: widget._unitLists.isEmpty
                    ? [
                        SizedBox(
                          height: sizeFactor * .175,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: sizeFactor * .01875,
                            horizontal: sizeFactor * .1,
                          ),
                          child: Center(
                            child: Text(
                              'No Other Unit Lists Available',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Sans Source Pro',
                                color: Colors.grey.shade700,
                                fontSize: sizeFactor * .05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: sizeFactor * .005,
                          width: sizeFactor * .5,
                          color: Colors.grey.shade700,
                        ),
                      ]
                    : [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: sizeFactor * .01),
                          child: SizedBox(
                            height: sizeFactor * .1,
                            child: Center(
                              child: Text(
                                'Select a list to ${widget.popupAddendum}:',
                                style: TextStyle(
                                  fontFamily: 'Sans Source Pro',
                                  color: Colors.blue.shade900,
                                  fontSize: sizeFactor * .05,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: _buildSelections(sizeFactor * .2),
                          ),
                        ),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<UnitListSelection> _buildSelections(double selectionHeight) {
    List<UnitListSelection> returnList = [];
    for (int i = 0; i < widget._unitLists.length; i++) {
      returnList.add(
        UnitListSelection(
          parent: this,
          unitList: widget._unitLists[i],
          selectionHeight: selectionHeight,
          ordinal: i,
          isSelected: widget._unitLists[i] == _selection,
        ),
      );
    }
    return returnList;
  }

  void select(UnitList unitList) {
    setState(() {
      _selection = unitList;
    });
  }
}

class UnitListSelection extends StatelessWidget {
  const UnitListSelection({
    super.key,
    required this.parent,
    required this.unitList,
    required this.selectionHeight,
    required this.ordinal,
    required this.isSelected,
  });

  final UnitListSelectionPopupState parent;
  final UnitList unitList;
  final double selectionHeight;
  final int ordinal;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () => parent.select(unitList),
      child: Container(
        height: selectionHeight,
        width: double.infinity,
        padding: EdgeInsets.only(
          left: selectionHeight * .25,
          right: selectionHeight * .25,
        ),
        color: isSelected ? Colors.lightBlueAccent.shade100 : Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  unitList.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.blue.shade700 : Colors.blue,
                    fontSize: selectionHeight / 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ULSPPacket {
  final UnitList unitList;
  final bool allowRedundancies;

  ULSPPacket(
    this.unitList,
    this.allowRedundancies,
  );
}
