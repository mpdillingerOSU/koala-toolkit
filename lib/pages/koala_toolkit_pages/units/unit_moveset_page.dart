import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/itemized_moveset.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';

import '../../../components/general/nav_bar.dart';
import '../../../components/general/scaffold_console.dart';
import '../../../components/general/tap_detector.dart';
import '../../../koala_toolkit_back_end/data/moves/move_list.dart';
import '../../../koala_toolkit_back_end/data/moves/moveset.dart';
import '../../../koala_toolkit_back_end/data/units/unit.dart';
import '../../../koala_toolkit_back_end/data/units/unit_list.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../koala_toolkit_back_end/undo_redo_list.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';

class UnitMovesetPage extends KoalaPage {
  final ProjectPacket project;
  final Unit initialUnit;
  final UnitList unitList;

  const UnitMovesetPage(
    this.project,
    this.initialUnit,
    this.unitList, {
    super.key,
  });

  @override
  KoalaPageState<UnitMovesetPage> createState() => UnitMovesetPageState();
}

class UnitMovesetPageState extends KoalaPageState<UnitMovesetPage> {
  late final UndoRedoList<Unit> _undoRedoList;
  late Moveset _moveset;

  updateUndoRedo(void Function() func) {
    setState(() {
      func();
      _undoRedoList.add(_generateUnit());
    });
  }

  @override
  Future<void> subRefresh() async {}

  @override
  initState() {
    super.initState();
    refreshPage(() async {
      _restoreAll();
      _undoRedoList = UndoRedoList(_generateUnit());
    });
  }

  void _restoreAll() => _setTo(widget.initialUnit);

  void _restore(String groupName) {
    List<MoveGroup> groups = _moveset.groups;
    for (MoveGroup group in groups) {
      groups.add(groupName == group.name
          ? widget.initialUnit.moveset.getByName(groupName) ??
              MoveGroup(groupName, [])
          : group.copy());
    }
    _moveset = Moveset(groups);
  }

  void _setTo(Unit? unit) {
    if (unit == null) return;
    List<MoveGroup> groups = [];
    for (MoveList list in widget.project.moveLists) {
      groups.add(unit.moveset.getByName(list.name) ?? MoveGroup(list.name, []));
    }
    _moveset = Moveset(groups);
  }

  Future<bool> _onWillPop() async =>
      !_undoRedoList.isEdited ||
      (await showDialog(
            context: context,
            builder: (context) => const KoalaAlert(
              title: 'Discard Changes',
              text: 'Do you wish to discard all changes made to the unit?',
            ),
          ) ??
          false);

  Unit _generateUnit() => widget.initialUnit.copyWith(moveset: _moveset);

  Widget _verticalSpacer() {
    return const SizedBox(
      height: 14 * .8,
    );
  }

  Future<bool> _restoreAllPopup() async =>
    await _confirmPopup(
      'Restore All',
      'Do you wish to restore all moveset groups to their values from when the unit was last saved?',
    );

  Future<bool> _restorePopup(String groupName) async =>
    await _confirmPopup(
      'Restore $groupName',
      'Do you wish to restore the $groupName moveset group to its values from when it was last saved?',
    );

  Future<bool> _deletionPopup(String groupName) async =>
    await _confirmPopup(
      'Delete $groupName',
      'Do you wish to delete the $groupName moveset group?',
    );

  Future<bool> _confirmPopup(String title, String text) async =>
      await showDialog(
        context: context,
        builder: (context) => KoalaAlert(
          title: title,
          text: text,
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double sizeFactor = max(screenWidth, screenHeight);

    return AdvancedScaffold(
      pageTitle: 'Moveset',
      barColor: MyConstants.primaryColor,
      barTextColor: Colors.blue,
      onWillPop: _onWillPop,
      actions: [
        TapDetector(
          onTap: () async {
            if (_undoRedoList.canUndo) {
              setState(() {
                _setTo(_undoRedoList.undo());
              });
            }
          },
          child: Center(
            child: Icon(
              Icons.undo_rounded,
              color: _undoRedoList.canUndo ? Colors.blue : Colors.grey.shade300,
              size: 32,
            ),
          ),
        ),
        TapDetector(
          onTap: () async {
            if (_undoRedoList.canRedo) {
              setState(() {
                _setTo(_undoRedoList.redo());
              });
            }
          },
          child: Center(
            child: Icon(
              Icons.redo_rounded,
              color: _undoRedoList.canRedo ? Colors.blue : Colors.grey.shade300,
              size: 32,
            ),
          ),
        ),
        TapDetector(
          onTap: () async {
            if (_undoRedoList.canUndo && await _restoreAllPopup()) {
              updateUndoRedo(() {
                _restoreAll();
              });
            }
          },
          child: Center(
            child: Icon(
              Icons.restore_rounded,
              color: _undoRedoList.canUndo ? Colors.blue : Colors.grey.shade300,
              size: 32,
            ),
          ),
        ),
        TapDetector(
          onTap: () async {
            await pushNamedPage('/settings');
          },
          child: const Center(
            child: Icon(
              Icons.settings_sharp,
              color: Colors.blue,
              size: 32,
            ),
          ),
        ),
      ],
      body: Stack(
        children: [
          Visibility(
            visible: !isLoading,
            child: ScaffoldConsole(
              decoration: BoxDecoration(
                color: lightingTheme.deepBackgroundColor,
                borderRadius: BorderRadius.circular(25 * .8),
                border: Border.all(
                  color: MyConstants.borderColor,
                  width: 3,
                ),
              ),
              child: _moveset.isNotEmpty
                  ? ItemizedMoveset(
                      lightingTheme: lightingTheme,
                      moveset: _moveset,
                      project: widget.project,
                      childrenHeight: sizeFactor * .065,
                      onChange: (moveset) {
                        if (moveset != _moveset) {
                          updateUndoRedo(() {
                            _moveset = moveset;
                          });
                        }
                      })
                  : Column(
                      children: [
                        SizedBox(
                          height: screenHeight * .225,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * .01875,
                            horizontal: screenWidth * .1,
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
                        ),
                      ],
                    ),
            ),
          ),
          loadingScreen(),
        ],
      ),
      bottomNavigationBar: TextNavBar(
        context,
        onPressed: () async {
          Navigator.pop(
            context,
            _undoRedoList.isEdited
                ? await widget.project.updateUnit(
                    _generateUnit(),
                    widget.unitList,
                  )
                : null,
          );
        },
        text: 'SAVE',
        textColor: lightingTheme.complementaryColor,
        barColor: lightingTheme.deepBackgroundColor,
      ),
    );
  }
}
