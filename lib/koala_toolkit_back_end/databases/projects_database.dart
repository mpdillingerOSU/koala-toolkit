import 'dart:io';

import 'package:gaming_toolkit/file_management.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/project.dart';
import 'database_reader.dart';
import 'database_writer.dart';
import 'db_type.dart';

class ProjectsDatabase {
  Database? _database;

  final String projectPath;

  ProjectsDatabase(this.projectPath);

  static Future<Map<String, ProjectsDatabase>> get allDatabases async {
    Map<String, ProjectsDatabase> databases = {};
    for (Directory dir in await FileManagement.allProjects) {
      databases[dir.path.substring(dir.path.lastIndexOf('/') + 1)] =
          ProjectsDatabase(dir.path);
    }
    return databases;
  }

  static Future<ProjectsDatabase?> get(String directoryName) async {
    return (await allDatabases)[directoryName];
  }

  Future<Database> get database async {
    if (_database == null || !_database!.isOpen) {
      _database = await _initDB();
    }
    return _database!;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
      join(projectPath, 'project.db'),
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableProjects (
    ${ProjectFields.id} ${DBType.id},
    ${ProjectFields.name} ${DBType.text},
    ${ProjectFields.directoryName} ${DBType.text},
    ${ProjectFields.createdDate} ${DBType.text},
    ${ProjectFields.lastSavedDate} ${DBType.text},
    ${ProjectFields.version} ${DBType.double}
    )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion < 2) {

      }
    }
  }

  Future<Project> _create(Project project) async {
    final Database db = await database;
    await db.insert(tableProjects, DatabaseWriter.fromProject(project));
    return project.copyWith();
  }

  Future<Project?> read() async {
    List<Project> projects = (await (await database).query(tableProjects))
        .map((json) => DatabaseReader.toProject(json))
        .toList();
    return projects.isNotEmpty ? projects.first : null;
  }

  Future<int> update(Project project) async {
    Project? current = await read();
    if (current == null) {
      await _create(project);
      return 0;
    } else {
      final Database db = await database;
      Project updated = Project(
        name: project.name,
        createdDate: current.createdDate,
        lastSavedDate: project.lastSavedDate,
        version: project.version, //TODO: change to a getter for the current version held in the settings page...
      );
      return await db.update(
        tableProjects,
        DatabaseWriter.fromProject(updated),
        where: '${ProjectFields.id} = ?',
        whereArgs: [Project.staticID],
      );
    }
  }

  Future<Project?> updateLastEdited() async {
    Project? current = await read();
    if(current != null){
      final Database db = await database;
      Project updated = Project(
        name: current.name,
        createdDate: current.createdDate,
        lastSavedDate: DateTime.now().toUtc().toIso8601String(),
        version: current.version, //TODO: change to a getter for the current version held in the settings page...
      );
      await db.update(
        tableProjects,
        DatabaseWriter.fromProject(updated),
        where: '${ProjectFields.id} = ?',
        whereArgs: [Project.staticID],
      );
      return updated;
    }
    return null;
  }

  Future<void> close() async {
    final Database db = await database;
    db.close();
  }
}
