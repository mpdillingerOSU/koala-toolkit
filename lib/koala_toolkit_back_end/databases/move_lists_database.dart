import 'dart:io';
import 'dart:math';

import 'package:gaming_toolkit/file_management.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/databases/database_reader.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/moves/move_list.dart';
import '../data/project.dart';
import 'database_writer.dart';
import 'db_type.dart';

class MoveListsDatabase {
  Database? _database;

  final String projectPath;

  MoveListsDatabase._(this.projectPath);

  static Future<MoveListsDatabase?> get(Project project) async {
    String? projectPath = (await FileManagement.getProject(project.directoryName))?.path;
    return projectPath != null ? MoveListsDatabase._(projectPath) : null;
  }

  Future<Database> get database async {
    if (_database == null || !_database!.isOpen) {
      _database = await _initDB();
    }
    return _database!;
  }

  Future<int?> get size async {
    return Sqflite.firstIntValue(await (await database).rawQuery('SELECT COUNT(*) FROM $tableMoveLists'));
  }

  Future<Database> _initDB() async {
    if(!(await Directory('$projectPath/moves').exists())){
      await Directory('$projectPath/moves').create();
    }
    return openDatabase(
      join(projectPath, 'moves/moveLists.db'),
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableMoveLists (
    ${MoveListFields.id} ${DBType.id},
    ${MoveListFields.name} ${DBType.text},
    ${MoveListFields.fileName} ${DBType.text},
    ${MoveListFields.listNum} ${DBType.int}
    )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion < 2) {

      }
    }
  }

  Future<MoveList> create(MoveList list) async {
    final Database db = await database;
    final int id = await db.insert(tableMoveLists, DatabaseWriter.fromMoveList(list));
    return list.copy(id: id);
  }

  Future<MoveList?> read(int? id) async {
    if (id is int) {
      final Database db = await database;
      final maps = await db.query(
        tableMoveLists,
        columns: MoveListFields.values,
        where: '${MoveListFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return DatabaseReader.toMoveList(maps.first);
      }
    }
    return null;
  }

  Future<List<MoveList>> readAll() async {
    final Database db = await database;
    final result =
    await db.query(tableMoveLists, orderBy: '${MoveListFields.listNum} ASC');
    return result.map((json) => DatabaseReader.toMoveList(json)).toList();
  }

  Future<int> update(MoveList list) async {
    final Database db = await database;

    return await db.update(
      tableMoveLists,
      DatabaseWriter.fromMoveList(list),
      where: '${MoveListFields.id} = ?',
      whereArgs: [list.id],
    );
  }

  Future<int?> delete(MoveList moveList) async {
    if (moveList.id is int) {
      final Database db = await database;

      int? returnVal = await db.delete(
        tableMoveLists,
        where: '${MoveListFields.id} = ?',
        whereArgs: [moveList.id],
      );
      databaseFactory.deleteDatabase(join(projectPath, 'moves/lists/${moveList.fileName}'));
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
    List<MoveList> moves = await readAll();
    for (int i = 0; i < moves.length; i++) {
      if (moves[i].listNum != i + 1) {
        await update(moves[i].copy(listNum: i + 1));
      }
    }
  }

  Future<void> shift(int oldMoveNum, int newMoveNum) async {
    List<MoveList> lists = await readAll();
    if (0 < oldMoveNum && oldMoveNum < lists.length + 1) {
      MoveList removed = lists.removeAt(oldMoveNum - 1);
      ///The +1 for the upperBound below, is due to the removal of the element
      /// that is being moved...
      newMoveNum = max(1, min(newMoveNum, lists.length + 1));
      lists.insert(newMoveNum - 1, removed);
      for (int i = 0; i < lists.length; i++) {
        if (lists[i].listNum != i + 1) {
          await update(lists[i].copy(listNum: i + 1));
        }
      }
    }
  }
}
