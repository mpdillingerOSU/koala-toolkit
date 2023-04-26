import 'dart:math';

import 'package:flutter/material.dart';

import '../../../components/general/tap_detector.dart';
import '../../../components/popup.dart';
import '../../../koala_toolkit_back_end/data/moves/move_list.dart';
import '../koala_page.dart';
import 'koala_alert.dart';

class MoveListSelectionPopup extends KoalaPage {
  final String title;
  final String actionText;
  final String confirmTitle;
  final String confirmText;
  final String popupAddendum;
  final List<MoveList> _moveLists = [];
  final MoveList? exclusion;

  MoveListSelectionPopup({
    super.key,
    required this.title,
    required this.actionText,
    required this.confirmTitle,
    required this.confirmText,
    required this.popupAddendum,
    required List<MoveList> moveLists,
    this.exclusion,
  }) {
    if (exclusion == null) {
      _moveLists.addAll(moveLists);
    } else {
      for (MoveList list in moveLists) {
        if (!list.equals(exclusion!)) {
          _moveLists.add(list);
        }
      }
    }
  }

  @override
  KoalaPageState<MoveListSelectionPopup> createState() =>
      MoveListSelectionPopupState();
}

class MoveListSelectionPopupState
    extends KoalaPageState<MoveListSelectionPopup> {
  MoveList? _selection;
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
              MLSPPacket(
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
                children: widget._moveLists.isEmpty
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
                              'No Other Move Lists Available',
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

  List<MoveListSelection> _buildSelections(double selectionHeight) {
    List<MoveListSelection> returnList = [];
    for (int i = 0; i < widget._moveLists.length; i++) {
      returnList.add(
        MoveListSelection(
          parent: this,
          moveList: widget._moveLists[i],
          selectionHeight: selectionHeight,
          ordinal: i,
          isSelected: widget._moveLists[i] == _selection,
        ),
      );
    }
    return returnList;
  }

  void select(MoveList moveList) {
    setState(() {
      _selection = moveList;
    });
  }
}

class MoveListSelection extends StatelessWidget {
  const MoveListSelection({
    super.key,
    required this.parent,
    required this.moveList,
    required this.selectionHeight,
    required this.ordinal,
    required this.isSelected,
  });

  final MoveListSelectionPopupState parent;
  final MoveList moveList;
  final double selectionHeight;
  final int ordinal;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TapDetector(
      onTap: () => parent.select(moveList),
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
                  moveList.name,
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

class MLSPPacket {
  final MoveList moveList;
  final bool allowRedundancies;

  MLSPPacket(
    this.moveList,
    this.allowRedundancies,
  );
}
