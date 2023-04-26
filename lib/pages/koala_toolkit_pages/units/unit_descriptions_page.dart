import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/koala_textbox.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';

import '../../../components/general/nav_bar.dart';
import '../../../components/general/scaffold_console.dart';
import '../../../components/general/tap_detector.dart';
import '../../../koala_strings.dart';
import '../../../koala_toolkit_back_end/data/units/unit.dart';
import '../../../koala_toolkit_back_end/data/units/unit_list.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../koala_toolkit_back_end/undo_redo_list.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';
import '../../../koala_toolkit_back_end/validation_texts.dart';

class UnitDescriptionsPage extends KoalaPage {
  final ProjectPacket project;
  final Unit initialUnit;
  final UnitList unitList;

  const UnitDescriptionsPage(
    this.project,
    this.initialUnit,
    this.unitList, {
    super.key,
  });

  @override
  KoalaPageState<UnitDescriptionsPage> createState() =>
      UnitDescriptionsPageState();
}

class UnitDescriptionsPageState extends KoalaPageState<UnitDescriptionsPage> {
  bool _isValidName = true;
  late final UndoRedoList<Unit> _undoRedoList;

  late String _name;
  late String _description;

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

  void _restore(String field) {
    if (field == 'Name') {
      _name = widget.initialUnit.name;
    } else if (field == 'Description') {
      _description = widget.initialUnit.description;
    }
  }

  void _setTo(Unit? unit) {
    if (unit == null) return;

    _name = unit.name;
    _description = unit.description;
  }

  Future<bool> _onWillPop() async {
    if (!_undoRedoList.isEdited) return true;

    return await showDialog(
          context: context,
          builder: (context) => const KoalaAlert(
            title: 'Discard Changes',
            text: 'Do you wish to discard all changes made to the unit?',
          ),
        ) ??
        false;
  }

  Unit _generateUnit() {
    return widget.initialUnit.copyWith(
      name: minimizeWhitespace(_name),
      description: minimizeWhitespace(_description),
    );
  }

  Widget _verticalSpacer() {
    return const SizedBox(
      height: 14 * .8,
    );
  }

  Future<bool> _restoreAllPopup() async => await _confirmPopup(
        'Restore All',
        'Do you wish to restore all fields to their values from when the unit was last saved?',
      );

  Future<bool> _restorePopup(String fieldName) async => await _confirmPopup(
        'Restore $fieldName',
        'Do you wish to restore the $fieldName field to its values from when it was last saved?',
      );

  Future<bool> _deletionPopup(String fieldName) async => await _confirmPopup(
        'Delete $fieldName',
        'Do you wish to delete the $fieldName field?',
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
    double textBoxWidth = screenWidth * .7;
    double verticalPadding = max(screenWidth * .035, screenHeight * .035);

    return AdvancedScaffold(
      pageTitle: 'Descriptions',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: verticalPadding),
                  KoalaTextBox(
                    title: 'Name',
                    size: textBoxWidth,
                    maxLines: 1,
                    textCapitalization: TextCapitalization.words,
                    initialValue: _name,
                    onChange: (value) {
                      updateUndoRedo(() {
                        _name = value;
                      });
                    },
                    validate: (value) {
                      _isValidName = removeWhitespace(value) != '' &&
                          (_name == widget.initialUnit.name ||
                              !widget.project
                                  .isUnitNameTaken(value, widget.unitList));
                      return _isValidName;
                    },
                    validationTextTitle: ValidationTexts.title,
                    validationText: ValidationTexts.invalidUnitName,
                  ),
                  _verticalSpacer(),
                  KoalaTextBox(
                    title: 'General Description',
                    size: textBoxWidth,
                    initialValue: _description,
                    onChange: (value) {
                      updateUndoRedo(() {
                        _description = value;
                      });
                    },
                  ),
                  SizedBox(height: verticalPadding),
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
          if (_isValidName) {
            Navigator.pop(
              context,
              _undoRedoList.isEdited
                  ? await widget.project.updateUnit(
                      _generateUnit(),
                      widget.unitList,
                    )
                  : null,
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => const KoalaSimpleAlert(
                title: ValidationTexts.title,
                text: ValidationTexts.invalidUnitName,
              ),
            );
          }
        },
        text: 'SAVE',
        textColor: lightingTheme.complementaryColor,
        barColor: lightingTheme.deepBackgroundColor,
      ),
    );
  }
}
