import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/hexagon_menu.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/units/unit_attributes_page.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/units/unit_descriptions_page.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/units/unit_moveset_page.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/validation_texts.dart';

import '../../../components/general/koala_scrollbar.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/universal_nav_bar.dart';
import '../../../koala_strings.dart';
import '../../../koala_toolkit_back_end/data/units/unit.dart';
import '../../../koala_toolkit_back_end/data/units/unit_list.dart';
import '../../../koala_toolkit_back_end/move_icons.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';
import '../popups/rename_popup.dart';

class UnitMenuPage extends KoalaPage {
  Unit _unit;
  final UnitList unitList;
  final ProjectPacket project;

  UnitMenuPage(
    Unit unit,
    this.unitList,
    this.project, {
    super.key,
  }) : _unit = unit;

  @override
  KoalaPageState<UnitMenuPage> createState() => UnitMenuPageState();
}

class UnitMenuPageState extends KoalaPageState<UnitMenuPage> {
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double sizeFactor = min(screenWidth, screenHeight);

    return AdvancedScaffold(
      pageTitle: widget._unit.name,
      barColor: MyConstants.primaryColor,
      barTextColor: Colors.blue,
      actions: [
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
      onTitleTap: () async {
        await _renameUnit();
      },
      body: Stack(
        children: [
          Visibility(
            visible: !isLoading,
            child: Scrollbar(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: HexagonColumn(
                    buttonSize: sizeFactor * .5,
                    buttons: [
                      HexagonButton(
                        title: 'Descriptions',
                        icon: Icons.menu_book_rounded,
                        onTap: () async {
                          Unit? editedUnit = await pushPage(
                            UnitDescriptionsPage(
                              widget.project,
                              widget._unit,
                              widget.unitList,
                            ),
                          );
                          await refreshPage(() async {
                            if (editedUnit != null) {
                              widget._unit = editedUnit;
                            }
                          });
                        },
                      ),
                      HexagonButton(
                        title: 'Attributes',
                        icon: Icons.bar_chart_rounded,
                        onTap: () async {
                          Unit? editedUnit = await pushPage(
                            UnitAttributesPage(
                              widget.project,
                              widget._unit,
                              widget.unitList,
                            ),
                          );
                          await refreshPage(() async {
                            if (editedUnit != null) {
                              widget._unit = editedUnit;
                            }
                          });
                        },
                      ),
                      HexagonButton(
                        title: 'Moveset',
                        icon: MoveIcons.powpow2,
                        onTap: () async {
                          Unit? editedUnit = await pushPage(
                            UnitMovesetPage(
                              widget.project,
                              widget._unit,
                              widget.unitList,
                            ),
                          );
                          await refreshPage(() async {
                            if (editedUnit != null) {
                              widget._unit = editedUnit;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          loadingScreen(),
        ],
      ),
      bottomNavigationBar: UniversalNavBar(
        context,
        project: widget.project,
        selection: 'Units',
        onWillPush: () async => true,
      ),
    );
  }

  Future<void> _renameUnit() async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename Unit',
        initialValue: widget._unit.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !(widget.project.isUnitNameTaken(
                value,
                widget.unitList,
                givenUnit: widget._unit.name,
              ));
        },
        validationText: ValidationTexts.invalidUnitName,
      ),
    );

    if (result != null && result != widget._unit.name) {
      await refreshPage(() async {
        widget._unit = await widget.project
            .renameUnit(widget._unit, result, widget.unitList);
      });
      displaySnackBar('Unit Renamed: $result');
    }
  }
}
