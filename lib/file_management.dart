import 'dart:io';

import 'package:gaming_toolkit/koala_toolkit_back_end/project_packet.dart';
import 'package:io/io.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'koala_toolkit_back_end/data/project.dart';
import 'koala_toolkit_back_end/databases/projects_database.dart';
import 'koala_toolkit_back_end/templates/template.dart';

class FileManagement{
  FileManagement._();

  static Future<String> get localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  static Future<String> get tempPath async {
    String path = '${await localPath}/temp';
    if(!(await Directory(path).exists())){
      await Directory(path).create();
    }
    return path;
  }

  static Future<String> get databasesPath async => await getDatabasesPath();

  static Future<Directory> get tempDirectory async => Directory(await tempPath);

  static Future<void> clearTemp() async => (await tempDirectory).deleteSync(recursive: true);

  static Future<String> get projectsPath async {
    String path = '${await databasesPath}/projects';
    if(!(await Directory(path).exists())){
      await Directory(path).create();
    }
    return path;
  }

  static Future<Directory> get projectsDirectory async => Directory(await projectsPath);

  static Future<List<Directory>> get allProjects async {
    List<Directory> projects = [];
    List<FileSystemEntity> entities = (await projectsDirectory).listSync();
    for(FileSystemEntity entity in entities){
      if(entity is Directory){
        projects.add(entity);
      }
    }
    return projects;
  }

  static Future<Directory?> getProject(String directoryName) async {
    String path = '${await projectsPath}/$directoryName';
    if((await Directory(path).exists())){
      return Directory(path);
    }
    return null;
  }

  static Future<Directory?> addProject(Project project, Template template) async {
    String path = '${await projectsPath}/${project.directoryName}';
    if(!(await Directory(path).exists())){
      Directory dir = await Directory(path).create();
      ProjectsDatabase projectDb = ProjectsDatabase(path);
      await projectDb.update(project);
      await Directory('$path/moves').create();
      await Directory('$path/moves/lists').create();
      await Directory('$path/units').create();
      await Directory('$path/units/lists').create();
      await template.generate(project);
      return dir;
    }
    return null;
  }

  static Future<bool> renameProject(String oldDirectoryName, String newDirectoryName) async {
    String oldPath = '${await projectsPath}/$oldDirectoryName';
    String newPath = '${await projectsPath}/$newDirectoryName';
    if((await Directory(oldPath).exists()) && !(await Directory(newPath).exists())){
      Directory(oldPath).renameSync(newPath);
      return true;
    }
    return false;
  }

  static Future<Directory?> duplicateProject(String originalDirectoryName, String duplicateDirectoryName) async {
    String originalPath = '${await projectsPath}/$originalDirectoryName';
    String duplicatePath = '${await projectsPath}/$duplicateDirectoryName';
    if((await Directory(originalPath).exists()) && !(await Directory(duplicatePath).exists())){
      copyPathSync(originalPath, duplicatePath);
      return Directory(duplicatePath);
    }
    return null;
  }

  static Future<bool> deleteProject(Project project) async {
    String path = '${await projectsPath}/${project.directoryName}';
    if((await Directory(path).exists())){
      await (await ProjectPacket.create(project))?.closeAllDatabases();
      _subDelete(path);
      return true;
    }
    return false;
  }

  static Future<void> _subDelete(String path) async {
    for(FileSystemEntity entity in Directory(path).listSync()){
      if(entity is Directory){
        _subDelete(entity.path);
      } else if (entity.path.substring(entity.path.length - 3) == '.db'){
        databaseFactory.deleteDatabase(entity.path);
      } else {
        Directory(entity.path).deleteSync(recursive: true);
      }
    }
    Directory(path).deleteSync(recursive: true);
  }

  static Future<String?> get downloadsPath async =>
      (await DownloadsPath.downloadsDirectory())?.path;
}