import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/general/scaffold_console.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_color_theme.dart';
import 'package:gaming_toolkit/components/tickers/ticker_select.dart';

import '../../../components/general/nav_bar.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/tickers/ticker.dart';
import '../../../components/tickers/ticker_box.dart';
import '../../../components/margined_column.dart';
import '../../../components/tickers/ticker_switch.dart';
import '../../../koala_toolkit_back_end/data/unit_field.dart';
import '../../../koala_toolkit_back_end/data/units/unit.dart';
import '../../../koala_toolkit_back_end/data/units/unit_list.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../koala_toolkit_back_end/undo_redo_list.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';
import '../popups/koala_alert.dart';

class UnitAttributesPage extends KoalaPage {
  final ProjectPacket project;
  final Unit initialUnit;
  final UnitList unitList;

  const UnitAttributesPage(
    this.project,
    this.initialUnit,
    this.unitList, {
    super.key,
  });

  @override
  KoalaPageState<UnitAttributesPage> createState() => UnitAttributesPageState();
}

class UnitAttributesPageState extends KoalaPageState<UnitAttributesPage> {
  late TickerColorTheme _colorTheme;
  late final UndoRedoList<Unit> _undoRedoList;

  final List<Ticker> _tickers = [];

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

  TickerColorTheme _getColorTheme() {
    return TickerColorTheme.silverSmooth;
  }

  void _restoreAll() => _setTo(widget.initialUnit);

  TickerBox _generateTickerBox(UnitFieldInt field, int val) {
    return TickerBox(
      title: field.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerBox.defaultWidth * .8,
      startingValue: val,
      lowerBound: field.minVal,
      upperBound: field.maxVal,
      hasMenu: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(field.name)) {
          updateUndoRedo(() {
            _setToDefault(field);
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(field.name)) {
          updateUndoRedo(() {
            _restore(field);
          });
        }
      },
    );
  }

  TickerSwitch _generateTickerSwitch(UnitFieldBool field, bool val) {
    return TickerSwitch(
      title: field.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      icon: Icons.circle,
      width: TickerSwitch.defaultWidth * .8,
      isSelected: val,
      hasMenu: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(field.name)) {
          updateUndoRedo(() {
            _setToDefault(field);
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(field.name)) {
          updateUndoRedo(() {
            _restore(field);
          });
        }
      },
    );
  }

  TickerSelect _generateTickerSelect(UnitFieldEnum field, String val) {
    Map<String, IconData> selections = {};
    for (String name in field.vals) {
      selections[name] = Icons.circle_rounded;
    }

    return TickerSelect(
      title: field.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      selections: selections,
      currentSelection: val,
      width: 144,
      hasMenu: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(field.name)) {
          updateUndoRedo(() {
            _setToDefault(field);
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(field.name)) {
          updateUndoRedo(() {
            _restore(field);
          });
        }
      },
    );
  }

  void _setToDefault(UnitField field) => _setFieldTo(field, field.defaultVal);

  void _restore(UnitField field) =>
      _setFieldTo(field, widget.initialUnit.get(field)?.val);

  void _setFieldTo(UnitField field, Object? val) {
    for (int i = 0; i < _tickers.length; i++) {
      Widget widg = _tickers[i];
      if (widg is Ticker && widg.title == field.name) {
        if (field is UnitFieldInt && val is int) {
          _tickers[i] = _generateTickerBox(field, val);
        } else if (field is UnitFieldBool && val is bool) {
          _tickers[i] = _generateTickerSwitch(field, val);
        } else if (field is UnitFieldString) {
          //TODO: Not implemented yet
        } else if (field is UnitFieldEnum && val is String) {
          _tickers[i] = _generateTickerSelect(field, val);
        }
        return;
      }
    }
  }

  void _setTo(Unit? unit) {
    if (unit == null) return;

    _colorTheme = _getColorTheme();
    _tickers.clear();
    for (UnitFieldData data in unit.fields) {
      if (data.field is UnitFieldInt) {
        _tickers.add(_generateTickerBox(data.field as UnitFieldInt, data.val));
      } else if (data.field is UnitFieldBool) {
        _tickers
            .add(_generateTickerSwitch(data.field as UnitFieldBool, data.val));
      } else if (data.field is UnitFieldString) {
        //TODO: Not implemented yet
      } else if (data.field is UnitFieldEnum) {
        _tickers
            .add(_generateTickerSelect(data.field as UnitFieldEnum, data.val));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < _tickers.length; i++) {
      if (i + 1 < _tickers.length) {
        widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tickers[i],
              _horizontalSpacer(),
              _tickers[i + 1],
            ],
          ),
        );
        i++;
      } else {
        widgets.add(_tickers[i]);
      }
      widgets.add(_verticalSpacer());
    }

    return AdvancedScaffold(
      pageTitle: 'Attributes',
      barColor: lightingTheme.deepBackgroundColor,
      barTextColor: _colorTheme.barTextColor,
      backgroundGradient: _colorTheme.backgroundGradient,
      backgroundIcons: const [
        Icons.circle_rounded,
        Icons.circle_outlined,
      ],
      actionMargin: 16,
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
              color: _undoRedoList.canUndo
                  ? _colorTheme.barTextColor
                  : Colors.grey.shade300,
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
              color: _undoRedoList.canRedo
                  ? _colorTheme.barTextColor
                  : Colors.grey.shade300,
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
              color: _undoRedoList.canUndo
                  ? _colorTheme.barTextColor
                  : Colors.grey.shade300,
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
              color: Colors.lightBlue,
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
                children: [
                  _verticalSpacer(),
                  MarginedColumn(
                    margin: 2,
                    children: widgets,
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
      onWillPop: _onWillPop,
    );
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

  Unit _generateUnit() {
    List<UnitFieldData> fields = [];
    for (UnitField field in widget.project.unitPalette.fields) {
      for (Ticker ticker in _tickers) {
        if (ticker.title == field.name) {
          if (ticker is TickerBox) {
            fields.add(UnitFieldData(field, ticker.getValue()));
          } else if (ticker is TickerSwitch) {
            fields.add(UnitFieldData(field, ticker.isActive()));
          } else if (ticker is TickerSelect) {
            fields.add(UnitFieldData(field, ticker.getCurrentSelection()));
          }
        }
      }
    }
    return widget.initialUnit.copyWith(
      fields: fields,
    );
  }

  Widget _verticalSpacer() {
    return const SizedBox(
      height: 14 * .8,
    );
  }

  Widget _horizontalSpacer() {
    return const SizedBox(
      width: 14 * .8,
    );
  }

  Future<bool> _restoreAllPopup() async => await _confirmPopup(
        'Restore All',
        'Do you wish to restore all fields to their values from when the unit was last saved?',
      );

  Future<bool> _setToDefaultPopup(String fieldName) async =>
      await _confirmPopup(
        'Set Field to Default',
        'Do you wish to set the $fieldName field to its default values?',
      );

  Future<bool> _restorePopup(
    String fieldName, {
    List<String> extraSubtexts = const [],
  }) async {
    String extraSubtext;
    if (extraSubtexts.isEmpty) {
      extraSubtext = '';
    } else {
      extraSubtext = '\n\nAdditional Changes:';
      for (String subtext in extraSubtexts) {
        extraSubtext += '\n\t - $subtext';
      }
    }
    return await _confirmPopup(
      'Restore $fieldName',
      'Do you wish to restore the $fieldName field to its values from when it was last saved?$extraSubtext',
    );
  }

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
}
