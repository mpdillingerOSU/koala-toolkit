import 'dart:math';

import 'package:gaming_toolkit/koala_toolkit_back_end/databases/unit_lists_database.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/databases/unit_palettes_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../file_management.dart';
import '../data/project.dart';
import '../data/units/unit.dart';
import '../data/units/unit_list.dart';
import '../data/unit_palette.dart';
import 'database_reader.dart';
import 'database_writer.dart';
import 'db_type.dart';

class UnitsDatabase {
  Database? _database;

  final Project project;
  final String projectPath;
  final String fileName;

  UnitsDatabase._(this.project, this.projectPath, this.fileName);

  static Future<Map<String, UnitsDatabase>> getAll(Project project) async {
    Map<String, UnitsDatabase> databases = {};
    UnitListsDatabase? mLDB = await UnitListsDatabase.get(project);
    String? projectPath = (await FileManagement.getProject(project.directoryName))?.path;
    if(mLDB != null && projectPath != null){
      for(UnitList list in await mLDB.readAll()){
        databases[list.fileName] = UnitsDatabase._(project, projectPath, list.fileName);
      }
    }
    return databases;
  }

  static Future<UnitsDatabase?> get(Project project, String fileName) async {
    return (await getAll(project))[fileName];
  }

  Future<Database> get database async {
    if (_database == null || !_database!.isOpen) {
      _database = await _initDB();
    }
    return _database!;
  }

  Future<int> get size async {
    return Sqflite.firstIntValue(await (await database).rawQuery('SELECT COUNT(*) FROM $tableUnits')) ?? 0;
  }

  Future<Database> _initDB() async {
    return openDatabase(
      join(projectPath, 'units/lists/$fileName'),
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableUnits (
    ${UnitFields.id} ${DBType.id},
    ${UnitFields.name} ${DBType.text},
    ${UnitFields.description} ${DBType.text},
    ${UnitFields.unitNum} ${DBType.int},
    ${UnitFields.moveset} ${DBType.text},
    ${UnitFields.fields} ${DBType.text}
    )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion < 2) {
        //await db.execute(
        //    'ALTER TABLE $tableUnits RENAME COLUMN essence TO ${UnitFields.element}');
      }
    }
  }

  Future<Unit> create(Unit unit) async {
    final Database db = await database;
    final int id = await db.insert(tableUnits, DatabaseWriter.fromUnit(unit));
    return unit.copyWith(id: id);
  }

  Future<Unit?> read(int? id) async {
    if (id is int) {
      final Database db = await database;
      final maps = await db.query(
        tableUnits,
        columns: UnitFields.values,
        where: '${UnitFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        UnitPalette? palette = await (await UnitPalettesDatabase.get(project))?.read();
        if(palette != null) {
          return await DatabaseReader.toUnit(maps.first, fileName, palette, project);
        }
      }
    }
    return null;
  }

  Future<List<Unit>> readAll() async {
    UnitPalette? palette = await (await UnitPalettesDatabase.get(project))?.read();
    if(palette == null) return [];

    final Database db = await database;
    final result =
    await db.query(tableUnits, orderBy: '${UnitFields.unitNum} ASC');
    List<Future<Unit>> futures = result.map((json) => DatabaseReader.toUnit(json, fileName, palette, project)).toList();
    List<Unit> units = [];
    for(Future<Unit> unit in futures){
      units.add(await unit);
    }
    return units;
  }

  Future<int> update(Unit unit) async {
    final Database db = await database;

    return await db.update(
      tableUnits,
      DatabaseWriter.fromUnit(unit),
      where: '${UnitFields.id} = ?',
      whereArgs: [unit.id],
    );
  }

  Future<int?> delete(int? id) async {
    if (id is int) {
      final Database db = await database;

      int? returnVal = await db.delete(
        tableUnits,
        where: '${UnitFields.id} = ?',
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
    List<Unit> units = await readAll();
    for (int i = 0; i < units.length; i++) {
      if (units[i].unitNum != i + 1) {
        await update(units[i].copyWith(unitNum: i + 1));
      }
    }
  }

  Future<void> shift(int oldUnitNum, int newUnitNum) async {
    List<Unit> units = await readAll();
    if (0 < oldUnitNum && oldUnitNum < units.length + 1) {
      Unit removed = units.removeAt(oldUnitNum - 1);
      ///The +1 for the upperBound below, is due to the removal of the element
      /// that is being moved...
      newUnitNum = max(1, min(newUnitNum, units.length + 1));
      units.insert(newUnitNum - 1, removed);
      for (int i = 0; i < units.length; i++) {
        if (units[i].unitNum != i + 1) {
          await update(units[i].copyWith(unitNum: i + 1));
        }
      }
    }
  }

  Future<bool> contains(Unit unit) async {
    for(Unit comp in await readAll()){
      if(unit.equals(comp)){
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
    for(Unit unit in await readAll()){
      if(name == unit.name){
        return true;
      }
    }
    return false;
  }
}
