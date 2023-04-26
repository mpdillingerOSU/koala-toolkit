import '../../../koala_strings.dart';

const String tableUnitLists = 'unitLists';

class UnitListFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String fileName = 'fileName';
  static const String listNum = 'listNum';

  static final List<String> values = [
    id,
    name,
    fileName,
    listNum,
  ];
}

class UnitList {
  static const int? defaultID = null;
  static const String defaultName = 'unnamed';
  static const int defaultListNum = 1;

  final int? id;
  final String name;
  late final String fileName;
  final int listNum;

  late final Map<String, Object?> _map;

  UnitList({
    this.id,
    required this.name,
    required this.listNum,
  }) {
    fileName = _createDatabaseFileName(name, id);
    _map = {
      UnitListFields.id: id,
      UnitListFields.name: name,
      UnitListFields.fileName: fileName,
      UnitListFields.listNum: listNum,
    };
  }

  Map<String, Object?> get map => {..._map};

  static String _createDatabaseFileName(String unitListName, int? id) {
    String returnStr = '';
    List<String> splitStr = unitListName.trim().split(whitespace);
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
    return '${returnStr}_unitList$id.db';
  }

  UnitList copy({
    int? id,
    bool nullifyID = false,
    String? name,
    int? listNum,
  }) {
    return UnitList(
      id: nullifyID ? null : id ?? this.id,
      name: name ?? this.name,
      listNum: listNum ?? this.listNum,
    );
  }

  bool equals(UnitList comp) {
    return name == comp.name &&
        fileName == comp.fileName &&
        listNum == comp.listNum;
  }

  @override
  String toString() {
    return name;
  }
}