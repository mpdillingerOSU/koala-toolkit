import 'dart:io';

import 'package:gaming_toolkit/file_management.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/databases/database_reader.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/project.dart';
import '../data/unit_palette.dart';
import 'database_writer.dart';
import 'db_type.dart';

class UnitPalettesDatabase {
  Database? _database;

  final String projectPath;

  UnitPalettesDatabase._(this.projectPath);

  static Future<UnitPalettesDatabase?> get(Project project) async {
    String? projectPath =
        (await FileManagement.getProject(project.directoryName))?.path;
    return projectPath != null ? UnitPalettesDatabase._(projectPath) : null;
  }

  Future<Database> get database async {
    if (_database == null || !_database!.isOpen) {
      _database = await _initDB();
    }
    return _database!;
  }

  Future<bool> get hasPalette async {
    return (Sqflite.firstIntValue(await (await database).rawQuery('SELECT COUNT(*) FROM $tableUnitPalettes')) ?? 0) > 0;
  }

  Future<Database> _initDB() async {
    if (!(await Directory('$projectPath/units').exists())) {
      await Directory('$projectPath/units').create();
    }
    return await openDatabase(
      join(projectPath, 'units/palette.db'),
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableUnitPalettes (
    ${UnitPaletteFields.id} ${DBType.id},
    ${UnitPaletteFields.fields} ${DBType.text}
    )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion < 2) {}
    }
  }

  Future<UnitPalette> _create(UnitPalette palette) async {
    await (await database).insert(tableUnitPalettes, DatabaseWriter.fromUnitPalette(palette));
    return palette.copy();
  }

  Future<UnitPalette> read() async {
    List<UnitPalette> palettes =
        (await (await database).query(tableUnitPalettes))
            .map((json) => DatabaseReader.toUnitPalette(json))
            .toList();
    return palettes.isNotEmpty
        ? palettes.first
        : await _create(UnitPalette(fields: []));
  }

  Future<int> update(UnitPalette palette) async {
    if (!(await hasPalette)) {
      await _create(palette);
      return 0;
    } else {
      return await (await database).update(
        tableUnitPalettes,
        DatabaseWriter.fromUnitPalette(palette),
        where: '${UnitPaletteFields.id} = ?',
        whereArgs: [UnitPalette.staticID],
      );
    }
  }

  Future<void> close() async {
    final Database db = await database;
    db.close();
  }
}
