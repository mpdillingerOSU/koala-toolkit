import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/universal_nav_bar.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/home/project_home_page.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/units/unit_list_page.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/unit_list_selection_popup.dart';

import '../../../components/cards/unit_list_card.dart';
import '../../../components/drag_drop_column.dart';
import '../../../components/general/koala_scrollbar.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/popup.dart';
import '../../../components/tickers/ticker_text_field.dart';
import '../../../koala_strings.dart';
import '../../../koala_toolkit_back_end/data/units/unit.dart';
import '../../../koala_toolkit_back_end/data/units/unit_list.dart';
import '../../../koala_toolkit_back_end/export/unit_list_exporter.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../my_constants.dart';
import '../popups/export_popup.dart';
import '../koala_page.dart';
import '../../../koala_toolkit_back_end/validation_texts.dart';
import '../popups/rename_popup.dart';

class UnitRolodexPage extends KoalaPage {
  final ProjectPacket project;

  const UnitRolodexPage(this.project, {super.key});

  @override
  KoalaPageState<UnitRolodexPage> createState() => UnitRolodexPageState();
}

class UnitRolodexPageState extends KoalaPageState<UnitRolodexPage> {
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
      pageTitle: 'Unit Lists',
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
                  children: !widget.project.hasUnitLists
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
                                      'Unit Rolodex is Empty',
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
                            ),
                          ),
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
        onPressed: () => _addUnitList(context),
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
        selection: 'Units',
        onWillPush: () async => true,
      ),
    );
  }

  DragDropColumn _buildRolodex() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemWidth = screenWidth - screenHeight * .027;
    final double itemHeight = screenHeight * .3;

    List<UnitListCard> cards = [];
    List<UnitList> unitLists = widget.project.unitLists;
    for (int i = 0; i < unitLists.length; i++) {
      UnitList unitList = unitLists[i];
      cards.add(
        UnitListCard(
          unitList: unitList,
          width: itemWidth,
          height: itemHeight,
          lightingTheme: lightingTheme,
          onIndexChange: (newIndex) async {
            await _changeUnitListIndex(unitList.listNum, newIndex);
          },
          onOpen: () async {
            await _openUnitList(unitList);
          },
          onRename: () async {
            await _renameUnitList(unitList);
          },
          onDuplicate: () async {
            await _duplicateUnitList(unitList);
          },
          onCopyAll: () async {
            await _copyAll(unitList);
          },
          onMerge: () async {
            await _mergeUnitList(unitList);
          },
          onExport: () async {
            await _exportUnitList(unitList);
          },
          onDelete: () async {
            await _deleteUnitList(unitList);
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
        await _changeUnitListIndex(oldIndex + 1, newIndex + 1);
      },
      itemWidth: itemWidth,
      itemHeight: itemHeight,
      children: cards,
    );
  }

  Future<void> _changeUnitListIndex(int oldIndex, int newIndex) async {
    if (oldIndex != newIndex) {
      await refreshPage(() async {
        await widget.project.changeUnitListIndex(oldIndex, newIndex);
      });
    }
  }

  Future<void> _addUnitList(BuildContext context) async {
    String initialName = 'unnamed';
    if (widget.project.isUnitListNameTaken(initialName)) {
      int num = 2;
      while (widget.project.isUnitListNameTaken('$initialName$num')) {
        num++;
      }
      initialName = '$initialName$num';
    }

    final String? result = await showDialog(
      context: context,
      builder: (context) => _NewUnitListPopup(
        parent: this,
        initialName: initialName,
      ),
    );

    if (!mounted) return;
    if (result != null) {
      UnitList newList = await widget.project.addUnitList(result);
      displaySnackBar('Unit List Added: $result');
      if (!mounted) return;
      await _openUnitList(newList);
    }
  }

  Future<void> _openUnitList(UnitList unitList) async {
    await pushPage(
      UnitListPage(
        widget.project,
        unitList,
      ),
    );
    await refreshPage(() async {});
  }

  Future<void> _renameUnitList(UnitList unitList) async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename List',
        initialValue: unitList.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !widget.project.isUnitListNameTaken(
                value,
                givenUnitList: unitList.name,
              );
        },
        validationText: ValidationTexts.invalidUnitListName,
      ),
    );

    if (result != null && result != unitList.name) {
      await refreshPage(() async {
        await widget.project.renameUnitList(unitList, result);
      });
      displaySnackBar('Unit List Renamed: $result');
    }
  }

  Future<void> _duplicateUnitList(UnitList unitList) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => KoalaAlert(
        title: 'Duplicate Unit List',
        text: 'Do you wish to duplicate $unitList?',
      ),
    ) ?? false;

    if (confirm) {
      await refreshPage(() async {
        await widget.project.duplicateUnitList(unitList);
      });
      displaySnackBar('Unit List Duplicated: $unitList');
    }
  }

  Future<void> _copyAll(UnitList unitList) async {
    final ULSPPacket? packet = await showDialog(
      context: context,
      builder: (context) => UnitListSelectionPopup(
        title: 'Copy All',
        actionText: 'copying all units in this list into another',
        confirmTitle: 'Confirm Copy All',
        confirmText: 'copy all units in $unitList to',
        popupAddendum: 'copy all to',
        unitLists: widget.project.unitLists,
        exclusion: unitList,
      ),
    );

    if (packet != null) {
      await refreshPage(() async {
        await widget.project.copyAllUnits(
          unitList,
          packet.unitList,
          packet.allowRedundancies,
        );
      });
      displaySnackBar('Copied All Units: from $unitList to ${packet.unitList}');
    }
  }

  Future<void> _mergeUnitList(UnitList unitList) async {
    final ULSPPacket? packet = await showDialog(
      context: context,
      builder: (context) => UnitListSelectionPopup(
        title: 'Merge',
        actionText: 'merging this list with another',
        confirmTitle: 'Confirm Merge',
        confirmText: 'merge $unitList with',
        popupAddendum: 'merge with',
        unitLists: widget.project.unitLists,
        exclusion: unitList,
      ),
    );

    if (packet != null) {
      await refreshPage(() async {
        await widget.project.mergeUnitList(
          unitList,
          packet.unitList,
          packet.allowRedundancies,
        );
      });
      displaySnackBar('Unit List Merged: $unitList with ${packet.unitList}');
    }
  }

  Future<void> _exportUnitList(UnitList unitList) async {
    List<Unit>? units = widget.project.getUnits(unitList);

    if (units != null) {
      UnitListExporter exporter = UnitListExporter(unitList, units);
      final UnitExportPacket? packet = await showDialog(
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
            : 'Unit List Exported: $unitList');
      }
    } else {
      displaySnackBar('Error: \'Export\' Failed');
    }
  }

  Future<void> _deleteUnitList(UnitList unitList) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => KoalaAlert(
        title: 'Delete Unit List',
        text: 'Do you wish to delete $unitList?',
      ),
    ) ?? false;

    if (confirm) {
      await refreshPage(() async {
        await widget.project.deleteUnitList(unitList);
      });
      displaySnackBar('Unit List Deleted: $unitList');
    }
  }
}

class _NewUnitListPopup extends StatefulWidget {
  final UnitRolodexPageState parent;
  final String initialName;

  const _NewUnitListPopup({
    required this.parent,
    required this.initialName,
  });

  @override
  State<_NewUnitListPopup> createState() => _NewUnitListPopupState();
}

class _NewUnitListPopupState extends State<_NewUnitListPopup> {
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
              text: ValidationTexts.invalidUnitListName,
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
                    !widget.parent.widget.project.isUnitListNameTaken(value));
            return _isValidName;
          },
          validationTextTitle: ValidationTexts.title,
          validationText: ValidationTexts.invalidUnitListName,
        ),
      ),
    );
  }
}
