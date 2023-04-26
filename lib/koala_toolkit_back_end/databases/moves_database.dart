import 'dart:math';

import 'package:gaming_toolkit/koala_toolkit_back_end/databases/move_lists_database.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/data/moves/move.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../file_management.dart';
import '../data/moves/move_list.dart';
import '../data/project.dart';
import 'database_reader.dart';
import 'database_writer.dart';
import 'db_type.dart';

class MovesDatabase {
  Database? _database;

  final String projectPath;
  final String fileName;

  MovesDatabase._(this.projectPath, this.fileName);

  static Future<Map<String, MovesDatabase>> getAll(Project project) async {
    Map<String, MovesDatabase> databases = {};
    MoveListsDatabase? mLDB = await MoveListsDatabase.get(project);
    String? projectPath = (await FileManagement.getProject(project.directoryName))?.path;
    if(mLDB != null && projectPath != null){
      for(MoveList list in await mLDB.readAll()){
        databases[list.fileName] = MovesDatabase._(projectPath, list.fileName);
      }
    }
    return databases;
  }

  static Future<MovesDatabase?> get(Project project, String fileName) async {
    return (await getAll(project))[fileName];
  }

  Future<Database> get database async {
    if (_database == null || !_database!.isOpen) {
      _database = await _initDB();
    }
    return _database!;
  }

  Future<int> get size async {
    return Sqflite.firstIntValue(await (await database).rawQuery('SELECT COUNT(*) FROM $tableMoves')) ?? 0;
  }

  Future<Database> _initDB() async {
    return openDatabase(
      join(projectPath, 'moves/lists/$fileName'),
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableMoves (
    ${MoveFields.id} ${DBType.id},
    ${MoveFields.name} ${DBType.text},
    ${MoveFields.description} ${DBType.text},
    ${MoveFields.moveNum} ${DBType.int},
    ${MoveFields.element} ${DBType.text},
    ${MoveFields.moveType} ${DBType.text},
    ${MoveFields.energyCost} ${DBType.int},
    ${MoveFields.hasPower} ${DBType.bool},
    ${MoveFields.powerMin} ${DBType.int},
    ${MoveFields.powerMax} ${DBType.int},
    ${MoveFields.rangeMin} ${DBType.int},
    ${MoveFields.rangeMax} ${DBType.int},
    ${MoveFields.accuracy} ${DBType.int},
    ${MoveFields.hasKnockback} ${DBType.bool},
    ${MoveFields.knockbackValue} ${DBType.int},
    ${MoveFields.isKnockbackAirborne} ${DBType.bool},
    ${MoveFields.knockbackType} ${DBType.text},
    ${MoveFields.hasLunge} ${DBType.bool},
    ${MoveFields.lungeValue} ${DBType.int},
    ${MoveFields.isLungeAirborne} ${DBType.bool},
    ${MoveFields.hasLOSModifier} ${DBType.bool},
    ${MoveFields.hasLOS} ${DBType.bool},
    ${MoveFields.hasRangeBoostableModifier} ${DBType.bool},
    ${MoveFields.isRangeBoostable} ${DBType.bool},
    ${MoveFields.hasDirectContactModifier} ${DBType.bool},
    ${MoveFields.hasDirectContact} ${DBType.bool},
    ${MoveFields.hasUtility} ${DBType.bool},
    ${MoveFields.utilityType} ${DBType.text},
    ${MoveFields.hasCompoundingPowerModifier} ${DBType.bool},
    ${MoveFields.hasCompoundingPower} ${DBType.bool},
    ${MoveFields.hasDeprecatingPowerModifier} ${DBType.bool},
    ${MoveFields.hasDeprecatingPower} ${DBType.bool},
    ${MoveFields.hasMultiHit} ${DBType.bool},
    ${MoveFields.multiHitValue} ${DBType.int},
    ${MoveFields.hasPull} ${DBType.bool},
    ${MoveFields.pullValue} ${DBType.int},
    ${MoveFields.isPullAirborne} ${DBType.bool},
    ${MoveFields.pullPriority} ${DBType.text},
    ${MoveFields.pullType} ${DBType.text},
    ${MoveFields.hasBattleEffect} ${DBType.bool},
    ${MoveFields.battleEffectType} ${DBType.text},
    ${MoveFields.hasBounceback} ${DBType.bool},
    ${MoveFields.bouncebackValue} ${DBType.int},
    ${MoveFields.isBouncebackAirborne} ${DBType.bool},
    ${MoveFields.bouncebackPriority} ${DBType.text},
    ${MoveFields.hasRecoil} ${DBType.bool},
    ${MoveFields.recoilMin} ${DBType.int},
    ${MoveFields.recoilMax} ${DBType.int},
    ${MoveFields.hasCooldown} ${DBType.bool},
    ${MoveFields.cooldownValue} ${DBType.int},
    ${MoveFields.hasSideEffect} ${DBType.bool},
    ${MoveFields.sideEffectType} ${DBType.text},
    ${MoveFields.hasCrashDamage} ${DBType.bool},
    ${MoveFields.crashDamageMin} ${DBType.int},
    ${MoveFields.crashDamageMax} ${DBType.int}
    )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion < 2) {
        //await db.execute(
        //    'ALTER TABLE $tableMoves ADD COLUMN ${MoveFields.description} $textType DEFAULT fill in description here');
      }
    }
  }

  Future<Move> create(Move move) async {
    final Database db = await database;
    final int id = await db.insert(tableMoves, DatabaseWriter.fromMove(move));
    return move.copy(id: id);
  }

  Future<Move?> read(int? id) async {
    if (id is int) {
      final Database db = await database;
      final maps = await db.query(
        tableMoves,
        columns: MoveFields.values,
        where: '${MoveFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return DatabaseReader.toMove(maps.first);
      }
    }
    return null;
  }

  Future<List<Move>> readAll() async {
    final Database db = await database;
    final result =
        await db.query(tableMoves, orderBy: '${MoveFields.moveNum} ASC');
    return result.map((json) => DatabaseReader.toMove(json)).toList();
  }

  Future<int> update(Move move) async {
    final Database db = await database;

    return await db.update(
      tableMoves,
      DatabaseWriter.fromMove(move),
      where: '${MoveFields.id} = ?',
      whereArgs: [move.id],
    );
  }

  Future<int?> delete(int? id) async {
    if (id is int) {
      final Database db = await database;

      int? returnVal = await db.delete(
        tableMoves,
        where: '${MoveFields.id} = ?',
        whereArgs: [id],
      );
      await renumber();
      return returnVal;
    }
    return null;
  }

  Future<void> close() async {
    final Database db = await database;
    db.close();
  }

  Future<void> renumber() async {
    List<Move> moves = await readAll();
    for (int i = 0; i < moves.length; i++) {
      if (moves[i].moveNum != i + 1) {
        await update(moves[i].copy(moveNum: i + 1));
      }
    }
  }

  Future<void> shift(int oldMoveNum, int newMoveNum) async {
    List<Move> moves = await readAll();
    if (0 < oldMoveNum && oldMoveNum < moves.length + 1) {
      Move removed = moves.removeAt(oldMoveNum - 1);
      ///The +1 for the upperBound below, is due to the removal of the element
      /// that is being moved...
      newMoveNum = max(1, min(newMoveNum, moves.length + 1));
      moves.insert(newMoveNum - 1, removed);
      for (int i = 0; i < moves.length; i++) {
        if (moves[i].moveNum != i + 1) {
          await update(moves[i].copy(moveNum: i + 1));
        }
      }
    }
  }

  Future<bool> contains(Move move) async {
    for(Move comp in await readAll()){
      if(move.equals(comp)){
        return true;
      }
    }
    return false;
  }

  Future<String> safeName(String name) async {
    if(!(await isNameTaken(name))) return name;

    int num = 2;
    while (await isNameTaken('$name$num')) {
      num++;
    }
    return '$name$num';
  }

  Future<bool> isNameTaken(String name) async {
    for(Move move in await readAll()){
      if(name == move.name){
        return true;
      }
    }
    return false;
  }
}
