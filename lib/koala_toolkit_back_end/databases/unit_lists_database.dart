import 'dart:io';
import 'dart:math';

import 'package:gaming_toolkit/file_management.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/databases/database_writer.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/project.dart';
import '../data/units/unit_list.dart';
import 'database_reader.dart';
import 'db_type.dart';

class UnitListsDatabase {
  Database? _database;

  final String projectPath;

  UnitListsDatabase._(this.projectPath);

  static Future<UnitListsDatabase?> get(Project project) async {
    String? projectPath =
        (await FileManagement.getProject(project.directoryName))?.path;
    return projectPath != null ? UnitListsDatabase._(projectPath) : null;
  }

  Future<Database> get database async {
    if (_database == null || !_database!.isOpen) {
      _database = await _initDB();
    }
    return _database!;
  }

  Future<int?> get size async {
    return Sqflite.firstIntValue(await (await database)
        .rawQuery('SELECT COUNT(*) FROM $tableUnitLists'));
  }

  Future<Database> _initDB() async {
    if (!(await Directory('$projectPath/units').exists())) {
      await Directory('$projectPath/units').create();
    }
    return openDatabase(
      join(projectPath, 'units/unitLists.db'),
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableUnitLists (
    ${UnitListFields.id} ${DBType.id},
    ${UnitListFields.name} ${DBType.text},
    ${UnitListFields.fileName} ${DBType.text},
    ${UnitListFields.listNum} ${DBType.int}
    )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion < 2) {}
    }
  }

  Future<UnitList> create(UnitList list) async {
    final Database db = await database;
    final int id =
        await db.insert(tableUnitLists, DatabaseWriter.fromUnitList(list));
    return list.copy(id: id);
  }

  Future<UnitList?> read(int? id) async {
    if (id is int) {
      final Database db = await database;
      final maps = await db.query(
        tableUnitLists,
        columns: UnitListFields.values,
        where: '${UnitListFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return DatabaseReader.toUnitList(maps.first);
      }
    }
    return null;
  }

  Future<List<UnitList>> readAll() async {
    final Database db = await database;
    final result = await db.query(tableUnitLists,
        orderBy: '${UnitListFields.listNum} ASC');
    return result.map((json) => DatabaseReader.toUnitList(json)).toList();
  }

  Future<int> update(UnitList list) async {
    final Database db = await database;

    return await db.update(
      tableUnitLists,
      DatabaseWriter.fromUnitList(list),
      where: '${UnitListFields.id} = ?',
      whereArgs: [list.id],
    );
  }

  Future<int?> delete(UnitList unitList) async {
    if (unitList.id is int) {
      final Database db = await database;

      int? returnVal = await db.delete(
        tableUnitLists,
        where: '${UnitListFields.id} = ?',
        whereArgs: [unitList.id],
      );
      databaseFactory.deleteDatabase(
          join(projectPath, 'units/lists/${unitList.fileName}'));
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
    List<UnitList> units = await readAll();
    for (int i = 0; i < units.length; i++) {
      if (units[i].listNum != i + 1) {
        await update(units[i].copy(listNum: i + 1));
      }
    }
  }

  Future<void> shift(int oldUnitNum, int newUnitNum) async {
    List<UnitList> lists = await readAll();
    if (0 < oldUnitNum && oldUnitNum < lists.length + 1) {
      UnitList removed = lists.removeAt(oldUnitNum - 1);

      ///The +1 for the upperBound below, is due to the removal of the element
      /// that is being moved...
      newUnitNum = max(1, min(newUnitNum, lists.length + 1));
      lists.insert(newUnitNum - 1, removed);
      for (int i = 0; i < lists.length; i++) {
        if (lists[i].listNum != i + 1) {
          await update(lists[i].copy(listNum: i + 1));
        }
      }
    }
  }
}
