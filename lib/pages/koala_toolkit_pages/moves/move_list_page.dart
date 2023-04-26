import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/capsule_button.dart';
import 'package:gaming_toolkit/components/cards/move_card.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/popup.dart';
import 'package:gaming_toolkit/components/tickers/ticker_dropdown.dart';
import 'package:gaming_toolkit/components/tickers/ticker_row.dart';
import 'package:gaming_toolkit/components/tickers/ticker_text_field.dart';
import 'package:gaming_toolkit/koala_strings.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/move_type.dart';
import 'package:gaming_toolkit/components/universal_nav_bar.dart';
import '../../../components/drag_drop_column.dart';
import '../../../components/general/flex_box.dart';
import '../../../components/general/popup_list.dart';
import '../../../components/general/scaffold_console.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/title_searchbar.dart';
import '../../../koala_toolkit_back_end/data/moves/move.dart';
import '../../../koala_toolkit_back_end/data/moves/move_list.dart';
import '../../../koala_toolkit_back_end/data/units/unit.dart';
import '../../../koala_toolkit_back_end/data/units/unit_list.dart';
import '../../../koala_toolkit_back_end/filters/move_filter.dart';
import '../../../koala_toolkit_back_end/move_element.dart';
import '../../../koala_toolkit_back_end/move_modifier.dart';
import '../../../koala_toolkit_back_end/new_move_packet.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../koala_toolkit_back_end/sorters/move_sorter.dart';
import '../../../koala_toolkit_back_end/sorters/sorter.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';
import '../../../koala_toolkit_back_end/validation_texts.dart';
import '../popups/koala_alert.dart';
import '../popups/rename_popup.dart';
import 'move_filters_page.dart';
import '../popups/move_list_selection_popup.dart';
import 'move_menu_page.dart';

class MoveListPage extends KoalaPage {
  final ProjectPacket project;
  MoveList _moveList;

  MoveListPage(
    this.project,
    MoveList moveList, {
    super.key,
  }) : _moveList = moveList;

  @override
  KoalaPageState<MoveListPage> createState() => MoveListPageState();
}

class MoveListPageState extends KoalaPageState<MoveListPage> {
  late List<Move> _allMoves = [];
  late List<Move> _sortedMoves = [];
  late List<Move> _filteredMoves = [];
  final MoveSorter _moveSorter = MoveSorter();
  final MoveFilter _moveFilter = MoveFilter();
  bool _isSearching = false;
  final ScrollController _scrollController = ScrollController();

  @override
  Future<void> subRefresh() async {
    _allMoves = widget.project.getMoves(widget._moveList) ?? [];
    _sortedMoves = _moveSorter.sort(_allMoves);
    _filteredMoves = _moveFilter.apply(_sortedMoves);
  }

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    const double scaffoldConsoleBorderWidth = 3;

    return AdvancedScaffold(
      pageTitle: widget._moveList.name,
      titleAlt: _isSearching
          ? TitleSearchbar(
              onChanged: (value) {
                setState(() {
                  _moveFilter.searchTerm = value;
                  _filteredMoves = _moveFilter.apply(_sortedMoves);
                });
              },
              hintText: 'type in move name...',
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
        await _renameMoveList();
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
                  'Drag-\'n\'-Drop is only possible when sorting by Move Number. Since the list is instead being sorted by ${_moveSorter.type}, the functionality has been locked.',
              decoration: BoxDecoration(
                color: MyConstants.primaryColor,
                borderRadius: BorderRadius.circular(25 * .8),
                border: Border.all(
                  color: MyConstants.borderColor,
                  width: scaffoldConsoleBorderWidth,
                ),
              ),
              child: _allMoves.isEmpty ||
                      (_isSearching && _filteredMoves.isEmpty)
                  ? Column(children: [
                      SizedBox(
                        height:
                            screenHeight * (_allMoves.isEmpty ? .225 : .175),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .01875,
                          horizontal: screenWidth * .1,
                        ),
                        child: Center(
                          child: Text(
                            _allMoves.isEmpty
                                ? 'Move List is Empty'
                                : 'No Moves Match the Desired Filters',
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
                    ])
                  : _buildMoveList(scaffoldConsoleBorderWidth),
            ),
          ),
          loadingScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3415C0),
        onPressed: () => _addMove(),
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'New Move',
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
              PopupList<MoveSortType>(
                width: MediaQuery.of(context).size.width * .5,
                height: 24,
                items: _generateSortList(),
                selection: _moveSorter.type,
                onChanged: (value) {
                  setState(() {
                    _moveSorter.type = value;
                    _sortedMoves = _moveSorter.sort(_allMoves);
                    _filteredMoves = _moveFilter.apply(_sortedMoves);
                  });
                },
              ),
              const FlexBox(1),
              TapDetector(
                onTap: () async {
                  setState(() {
                    _moveSorter.flipDirection();
                    _sortedMoves = _moveSorter.sort(_allMoves);
                    _filteredMoves = _moveFilter.apply(_sortedMoves);
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
                      _moveSorter.direction == SortDirection.ascending
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
                  MoveFilter? newFilter = await pushPage(
                    MoveFiltersPage(
                      _moveFilter,
                    ),
                  );

                  if (newFilter != null) {
                    setState(() {
                      _moveFilter.setEqualTo(newFilter);
                      _filteredMoves = _moveFilter.apply(_sortedMoves);
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
      _moveSorter.type == MoveSortType.moveNum && !_isSearching;

  Future<void> _renameMoveList() async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename List',
        initialValue: widget._moveList.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !widget.project.isMoveListNameTaken(
                value,
                givenMoveList: widget._moveList.name,
              );
        },
        validationText: ValidationTexts.invalidMoveListName,
      ),
    );

    if (result != null) {
      await refreshPage(() async {
        widget._moveList =
            await widget.project.renameMoveList(widget._moveList, result);
      });
      displaySnackBar('Move List Renamed: ${widget._moveList}');
    }
  }

  List<Widget> _generateFilterCancels() {
    double buttonHeight = 25;
    List<CapsuleButton> list = [];

    if (_moveFilter.elementFilters != null) {
      list.add(_generateFilterCancel(
          buttonHeight, 'Element', _moveFilter.clearElementFilters));
    }
    if (_moveFilter.moveTypeFilters != null) {
      list.add(_generateFilterCancel(
          buttonHeight, 'Move Type', _moveFilter.clearMoveTypeFilters));
    }
    if (_moveFilter.energyCostFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight, 'Energy Cost', _moveFilter.clearEnergyCostFilter));
    }
    if (_moveFilter.hasPowerFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight, 'Power', _moveFilter.clearHasPowerFilter));
    }
    if (_moveFilter.rangeFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight, 'Range', _moveFilter.clearRangeFilter));
    }
    if (_moveFilter.accuracyFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight, 'Accuracy', _moveFilter.clearAccuracyFilter));
    }
    if (_moveFilter.hasKnockbackFilter != null) {
      list.add(_generateFilterCancel(buttonHeight, MoveModifier.knockback.name,
          _moveFilter.clearHasKnockbackFilter));
    }
    if (_moveFilter.hasLungeFilter != null) {
      list.add(_generateFilterCancel(buttonHeight, MoveModifier.lunge.name,
          _moveFilter.clearHasLungeFilter));
    }
    if (_moveFilter.hasLOSFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight, MoveModifier.los.name, _moveFilter.clearHasLOSFilter));
    }
    if (_moveFilter.hasRangeBoostableFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight,
          MoveModifier.rangeBoostable.name,
          _moveFilter.clearHasRangeBoostableFilter));
    }
    if (_moveFilter.hasDirectContactFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight,
          MoveModifier.directContact.name,
          _moveFilter.clearHasDirectContactFilter));
    }
    if (_moveFilter.hasUtilityFilter != null) {
      list.add(_generateFilterCancel(buttonHeight, MoveModifier.utility.name,
          _moveFilter.clearHasUtilityFilter));
    }
    if (_moveFilter.hasCompoundingPowerFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight,
          MoveModifier.compoundingPower.name,
          _moveFilter.clearHasCompoundingPowerFilter));
    }
    if (_moveFilter.hasDeprecatingPowerFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight,
          MoveModifier.deprecatingPower.name,
          _moveFilter.clearHasDeprecatingPowerFilter));
    }
    if (_moveFilter.hasMultiHitFilter != null) {
      list.add(_generateFilterCancel(buttonHeight, MoveModifier.multiHit.name,
          _moveFilter.clearHasMultiHitFilter));
    }
    if (_moveFilter.hasPullFilter != null) {
      list.add(_generateFilterCancel(buttonHeight, MoveModifier.pull.name,
          _moveFilter.clearHasPullFilter));
    }
    if (_moveFilter.hasBattleEffectFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight,
          MoveModifier.battleEffect.name,
          _moveFilter.clearHasBattleEffectFilter));
    }
    if (_moveFilter.hasBouncebackFilter != null) {
      list.add(_generateFilterCancel(buttonHeight, MoveModifier.bounceback.name,
          _moveFilter.clearHasBouncebackFilter));
    }
    if (_moveFilter.hasRecoilFilter != null) {
      list.add(_generateFilterCancel(buttonHeight, MoveModifier.recoil.name,
          _moveFilter.clearHasRecoilFilter));
    }
    if (_moveFilter.hasCooldownFilter != null) {
      list.add(_generateFilterCancel(buttonHeight, MoveModifier.cooldown.name,
          _moveFilter.clearHasCooldownFilter));
    }
    if (_moveFilter.hasSideEffectFilter != null) {
      list.add(_generateFilterCancel(buttonHeight, MoveModifier.sideEffect.name,
          _moveFilter.clearHasSideEffectFilter));
    }
    if (_moveFilter.hasCrashDamageFilter != null) {
      list.add(_generateFilterCancel(
          buttonHeight,
          MoveModifier.crashDamage.name,
          _moveFilter.clearHasCrashDamageFilter));
    }

    return list.isEmpty
        ? [
            Text(
              'None',
              style: TextStyle(
                fontFamily: 'Sans Source Pro',
                color: Colors.lightBlue,
                fontSize: 20,
              ),
            ),
          ]
        : list;
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
          _filteredMoves = _moveFilter.apply(_sortedMoves);
        });
      },
    );
  }

  DragDropColumn _buildMoveList(double scaffoldConsoleBorderWidth) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemWidth =
        screenWidth - screenHeight * .127 - (scaffoldConsoleBorderWidth * 2);
    final double itemHeight = screenHeight * .1285;

    List<MoveCard> cards = [];
    List<Move> moveList = _isSearching ? _filteredMoves : _sortedMoves;
    for (int i = 0; i < moveList.length; i++) {
      Move move = moveList[i];
      cards.add(
        MoveCard(
          move: move,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
          lightingTheme: lightingTheme,
          subtext: _getSubtext(move),
          isSubtextInside: false,
          onIndexChange: (newIndex) async =>
              await _changeMoveIndex(move.moveNum, newIndex),
          onEdit: () async => await _editMove(move),
          onRename: () async => await _renameMove(move),
          onDuplicate: () async => await _duplicateMove(move),
          onCopyTo: () async => await _copyTo(move),
          onMoveTo: () async => await _moveTo(move),
          onDelete: () async => await _deleteMove(move),
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
        await _changeMoveIndex(
          _moveSorter.direction == SortDirection.ascending
              ? oldIndex + 1
              : _allMoves.length - oldIndex,
          _moveSorter.direction == SortDirection.ascending
              ? newIndex + 1
              : _allMoves.length - newIndex,
        );
      },
      itemWidth: itemWidth,
      itemHeight: itemHeight,
      children: cards,
    );
  }

  String? _getSubtext(Move move) {
    if (_moveSorter.type != MoveSortType.moveNum &&
        _moveSorter.type != MoveSortType.moveName &&
        _moveSorter.type != MoveSortType.element &&
        _moveSorter.type != MoveSortType.moveType) {
      if (_moveSorter.type == MoveSortType.powerMedian) {
        int total = move.powerMin + move.powerMax;
        return '${_moveSorter.type}: ${total % 2 == 0 ? total ~/ 2 : total / 2}';
      } else if (_moveSorter.type == MoveSortType.recoilMedian) {
        int total = move.recoilMin + move.recoilMax;
        return '${_moveSorter.type}: ${total % 2 == 0 ? total ~/ 2 : total / 2}';
      } else if (_moveSorter.type == MoveSortType.crashDamageMedian) {
        int total = move.crashDamageMin + move.crashDamageMax;
        return '${_moveSorter.type}: ${total % 2 == 0 ? total ~/ 2 : total / 2}';
      }
      return '${_moveSorter.type}: ${move.map[_moveSorter.type.moveField]}';
    }
    return null;
  }

  List<PopupListItem<MoveSortType>> _generateSortList() {
    List<PopupListItem<MoveSortType>> list = [];
    for (MoveSortType type in MoveSortType.values) {
      list.add(
        PopupListItem(
          key: type.name,
          value: type,
        ),
      );
    }
    return list;
  }

  Future<void> _addMove() async {
    final NewMovePacket? result = await showDialog(
      context: context,
      builder: (context) => _NewMovePopup(this),
    );

    if (!mounted) return;
    if (result != null) {
      final bool hasPower = MoveType.nameMap[result.moveType]?.hasPower ?? true;

      Move? newMove = await widget.project.addMove(
        Move(
          name: minimizeWhitespace(result.moveName),
          description: '',
          moveNum: result.moveNum,
          element: result.moveElement,
          moveType: result.moveType,
          energyCost: result.energyCost,
          hasPower: hasPower,
          powerMin: hasPower ? Move.standardPowerMin : Move.defaultPowerMin,
          powerMax: hasPower ? Move.standardPowerMax : Move.defaultPowerMax,
          rangeMin: Move.defaultRangeMin,
          rangeMax: Move.defaultRangeMax,
          accuracy: Move.defaultAccuracy,
          hasKnockback: Move.defaultHasKnockback,
          hasLunge: Move.defaultHasLunge,
          hasLOSModifier: false,
          hasRangeBoostableModifier: false,
          hasDirectContactModifier: false,
          hasUtility: Move.defaultHasUtility,
          hasCompoundingPowerModifier: false,
          hasDeprecatingPowerModifier: false,
          hasMultiHit: Move.defaultHasMultiHit,
          hasPull: Move.defaultHasPull,
          hasBattleEffect: Move.defaultHasBattleEffect,
          hasBounceback: Move.defaultHasBounceback,
          hasRecoil: Move.defaultHasRecoil,
          hasCooldown: Move.defaultHasCooldown,
          hasSideEffect: Move.defaultHasSideEffect,
          hasCrashDamage: Move.defaultHasCrashDamage,
        ),
        widget._moveList,
      );

      displaySnackBar(newMove == null
          ? 'Error: \'Add\' Failed'
          : 'Move Added: ${result.moveName}');

      if (!mounted) return;
      newMove != null
          ? await _editMove(newMove)
          : await refreshPage(() async {});
    }
  }

  Future<void> _changeMoveIndex(int oldIndex, int newIndex) async {
    if (oldIndex != newIndex) {
      await refreshPage(() async {
        await widget.project.changeMoveIndex(
          oldIndex,
          newIndex,
          widget._moveList,
        );
      });
    }
  }

  Future<void> _editMove(Move move) async {
    await pushPage(
      MoveMenuPage(
        move,
        widget._moveList,
        widget.project,
      ),
    );
    await refreshPage(() async {});
  }

  Future<void> _renameMove(Move move) async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename Move',
        initialValue: move.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !(widget.project.isMoveNameTaken(
                value,
                widget._moveList,
                givenMove: move.name,
              ));
        },
        validationText: ValidationTexts.invalidMoveName,
      ),
    );

    if (result != null && result != move.name) {
      await refreshPage(() async {
        await widget.project.renameMove(move, result, widget._moveList);
      });
      displaySnackBar('Move Renamed: $result');
    }
  }

  Future<void> _duplicateMove(Move move) async {
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => KoalaAlert(
            title: 'Duplicate Move',
            text: 'Do you wish to duplicate ${move.name}?',
          ),
        ) ??
        false;

    if (confirm) {
      await refreshPage(() async {
        await widget.project.duplicateMove(move, widget._moveList);
      });
      displaySnackBar('Move Duplicated: $move');
    }
  }

  Future<void> _copyTo(Move move) async {
    final MLSPPacket? packet = await showDialog(
      context: context,
      builder: (context) => MoveListSelectionPopup(
        title: 'Copy to',
        actionText: 'copying this move to another list',
        confirmTitle: 'Confirm Copy',
        confirmText: 'copy $move to',
        popupAddendum: 'copy to',
        exclusion: widget._moveList,
        moveLists: widget.project.moveLists,
      ),
    );

    if (packet != null) {
      await refreshPage(() async {
        await widget.project.copyMove(
          move,
          widget._moveList,
          packet.moveList,
          packet.allowRedundancies,
        );
      });
      displaySnackBar('$move copied to: ${packet.moveList}');
    }
  }

  Future<void> _moveTo(Move move) async {
    final MLSPPacket? packet = await showDialog(
      context: context,
      builder: (context) => MoveListSelectionPopup(
        title: 'Move to',
        actionText: 'moving this move to another list',
        confirmTitle: 'Confirm Move',
        confirmText: 'move $move to',
        popupAddendum: 'move to',
        exclusion: widget._moveList,
        moveLists: widget.project.moveLists,
      ),
    );

    if (packet != null) {
      await refreshPage(() async {
        await widget.project.moveMove(
          move,
          widget._moveList,
          packet.moveList,
          packet.allowRedundancies,
        );
      });
      displaySnackBar('$move moved to: ${packet.moveList}');
    }
  }

  Future<void> _deleteMove(Move move) async {
    Map<UnitList, List<Unit>> unitsWithMove =
        widget.project.unitsWithMove(move, widget._moveList);
    String addString = '';
    for (UnitList key in unitsWithMove.keys) {
      List<Unit>? units = unitsWithMove[key];
      if (units != null && units.isNotEmpty) {
        addString += '\n($key): ${units[0]}';
        for (int i = 1; i < units.length; i++) {
          addString += ', ${units[i]}';
        }
      }
    }
    if (addString != '') {
      addString = '\n\nThe following units currently use $move:$addString';
    } else {
      addString = '\n\n$move is currently unused.';
    }

    final bool confirm = await showDialog(
          context: context,
          builder: (context) => KoalaAlert(
            title: 'Delete Move',
            text: 'Do you wish to delete $move?$addString',
          ),
        ) ??
        false;

    if (confirm) {
      await refreshPage(() async {
        await widget.project.deleteMove(move, widget._moveList);
      });
      displaySnackBar('Move Deleted: $move');
    }
  }
}

class _NewMovePopup extends StatefulWidget {
  final MoveListPageState parent;

  const _NewMovePopup(this.parent);

  @override
  State<_NewMovePopup> createState() => _NewMovePopupState();
}

class _NewMovePopupState extends State<_NewMovePopup> {
  String _moveName = Move.defaultName;
  String _moveElement = Move.defaultElement;
  String _moveType = Move.defaultMoveType;
  int _energyCost = Move.defaultEnergyCost;

  bool _isValidName = true;

  @override
  initState() {
    super.initState();
    if (widget.parent.widget.project
        .isMoveNameTaken(_moveName, widget.parent.widget._moveList)) {
      int num = 2;
      while (widget.parent.widget.project
          .isMoveNameTaken('$_moveName$num', widget.parent.widget._moveList)) {
        num++;
      }
      _moveName = '$_moveName$num';
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
            NewMovePacket(
              moveName: _moveName,
              moveNum: widget.parent._allMoves.length + 1,
              moveElement: _moveElement,
              moveType: _moveType,
              energyCost: _energyCost,
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => const KoalaSimpleAlert(
              title: ValidationTexts.title,
              text: ValidationTexts.invalidMoveName,
            ),
          );
        }
      },
      title: 'New Move',
      borderRadius: 25,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TickerTextField(
            title: 'Name',
            lightingTheme: widget.parent.lightingTheme,
            width: sizeFactor * .7,
            initialValue: _moveName,
            autofocus: true,
            onChange: (value) {
              _moveName = value;
            },
            validate: (value) {
              _isValidName = removeWhitespace(value) != '' &&
                  !widget.parent.widget.project
                      .isMoveNameTaken(value, widget.parent.widget._moveList);
              return _isValidName;
            },
            validationTextTitle: ValidationTexts.title,
            validationText: ValidationTexts.invalidMoveName,
          ),
          SizedBox(
            height: sizeFactor * .025,
          ),
          TickerDropdown(
            title: 'Element',
            lightingTheme: widget.parent.lightingTheme,
            width: sizeFactor * .7,
            selections: MoveElement.map.keys.toList(),
            currentSelection: _moveElement,
            onChange: (value) {
              setState(() {
                _moveElement = value;
              });
            },
          ),
          SizedBox(
            height: sizeFactor * .025,
          ),
          TickerDropdown(
            title: 'Move Type',
            lightingTheme: widget.parent.lightingTheme,
            width: sizeFactor * .7,
            selections: MoveType.map.keys.toList(),
            currentSelection: _moveType,
            onChange: (value) {
              setState(() {
                _moveType = value;
              });
            },
          ),
          SizedBox(
            height: sizeFactor * .025,
          ),
          TickerRow(
            title: 'Energy Cost',
            lightingTheme: widget.parent.lightingTheme,
            width: sizeFactor * .7,
            startingValue: _energyCost,
            lowerBound: Move.energyCostLowerBound,
            upperBound: Move.energyCostUpperBound,
            onChange: (value) {
              setState(() {
                _energyCost = value;
              });
            },
          )
        ],
      ),
    );
  }
}
