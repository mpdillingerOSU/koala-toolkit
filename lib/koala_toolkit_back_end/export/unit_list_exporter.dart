import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:gaming_toolkit/file_management.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../koala_strings.dart';
import '../data/units/unit.dart';
import '../data/units/unit_list.dart';
import 'json_writer.dart';
import 'python_writer.dart';
import 'c_sharp_writer.dart';
import 'cpp_writer.dart';
import 'dart_writer.dart';
import 'java_writer.dart';
import 'move_list_exporter.dart';

class UnitListExporter {
  final UnitList unitList;
  late final List<Unit> _units;
  late final String standardizedFileName;
  late String fileName;
  FileType fileType = FileType.json;

  UnitListExporter(this.unitList, List<Unit> units) {
    fileName = standardizedFileName = _generateFileName();
    _units = [...units];
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
        encoder.addDirectory(
            await CPPWriter.writeUnits(capitalize(fileName), _units));
      } else if (fileType == FileType.cs) {
        encoder.addDirectory(
            await CSharpWriter.writeUnits(capitalize(fileName), _units));
      } else if (fileType == FileType.py) {
        encoder.addDirectory(
            await PythonWriter.writeUnits(capitalize(fileName), _units));
      } else if (fileType == FileType.java) {
        encoder.addDirectory(
            await JavaWriter.writeUnits(capitalize(fileName), _units));
      } else if (fileType == FileType.dart) {
        encoder.addDirectory(
            await DartWriter.writeUnits(uncapitalize(fileName), _units));
      }
      encoder.close();
      await FileManagement.clearTemp();
      return File(zipStr);
    }

    return (await _exportFile)?.writeAsString(JsonWriter.writeUnitList(_units));
  }

  String _generateFileName() {
    String returnStr = '';
    List<String> splitStr = unitList.name.trim().split(whitespace);
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

class UnitExportPacket {
  final String fileName;
  final FileType fileType;

  UnitExportPacket(
    this.fileName,
    this.fileType,
  );
}
