import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:gaming_toolkit/file_management.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../koala_strings.dart';
import '../data/moves/move.dart';
import '../data/moves/move_list.dart';
import 'json_writer.dart';
import 'python_writer.dart';
import 'c_sharp_writer.dart';
import 'cpp_writer.dart';
import 'dart_writer.dart';
import 'java_writer.dart';

class MoveListExporter {
  final MoveList moveList;
  late final List<Move> _moves;
  late final String standardizedFileName;
  late String fileName;
  FileType fileType = FileType.json;

  MoveListExporter(this.moveList, List<Move> moves) {
    fileName = standardizedFileName = _generateFileName();
    _moves = [...moves];
  }

  Future<File> get _localFile async =>
      File('${await FileManagement.localPath}/$fileName${fileType.extension}');

  Future<File?> get _exportFile async {
    String? exportPath = await FileManagement.downloadsPath;
    if (exportPath == null) return null;

    final String main = '$exportPath/$fileName';
    final String end = fileType.extension;
    if (!(await File('$main$end').exists())) return File('$main$end');

    int num = 1;
    while (await File('$main($num)$end').exists()) {
      num++;
    }
    return File('$main($num)$end');
  }

  Future<String?> get _zipFileString async {
    String? exportPath = await FileManagement.downloadsPath;
    if (exportPath == null) return null;

    final String main = '$exportPath/$fileName';
    const String end = '.zip';
    if (!(await File('$main$end').exists())) return '$main$end';

    int num = 1;
    while (await File('$main($num)$end').exists()) {
      num++;
    }
    return '$main($num)$end';
  }

  Future<FileSystemEntity?> write() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (fileType.isZipped) {
      ZipFileEncoder encoder = ZipFileEncoder();
      String? zipStr = await _zipFileString;
      if (zipStr == null) return null;

      encoder.create(zipStr);
      if (fileType == FileType.cpp) {
        encoder.addDirectory(await CPPWriter.writeMoves(
            capitalize(fileName), _moves));
      } else if (fileType == FileType.cs) {
        encoder.addDirectory(await CSharpWriter.writeMoves(
            capitalize(fileName), _moves));
      } else if (fileType == FileType.py) {
        encoder.addDirectory(await PythonWriter.writeMoves(
            capitalize(fileName), _moves));
      } else if (fileType == FileType.java) {
        encoder.addDirectory(await JavaWriter.writeMoves(
            capitalize(fileName), _moves));
      } else if (fileType == FileType.dart) {
        encoder.addDirectory(await DartWriter.writeMoves(
            uncapitalize(fileName), _moves));
      }
      encoder.close();
      await FileManagement.clearTemp();
      return File(zipStr);
    }

    return (await _exportFile)?.writeAsString(JsonWriter.writeMoveList(_moves));
  }

  String _generateFileName() {
    String returnStr = '';
    List<String> splitStr = moveList.name.trim().split(whitespace);
    List<String> alphaNums = [];
    for (String str in splitStr) {
      String temp = asLowercaseAlphanumeric(str);
      if (temp != '') {
        alphaNums.add(temp);
      }
    }
    if (alphaNums.isNotEmpty) {
      returnStr += alphaNums.first;
      for (int i = 1; i < alphaNums.length; i++) {
        returnStr += alphaNums[i].isNotEmpty
            ? alphaNums[i][0].toUpperCase() + alphaNums[i].substring(1)
            : '';
      }
    }
    return returnStr;
  }
}

enum FileType {
  json(
    'JSON',
    '.json',
    false,
  ),
  txt(
    'Text',
    '.txt',
    false,
  ),
  cpp(
    'C++',
    '.cpp',
    true,
  ),
  cs(
    'C#',
    '.cs',
    true,
  ),
  py(
    'Python',
    '.py',
    true,
  ),
  java(
    'Java',
    '.java',
    true,
  ),
  dart(
    'Dart',
    '.dart',
    true,
  );

  final String name;
  final String extension;
  final bool isZipped;

  static Map<String, FileType> get map => {..._map};

  static final Map<String, FileType> _map = _generateMap();

  static Map<String, FileType> _generateMap() {
    Map<String, FileType> returnMap = {};
    for (FileType fileType in FileType.values) {
      returnMap[fileType.name] = fileType;
    }
    return returnMap;
  }

  const FileType(
    this.name,
    this.extension,
    this.isZipped,
  );

  static List<String> allNames() {
    List<String> list = [];
    for (FileType fileType in values) {
      list.add(fileType.name);
    }
    return list;
  }
}

class MoveExportPacket {
  final String fileName;
  final FileType fileType;

  MoveExportPacket(
    this.fileName,
    this.fileType,
  );
}
