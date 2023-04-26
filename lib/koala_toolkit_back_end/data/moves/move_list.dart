import '../../../koala_strings.dart';

const String tableMoveLists = 'moveLists';

class MoveListFields {
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

class MoveList {
  static const int? defaultID = null;
  static const String defaultName = 'unnamed';
  static const String defaultFileName = 'unnamed.db';
  static const int defaultListNum = 1;

  final int? id;
  final String name;
  late final String fileName;
  final int listNum;

  late final Map<String, Object?> _map;

  MoveList({
    this.id,
    required this.name,
    required this.listNum,
  }) {
    fileName = _createDatabaseFileName(name, id);
    _map = {
      MoveListFields.id: id,
      MoveListFields.name: name,
      MoveListFields.fileName: fileName,
      MoveListFields.listNum: listNum,
    };
  }

  Map<String, Object?> get map => {..._map};

  static String _createDatabaseFileName(String moveListName, int? id) {
    String returnStr = '';
    List<String> splitStr = moveListName.trim().split(whitespace);
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
    return '${returnStr}_moveList$id.db';
  }

  MoveList copy({
    int? id,
    bool nullifyID = false,
    String? name,
    int? listNum,
  }) {
    return MoveList(
      id: nullifyID ? null : id ?? this.id,
      name: name ?? this.name,
      listNum: listNum ?? this.listNum,
    );
  }

  bool equals(MoveList comp) {
    return name == comp.name &&
        fileName == comp.fileName &&
        listNum == comp.listNum;
  }

  @override
  String toString() {
    return name;
  }
}
