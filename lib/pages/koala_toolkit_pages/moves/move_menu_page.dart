import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/hexagon_menu.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/validation_texts.dart';

import '../../../components/general/koala_scrollbar.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/universal_nav_bar.dart';
import '../../../koala_strings.dart';
import '../../../koala_toolkit_back_end/data/moves/move.dart';
import '../../../koala_toolkit_back_end/data/moves/move_list.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';
import '../popups/rename_popup.dart';
import 'move_attributes_page.dart';
import 'move_descriptions_page.dart';

class MoveMenuPage extends KoalaPage {
  Move _move;
  final MoveList moveList;
  final ProjectPacket project;

  MoveMenuPage(
    Move move,
    this.moveList,
    this.project, {
    super.key,
  }) : _move = move;

  @override
  KoalaPageState<MoveMenuPage> createState() => MoveMenuPageState();
}

class MoveMenuPageState extends KoalaPageState<MoveMenuPage> {
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
      pageTitle: widget._move.name,
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
        await _renameMove();
      },
      body: Stack(
        children: [
          Visibility(
            visible: !isLoading,
            child: Scrollbar(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: HexagonColumn(
                      buttonSize: sizeFactor * .5,
                      buttons: [
                        HexagonButton(
                          title: 'Descriptions',
                          icon: Icons.menu_book_rounded,
                          onTap: () async {
                            Move? editedMove = await pushPage(
                              MoveDescriptionsPage(
                                widget.project,
                                widget._move,
                                widget.moveList,
                              ),
                            );
                            await refreshPage(() async {
                              if (editedMove != null) {
                                widget._move = editedMove;
                              }
                            });
                          },
                        ),
                        HexagonButton(
                          title: 'Attributes',
                          icon: Icons.bar_chart_rounded,
                          onTap: () async {
                            Move? editedMove = await pushPage(
                              MoveAttributesPage(
                                widget.project,
                                widget._move,
                                widget.moveList,
                              ),
                            );
                            await refreshPage(() async {
                              if (editedMove != null) {
                                widget._move = editedMove;
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
          ),
          loadingScreen(),
        ],
      ),
      bottomNavigationBar: UniversalNavBar(
        context,
        project: widget.project,
        selection: 'Moves',
        onWillPush: () async => true,
      ),
    );
  }

  Future<void> _renameMove() async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename Move',
        initialValue: widget._move.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !(widget.project.isMoveNameTaken(
                value,
                widget.moveList,
                givenMove: widget._move.name,
              ));
        },
        validationText: ValidationTexts.invalidMoveName,
      ),
    );

    if (result != null && result != widget._move.name) {
      await refreshPage(() async {
        widget._move = await widget.project
            .renameMove(widget._move, result, widget.moveList);
      });
      displaySnackBar('Move Renamed: $result');
    }
  }
}
