import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/universal_nav_bar.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/home/project_home_page.dart';

import '../../../components/drag_drop_column.dart';
import '../../../components/general/koala_scrollbar.dart';
import '../../../components/cards/move_list_card.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/popup.dart';
import '../../../components/tickers/ticker_text_field.dart';
import '../../../koala_strings.dart';
import '../../../koala_toolkit_back_end/data/moves/move.dart';
import '../../../koala_toolkit_back_end/data/moves/move_list.dart';
import '../../../koala_toolkit_back_end/data/units/unit.dart';
import '../../../koala_toolkit_back_end/data/units/unit_list.dart';
import '../../../koala_toolkit_back_end/export/move_list_exporter.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../my_constants.dart';
import '../popups/export_popup.dart';
import '../koala_page.dart';
import '../../../koala_toolkit_back_end/validation_texts.dart';
import '../popups/koala_alert.dart';
import '../popups/rename_popup.dart';
import 'move_list_page.dart';
import '../popups/move_list_selection_popup.dart';

class MoveRolodexPage extends KoalaPage {
  final ProjectPacket project;

  const MoveRolodexPage(this.project, {super.key});

  @override
  KoalaPageState<MoveRolodexPage> createState() => MoveRolodexPageState();
}

class MoveRolodexPageState extends KoalaPageState<MoveRolodexPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Future<void> subRefresh() async {}

  @override
  void initState() {
    super.initState();
    refreshPage(() async {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return AdvancedScaffold(
      pageTitle: 'Move Lists',
      barColor: Colors.blue,
      barTextColor: MyConstants.primaryColor,
      onWillPop: () async {
        await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'Home'),
              builder: (context) => ProjectHomePage(widget.project),
            ),
            (Route<dynamic> route) => false);
        return false;
      },
      actions: [
        TapDetector(
          onTap: () async {
            await pushNamedPage('/settings');
          },
          child: const Center(
            child: Icon(
              Icons.settings_sharp,
              color: MyConstants.primaryColor,
              size: 32,
            ),
          ),
        ),
      ],
      body: Stack(
        children: [
          Visibility(
            visible: !isLoading,
            child: Scrollbar(
              child: Container(
                color: Colors.white,
                child: ListView(
                  controller: _scrollController,
                  children: !widget.project.hasMoveLists
                      ? [
                          Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: screenHeight * .125,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * .01875,
                                  horizontal:
                                      MediaQuery.of(context).size.width * .1,
                                ),
                                child: Center(
                                  child: Text(
                                    'Move Rolodex is Empty',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Sans Source Pro',
                                      color: Colors.grey,
                                      fontSize: screenHeight * .0375,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: screenHeight * .005,
                                width: MediaQuery.of(context).size.width * .6,
                                color: Colors.grey,
                              )
                            ],
                          )),
                        ]
                      : [_buildRolodex()],
                ),
              ),
            ),
          ),
          loadingScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3415C0),
        onPressed: () => _addMoveList(context),
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'New List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: UniversalNavBar(
        context,
        project: widget.project,
        selection: 'Moves',
        onWillPush: () async => true,
      ),
    );
  }

  DragDropColumn _buildRolodex() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemWidth = screenWidth - screenHeight * .027;
    final double itemHeight = screenHeight * .3;

    List<MoveListCard> cards = [];
    List<MoveList> moveLists = widget.project.moveLists;
    for (int i = 0; i < moveLists.length; i++) {
      MoveList moveList = moveLists[i];
      cards.add(
        MoveListCard(
          moveList: moveList,
          width: itemWidth,
          height: itemHeight,
          lightingTheme: lightingTheme,
          onIndexChange: (newIndex) async {
            await _changeMoveListIndex(moveList.listNum, newIndex);
          },
          onOpen: () async {
            await _openMoveList(moveList);
          },
          onRename: () async {
            await _renameMoveList(moveList);
          },
          onDuplicate: () async {
            await _duplicateMoveList(moveList);
          },
          onCopyAll: () async {
            await _copyAll(moveList);
          },
          onMerge: () async {
            await _mergeMoveList(moveList);
          },
          onExport: () async {
            await _exportMoveList(moveList);
          },
          onDelete: () async {
            await _deleteMoveList(moveList);
          },
        ),
      );
    }

    return DragDropColumn(
      context,
      scrollController: _scrollController,
      itemMovementAxis: Axis.vertical,
      dragScrollSpeed: dragScrollSpeed,
      onDragEnd: (int oldIndex, int newIndex) async {
        await _changeMoveListIndex(oldIndex + 1, newIndex + 1);
      },
      itemWidth: itemWidth,
      itemHeight: itemHeight,
      children: cards,
    );
  }

  Future<void> _changeMoveListIndex(int oldIndex, int newIndex) async {
    if (oldIndex != newIndex) {
      await refreshPage(() async {
        await widget.project.changeMoveListIndex(oldIndex, newIndex);
      });
    }
  }

  Future<void> _addMoveList(BuildContext context) async {
    String initialName = 'unnamed';
    if (widget.project.isMoveListNameTaken(initialName)) {
      int num = 2;
      while (widget.project.isMoveListNameTaken('$initialName$num')) {
        num++;
      }
      initialName = '$initialName$num';
    }

    final String? result = await showDialog(
      context: context,
      builder: (context) => _NewMoveListPopup(
        parent: this,
        initialName: initialName,
      ),
    );

    if (!mounted) return;
    if (result != null) {
      MoveList newList = await widget.project.addMoveList(result);
      displaySnackBar('Move List Added: $result');
      if (!mounted) return;
      await _openMoveList(newList);
    }
  }

  Future<void> _openMoveList(MoveList moveList) async {
    await pushPage(
      MoveListPage(
        widget.project,
        moveList,
      ),
    );
    await refreshPage(() async {});
  }

  Future<void> _renameMoveList(MoveList moveList) async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename List',
        initialValue: moveList.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !widget.project.isMoveListNameTaken(
                value,
                givenMoveList: moveList.name,
              );
        },
        validationText: ValidationTexts.invalidMoveListName,
      ),
    );

    if (result != null && result != moveList.name) {
      await refreshPage(() async {
        await widget.project.renameMoveList(moveList, result);
      });
      displaySnackBar('Move List Renamed: $result');
    }
  }

  Future<void> _duplicateMoveList(MoveList moveList) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => KoalaAlert(
        title: 'Duplicate Move List',
        text: 'Do you wish to duplicate $moveList?',
      ),
    ) ?? false;

    if (confirm) {
      await refreshPage(() async {
        await widget.project.duplicateMoveList(moveList);
      });
      displaySnackBar('Move List Duplicated: $moveList');
    }
  }

  Future<void> _copyAll(MoveList moveList) async {
    final MLSPPacket? packet = await showDialog(
      context: context,
      builder: (context) => MoveListSelectionPopup(
        title: 'Copy All',
        actionText: 'copying all moves in this list into another',
        confirmTitle: 'Confirm Copy All',
        confirmText: 'copy all moves in $moveList to',
        popupAddendum: 'copy all to',
        exclusion: moveList,
        moveLists: widget.project.moveLists,
      ),
    );

    if (packet != null) {
      await refreshPage(() async {
        await widget.project.copyAllMoves(
          moveList,
          packet.moveList,
          packet.allowRedundancies,
        );
      });
      displaySnackBar('Copied All Moves: from $moveList to ${packet.moveList}');
    }
  }

  Future<void> _mergeMoveList(MoveList moveList) async {
    final MLSPPacket? packet = await showDialog(
      context: context,
      builder: (context) => MoveListSelectionPopup(
        title: 'Merge',
        actionText: 'merging this list with another',
        confirmTitle: 'Confirm Merge',
        confirmText: 'merge $moveList with',
        popupAddendum: 'merge with',
        exclusion: moveList,
        moveLists: widget.project.moveLists,
      ),
    );

    if (packet != null) {
      await refreshPage(() async {
        await widget.project.mergeMoveList(
          moveList,
          packet.moveList,
          packet.allowRedundancies,
        );
      });
      displaySnackBar('Move List Merged: $moveList with ${packet.moveList}');
    }
  }

  Future<void> _exportMoveList(MoveList moveList) async {
    List<Move>? moves = widget.project.getMoves(moveList);

    if (moves != null) {
      MoveListExporter exporter = MoveListExporter(moveList, moves);
      final MoveExportPacket? packet = await showDialog(
        context: context,
        builder: (context) => ExportPopup(
          exporter.fileName,
          exporter.fileType,
        ),
      );

      if (packet != null) {
        exporter.fileName = packet.fileName;
        exporter.fileType = packet.fileType;
        FileSystemEntity? export = await exporter.write();
        displaySnackBar(export == null
            ? 'Error: \'Export\' Failed'
            : 'Move List Exported: $moveList');
      }
    } else {
      displaySnackBar('Error: \'Export\' Failed');
    }
  }

  Future<void> _deleteMoveList(MoveList moveList) async {
    Map<UnitList, List<Unit>> unitsWithMoveList =
        widget.project.unitsWithMoveList(moveList);
    String addString = '';
    for (UnitList key in unitsWithMoveList.keys) {
      List<Unit>? units = unitsWithMoveList[key];
      if (units != null && units.isNotEmpty) {
        addString += '\n($key): ${units[0]}';
        for (int i = 1; i < units.length; i++) {
          addString += ', ${units[i]}';
        }
      }
    }
    if (addString != '') {
      addString = '\n\nThe following units currently use $moveList:$addString';
    } else {
      addString = '\n\n$moveList is currently unused.';
    }

    final bool confirm = await showDialog(
      context: context,
      builder: (context) => KoalaAlert(
        title: 'Delete Move List',
        text: 'Do you wish to delete $moveList?$addString',
      ),
    ) ?? false;

    if (confirm) {
      await refreshPage(() async {
        await widget.project.deleteMoveList(moveList);
      });
      displaySnackBar('Move List Deleted: $moveList');
    }
  }
}

class _NewMoveListPopup extends StatefulWidget {
  final MoveRolodexPageState parent;
  final String initialName;

  const _NewMoveListPopup({
    required this.parent,
    required this.initialName,
  });

  @override
  State<_NewMoveListPopup> createState() => _NewMoveListPopupState();
}

class _NewMoveListPopupState extends State<_NewMoveListPopup> {
  late String _name;
  bool _isValidName = true;

  @override
  initState() {
    super.initState();
    _name = widget.initialName;
  }

  @override
  Widget build(BuildContext context) {
    double sizeFactor = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Popup(
      context: context,
      onContinue: () {
        if (_isValidName) {
          Navigator.pop(
            context,
            _name,
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => const KoalaSimpleAlert(
              title: ValidationTexts.title,
              text: ValidationTexts.invalidMoveListName,
            ),
          );
        }
      },
      title: 'New List',
      borderRadius: 25,
      child: Center(
        child: TickerTextField(
          title: 'Name',
          lightingTheme: widget.parent.lightingTheme,
          width: sizeFactor * .7,
          initialValue: _name,
          autofocus: true,
          onChange: (value) {
            _name = value;
          },
          validate: (value) {
            _isValidName = removeWhitespace(value) != '' &&
                (_name == widget.initialName ||
                    !widget.parent.widget.project.isMoveListNameTaken(value));
            return _isValidName;
          },
          validationTextTitle: ValidationTexts.title,
          validationText: ValidationTexts.invalidMoveListName,
        ),
      ),
    );
  }
}
