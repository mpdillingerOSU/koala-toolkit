import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/capsule_button.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/title_searchbar.dart';
import 'package:gaming_toolkit/components/popup.dart';
import 'package:gaming_toolkit/components/tickers/ticker_text_field.dart';
import 'package:gaming_toolkit/components/universal_nav_bar.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/units/unit_filters_page.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/unit_list_selection_popup.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/units/unit_menu_page.dart';
import '../../../components/cards/unit_card.dart';
import '../../../components/general/flex_box.dart';
import '../../../components/general/popup_list.dart';
import '../../../components/general/scaffold_console.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/drag_drop_column.dart';
import '../../../koala_strings.dart';
import '../../../koala_toolkit_back_end/data/units/unit.dart';
import '../../../koala_toolkit_back_end/data/unit_field.dart';
import '../../../koala_toolkit_back_end/data/units/unit_list.dart';
import '../../../koala_toolkit_back_end/filters/unit_filter.dart';
import '../../../koala_toolkit_back_end/new_unit_packet.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../koala_toolkit_back_end/sorters/unit_sorter.dart';
import '../../../koala_toolkit_back_end/sorters/sorter.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';
import '../../../koala_toolkit_back_end/validation_texts.dart';
import '../popups/koala_alert.dart';
import '../popups/rename_popup.dart';

class UnitListPage extends KoalaPage {
  final ProjectPacket project;
  late UnitList _unitList;

  UnitListPage(
    this.project,
    UnitList unitList, {
    super.key,
  }) {
    _unitList = unitList;
  }

  @override
  KoalaPageState<UnitListPage> createState() => UnitListPageState();
}

class UnitListPageState extends KoalaPageState<UnitListPage> {
  late List<Unit> _allUnits = [];
  late List<Unit> _sortedUnits = [];
  late List<Unit> _filteredUnits = [];
  final UnitSorter _unitSorter = UnitSorter(
    type: Unit.unitNumAsField(),
    direction: SortDirection.ascending,
  );
  late final UnitFilter _unitFilter;
  bool _isSearching = false;
  final ScrollController _scrollController = ScrollController();

  @override
  Future<void> subRefresh() async {
    _allUnits = widget.project.getUnits(widget._unitList) ?? [];
    _sortedUnits = _unitSorter.sort(_allUnits);
    _filteredUnits = _unitFilter.apply(_sortedUnits);
  }

  @override
  void initState() {
    super.initState();
    _unitFilter = UnitFilter(widget.project.unitPalette);
    refreshPage(() async {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double runspacing = screenHeight * .0075;
    const double scaffoldConsoleBorderWidth = 3;

    return AdvancedScaffold(
      pageTitle: widget._unitList.name,
      titleAlt: _isSearching
          ? TitleSearchbar(
              onChanged: (value) {
                setState(() {
                  _unitFilter.searchTerm = value;
                  _filteredUnits = _unitFilter.apply(_sortedUnits);
                });
              },
              hintText: 'type in unit name...',
            )
          : null,
      actions: [
        TapDetector(
          onTap: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
          child: Center(
            child: Icon(
              _isSearching ? Icons.search_off_rounded : Icons.search_rounded,
              color: Colors.lightBlue,
              size: 30,
            ),
          ),
        ),
        /*
        _isSearching
            ? const SizedBox()
            : TapDetector(
                onTap: () {},
                child: Center(
                  child: Icon(
                    Icons.settings_outlined,
                    color: Colors.lightBlue,
                    size: 32,
                  ),
                ),
              ),
         */
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
      onTitleTap: () async {
        await _renameUnitList();
      },
      actionMargin: 16,
      appBarExpansion: _appBarExpansion(),
      overlayImage: 'images/backgroundDesign-1.png',
      body: Stack(
        children: [
          Visibility(
            visible: !isLoading,
            child: ScaffoldConsole(
              scrollController: _scrollController,
              message: !canDragNDrop ? 'Drag-\'n\'-Drop Locked' : null,
              messageIcon: !canDragNDrop ? Icons.lock_outline_rounded : null,
              messagePopupText:
                  'Drag-\'n\'-Drop is only possible when sorting by Unit Number. Since the list is instead being sorted by ${_unitSorter.type}, the functionality has been locked.',
              decoration: BoxDecoration(
                color: MyConstants.primaryColor,
                borderRadius: BorderRadius.circular(25 * .8),
                border: Border.all(
                  color: MyConstants.borderColor,
                  width: scaffoldConsoleBorderWidth,
                ),
              ),
              child: _allUnits.isEmpty ||
                      (_isSearching && _filteredUnits.isEmpty)
                  ? Column(
                      children: [
                        SizedBox(
                          height:
                              screenHeight * (_allUnits.isEmpty ? .225 : .175),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * .01875,
                            horizontal: screenWidth * .1,
                          ),
                          child: Center(
                            child: Text(
                              _allUnits.isEmpty
                                  ? 'Unit List is Empty'
                                  : 'No Units Match the Desired Filters',
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
                    )
                  : _buildUnitList(scaffoldConsoleBorderWidth),
            ),
          ),
          loadingScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3415C0),
        onPressed: () async => await _addUnit(),
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'New Unit',
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

  Widget _appBarExpansion() {
    const double runspacing = 2.25;

    return Column(
      children: [
        SizedBox(height: _isSearching ? 5 : 0),
        Container(
          width: double.infinity,
          height: 2.5,
          color: Colors.grey.shade300,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 20,
            top: 16,
            right: 20,
            bottom: 16,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 35,
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_rounded,
                      color: Colors.lightBlue,
                      size: 30,
                    ),
                  ],
                ),
              ),
              Text(
                'Sort by: ',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.lightBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 2.5,
              ),
              PopupList<UnitField>(
                width: MediaQuery.of(context).size.width * .5,
                height: 24,
                items: _generateSortList(),
                selection: _unitSorter.type,
                onChanged: (value) {
                  setState(() {
                    _unitSorter.type = value;
                    _sortedUnits = _unitSorter.sort(_allUnits);
                    _filteredUnits = _unitFilter.apply(_sortedUnits);
                  });
                },
              ),
              const FlexBox(1),
              TapDetector(
                onTap: () async {
                  setState(() {
                    _unitSorter.flipDirection();
                    _sortedUnits = _unitSorter.sort(_allUnits);
                    _filteredUnits = _unitFilter.apply(_sortedUnits);
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(7.5),
                    border: Border.all(
                      width: 2,
                      color: Colors.blue.shade700,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(
                          0,
                          2,
                        ),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _unitSorter.direction == SortDirection.ascending
                          ? Icons.keyboard_double_arrow_up_rounded
                          : Icons.keyboard_double_arrow_down_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _isSearching
            ? TapDetector(
                onTap: () async {
                  UnitFilter? newFilter = await pushPage(
                    UnitFiltersPage(
                      _unitFilter,
                    ),
                  );

                  if (newFilter != null) {
                    setState(() {
                      _unitFilter.setEqualTo(newFilter);
                      _filteredUnits = _unitFilter.apply(_sortedUnits);
                    });
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 16,
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 3,
                      runSpacing: runspacing,
                      children: [
                            SizedBox(
                              width: 35 - runspacing,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.filter_alt_rounded,
                                    color: Colors.lightBlue,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Filters: ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Sans Source Pro',
                                color: Colors.lightBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] +
                          _generateFilterCancels(),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  bool get canDragNDrop =>
      _unitSorter.type.equals(Unit.unitNumAsField()) && !_isSearching;

  Future<void> _renameUnitList() async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename List',
        initialValue: widget._unitList.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !widget.project.isUnitListNameTaken(
                value,
                givenUnitList: widget._unitList.name,
              );
        },
        validationText: ValidationTexts.invalidUnitListName,
      ),
    );

    if (result != null) {
      await refreshPage(() async {
        widget._unitList =
            await widget.project.renameUnitList(widget._unitList, result);
      });
      displaySnackBar('Unit List Renamed: ${widget._unitList}');
    }
  }

  List<Widget> _generateFilterCancels() {
    double buttonHeight = 25;
    List<Widget> list = [];

    for (String filter in _unitFilter.allApplied()) {
      list.add(_generateFilterCancel(
        buttonHeight,
        filter,
        () {
          _unitFilter.get(filter)?.clear();
        },
      ));
    }

    if (list.isEmpty) {
      list.add(
        Text(
          'None',
          style: TextStyle(
            fontFamily: 'Sans Source Pro',
            color: Colors.lightBlue,
            fontSize: 20,
          ),
        ),
      );
    }

    return list;
  }

  CapsuleButton _generateFilterCancel(
      double buttonHeight, String text, void Function() onCancel) {
    return CapsuleButton(
      text: text,
      icon: Icons.close_rounded,
      height: buttonHeight,
      onTap: () {
        setState(() {
          onCancel();
          _filteredUnits = _unitFilter.apply(_sortedUnits);
        });
      },
    );
  }

  DragDropColumn _buildUnitList(double scaffoldConsoleBorderWidth) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemWidth =
        screenWidth - screenHeight * .127 - (scaffoldConsoleBorderWidth * 2);
    final double itemHeight = screenHeight * .1285;

    List<UnitCard> cards = [];
    List<Unit> unitList = _isSearching ? _filteredUnits : _sortedUnits;
    for (int i = 0; i < unitList.length; i++) {
      Unit unit = unitList[i];
      cards.add(
        UnitCard(
          unit: unit,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
          lightingTheme: lightingTheme,
          subtext: _getSubtext(unit),
          isSubtextInside: false,
          onIndexChange: (newIndex) async =>
              await _changeUnitIndex(unit.unitNum, newIndex),
          onEdit: () async => await _editUnit(unit),
          onRename: () async => await _renameUnit(unit),
          onDuplicate: () async => await _duplicateUnit(unit),
          onCopyTo: () async => await _copyTo(unit),
          onMoveTo: () async => await _moveTo(unit),
          onDelete: () async => await _deleteUnit(unit),
        ),
      );
    }

    return DragDropColumn(
      context,
      scrollController: _scrollController,
      itemMovementAxis: Axis.vertical,
      dragEnabled: canDragNDrop,
      dragScrollSpeed: dragScrollSpeed,
      onDragEnd: (int oldIndex, int newIndex) async {
        await _changeUnitIndex(
          _unitSorter.direction == SortDirection.ascending
              ? oldIndex + 1
              : _allUnits.length - oldIndex,
          _unitSorter.direction == SortDirection.ascending
              ? newIndex + 1
              : _allUnits.length - newIndex,
        );
      },
      itemWidth: itemWidth,
      itemHeight: itemHeight,
      children: cards,
    );
  }

  String? _getSubtext(Unit unit) {
    if (!_unitSorter.type.equals(Unit.nameAsField()) &&
        !_unitSorter.type.equals(Unit.unitNumAsField())) {
      return '${_unitSorter.type}: ${unit.get(_unitSorter.type)?.val}';
    }
    return null;
  }

  List<PopupListItem<UnitField>> _generateSortList() {
    List<PopupListItem<UnitField>> list = [];
    for (UnitField field in (<UnitField>[
          Unit.unitNumAsField(),
          Unit.nameAsField(),
        ] +
        widget.project.unitPalette.fields)) {
      list.add(
        PopupListItem(
          key: field.name,
          value: field,
        ),
      );
    }
    return list;
  }

  Future<void> _addUnit() async {
    final NewUnitPacket? result = await showDialog(
      context: context,
      builder: (context) => _NewUnitPopup(this),
    );

    if (!mounted) return;
    if (result != null) {
      Unit? newUnit = await widget.project.addUnit(
        result.unitName,
        widget._unitList,
      );

      displaySnackBar(newUnit == null
          ? 'Error: \'Add\' Failed'
          : 'Unit Added: ${result.unitName}');

      if (!mounted) return;
      newUnit != null
          ? await _editUnit(newUnit)
          : await refreshPage(() async {});
    }
  }

  Future<void> _changeUnitIndex(int oldIndex, int newIndex) async {
    if (oldIndex != newIndex) {
      await refreshPage(() async {
        await widget.project.changeUnitIndex(
          oldIndex,
          newIndex,
          widget._unitList,
        );
      });
    }
  }

  Future<void> _editUnit(Unit unit) async {
    await pushPage(
      UnitMenuPage(
        unit,
        widget._unitList,
        widget.project,
      ),
    );
    await refreshPage(() async {});
  }

  Future<void> _renameUnit(Unit unit) async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename Unit',
        initialValue: unit.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !(widget.project.isUnitNameTaken(
                value,
                widget._unitList,
                givenUnit: unit.name,
              ));
        },
        validationText: ValidationTexts.invalidUnitName,
      ),
    );

    if (result != null && result != unit.name) {
      await refreshPage(() async {
        await widget.project.renameUnit(unit, result, widget._unitList);
      });
      displaySnackBar('Unit Renamed: $result');
    }
  }

  Future<void> _duplicateUnit(Unit unit) async {
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => KoalaAlert(
            title: 'Duplicate Unit',
            text: 'Do you wish to duplicate ${unit.name}?',
          ),
        ) ??
        false;

    if (confirm) {
      await refreshPage(() async {
        await widget.project.duplicateUnit(unit, widget._unitList);
      });
      displaySnackBar('Unit Duplicated: $unit');
    }
  }

  Future<void> _copyTo(Unit unit) async {
    final ULSPPacket? packet = await showDialog(
      context: context,
      builder: (context) => UnitListSelectionPopup(
        title: 'Copy to',
        actionText: 'copying this unit to another list',
        confirmTitle: 'Confirm Copy',
        confirmText: 'copy $unit to',
        popupAddendum: 'copy to',
        exclusion: widget._unitList,
        unitLists: widget.project.unitLists,
      ),
    );

    if (packet != null) {
      await refreshPage(() async {
        await widget.project.copyUnit(
          unit,
          widget._unitList,
          packet.unitList,
          packet.allowRedundancies,
        );
      });
      displaySnackBar('$unit copied to: ${packet.unitList}');
    }
  }

  Future<void> _moveTo(Unit unit) async {
    final ULSPPacket? packet = await showDialog(
      context: context,
      builder: (context) => UnitListSelectionPopup(
        title: 'Unit to',
        actionText: 'moving this unit to another list',
        confirmTitle: 'Confirm Unit',
        confirmText: 'move $unit to',
        popupAddendum: 'move to',
        exclusion: widget._unitList,
        unitLists: widget.project.unitLists,
      ),
    );

    if (packet != null) {
      await refreshPage(() async {
        await widget.project.moveUnit(
          unit,
          widget._unitList,
          packet.unitList,
          packet.allowRedundancies,
        );
      });
      displaySnackBar('$unit moved to: ${packet.unitList}');
    }
  }

  Future<void> _deleteUnit(Unit unit) async {
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => KoalaAlert(
            title: 'Delete Unit',
            text: 'Do you wish to delete ${unit.name}?',
          ),
        ) ??
        false;

    if (confirm) {
      await refreshPage(() async {
        await widget.project.deleteUnit(unit, widget._unitList);
      });
      displaySnackBar('Unit Deleted: $unit');
    }
  }
}

class _NewUnitPopup extends StatefulWidget {
  UnitListPageState parent;

  _NewUnitPopup(this.parent);

  @override
  State<_NewUnitPopup> createState() => _NewUnitPopupState();
}

class _NewUnitPopupState extends State<_NewUnitPopup> {
  String _unitName = Unit.defaultName;

  bool _isValidName = true;

  @override
  initState() {
    super.initState();
    if (widget.parent.widget.project
        .isUnitNameTaken(_unitName, widget.parent.widget._unitList)) {
      int num = 2;
      while (widget.parent.widget.project
          .isUnitNameTaken('$_unitName$num', widget.parent.widget._unitList)) {
        num++;
      }
      _unitName = '$_unitName$num';
    }
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
            NewUnitPacket(
              unitName: _unitName,
              unitNum: widget.parent._allUnits.length + 1,
            ),
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
      title: 'New Unit',
      borderRadius: 25,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TickerTextField(
            title: 'Name',
            lightingTheme: widget.parent.lightingTheme,
            width: sizeFactor * .7,
            initialValue: _unitName,
            autofocus: true,
            onChange: (value) {
              _unitName = value;
            },
            validate: (value) {
              _isValidName = removeWhitespace(value) != '' &&
                  !widget.parent.widget.project
                      .isUnitNameTaken(value, widget.parent.widget._unitList);
              return _isValidName;
            },
            validationTextTitle: ValidationTexts.title,
            validationText: ValidationTexts.invalidUnitName,
          ),
        ],
      ),
    );
  }
}
