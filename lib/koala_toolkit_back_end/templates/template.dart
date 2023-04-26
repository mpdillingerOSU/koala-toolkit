import 'package:flutter/cupertino.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/unit_list_builder.dart';

import '../../koala_toolkit_back_end/data/unit_palette.dart';
import '../../koala_toolkit_back_end/databases/unit_palettes_database.dart';
import '../data/moves/move.dart';
import '../data/moves/move_list.dart';
import '../data/project.dart';
import '../data/units/unit.dart';
import '../data/units/unit_list.dart';
import '../databases/move_lists_database.dart';
import '../databases/moves_database.dart';
import '../databases/unit_lists_database.dart';
import '../databases/units_database.dart';
import 'move_list_builder.dart';

abstract class Template {
  final String name;

  Template(this.name);

  @protected
  List<MoveListBuilder> generateMoves();

  @protected
  UnitPalette generateUnitPalette();

  @protected
  List<UnitListBuilder> generateUnits();

  Future<void> generate(Project project) async {
    MoveListsDatabase? moveListDatabase = await MoveListsDatabase.get(project);
    if (moveListDatabase != null) {
      List<MoveListBuilder> builders = generateMoves();
      for (int i = 0; i < builders.length; i++) {
        MoveList moveList = await moveListDatabase.create(
          MoveList(
            name: builders[i].name,
            listNum: i + 1,
          ),
        );

        MovesDatabase? movesDatabase =
            (await MovesDatabase.getAll(project))[moveList.fileName];
        if (movesDatabase != null) {
          for (Move move in builders[i].moves) {
            await movesDatabase.create(move);
          }
        }
      }
    }

    await (await UnitPalettesDatabase.get(project))?.update(generateUnitPalette());

    UnitListsDatabase? unitListDatabase = await UnitListsDatabase.get(project);
    if (unitListDatabase != null) {
      List<UnitListBuilder> builders = generateUnits();
      for (int i = 0; i < builders.length; i++) {
        UnitList unitList = await unitListDatabase.create(
          UnitList(
            name: builders[i].name,
            listNum: i + 1,
          ),
        );

        UnitsDatabase? unitsDatabase =
        (await UnitsDatabase.getAll(project))[unitList.fileName];
        if (unitsDatabase != null) {
          for (Unit unit in builders[i].units) {
            await unitsDatabase.create(unit);
          }
        }
      }
    }
  }
}
