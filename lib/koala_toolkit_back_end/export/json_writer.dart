import '../data/moves/move.dart';
import '../data/moves/moveset.dart';
import '../data/project.dart';
import '../data/unit_field.dart';
import '../data/units/unit.dart';

class JsonWriter {
  JsonWriter._();

  static String writeProject(Project project) {
    String json = '"${_withEscapeCharacters(project.name)}": {';

    Map<String, Object?> map = project.map;

    ///Use of 1 here, as the _id is placed at 0, which is unneeded here
    for (int i = 1; i < ProjectFields.values.length; i++) {
      String field = ProjectFields.values[i];
      String val = '${map[field]}';
      String qMark = _qMarkFor(val);
      json +=
          '\n    "${_withEscapeCharacters(field)}": $qMark${_withEscapeCharacters(val)}$qMark${i != ProjectFields.values.length - 1 ? ',' : ''}';
    }

    return '$json\n}';
  }

  static String writeMoveList(List<Move> moves) {
    String json = '{';

    for (int i = 0; i < moves.length; i++) {
      json += _writeMove(moves[i], indentions: 1) +
          (i != moves.length - 1 ? ',' : '');
    }

    return '$json\n}';
  }

  static String _writeMove(Move move, {int indentions = 0}) {
    String indention = '';
    for (int i = 0; i < indentions; i++) {
      indention += '    ';
    }

    String json = '\n$indention"${_withEscapeCharacters(move.name)}": {';

    Map<String, Object?> map = move.map;

    ///Use of 1 here, as the _id is placed at 0, which is unneeded here
    for (int i = 1; i < MoveFields.values.length; i++) {
      String field = MoveFields.values[i];
      String val = '${map[field]}';
      String qMark = _qMarkFor(val);
      json +=
          '\n$indention    "${_withEscapeCharacters(field)}": $qMark${_withEscapeCharacters(val)}$qMark${i != MoveFields.values.length - 1 ? ',' : ''}';
    }

    return '$json\n$indention}';
  }

  static String writeUnitList(List<Unit> units) {
    String json = '{';

    for (int i = 0; i < units.length; i++) {
      json += _writeUnit(units[i], indentions: 1) +
          (i != units.length - 1 ? ',' : '');
    }

    return '$json\n}';
  }

  static String _writeUnit(Unit unit, {int indentions = 0}) {
    String indention = '';
    for (int i = 0; i < indentions; i++) {
      indention += '    ';
    }

    String json =
        '\n$indention"${_withEscapeCharacters(unit.name)}": {\n$indention    "Name": "${_withEscapeCharacters(unit.name)}",\n$indention    \n$indention    "Description": "${_withEscapeCharacters(unit.description)}", "Unit Number": ${unit.unitNum},\n$indention    "Moveset": {';

    List<MoveGroup> groups = unit.moveset.groups;
    //keys.sort((a, b) {
    //  return a.toLowerCase().compareTo(b.toLowerCase());
    //});
    if (groups.isNotEmpty) {
      json += '\n${_writeMoveGroup('$indention    ', groups[0])}';
      for (int i = 1; i < groups.length; i++) {
        json += ',\n${_writeMoveGroup('$indention    ', groups[i])}';
      }
    }

    Map<String, Object?> map = unit.map;
    List<UnitFieldData> fields = unit.fields;
    json += '\n}${fields.isNotEmpty ? ',' : ''}';
    for (int i = 0; i < fields.length; i++) {
      String field = fields[i].field.name;
      String val = '${map[fields[i].field.identifier]}';
      String qMark = _qMarkFor(val);
      json +=
          '\n$indention    "${_withEscapeCharacters(field)}": $qMark${_withEscapeCharacters(val)}$qMark${i != fields.length - 1 ? ',' : ''}';
    }

    return '$json\n$indention}';
  }

  static String _writeMoveGroup(String indention, MoveGroup group) {
    String str = '\n$indention"${_withEscapeCharacters(group.name)}": [';
    List<MoveGroupPair> pairs = group.pairs;
    if (pairs.isNotEmpty) {
      str += _writeMoveGroupPair('$indention ', pairs.first);
      for (int i = 1; i < pairs.length; i++) {
        str += ',${_writeMoveGroupPair('$indention    ', pairs[i])}';
      }
    }
    return '$str]';
  }

  static String _writeMoveGroupPair(String indention, MoveGroupPair pair) =>
      '\n$indention{\n$indention   "Move": "${_withEscapeCharacters(pair.move.toString())}",\n$indention    "Move List": "${_withEscapeCharacters(pair.moveList.toString())}"\n$indention}';

  static String _qMarkFor(String val) =>
      double.tryParse(val) != null || val == 'true' || val == 'false' || (val.isNotEmpty && (val[0] == '{' || val[0] == '['))
          ? ''
          : '"';

  static String _withEscapeCharacters(String val) {
    String str = '';
    for (int i = 0; i < val.length; i++) {
      if (val[i] == '\'' || val[i] == '"' || val[i] == '\\') {
        str += '\\${val[i]}';
      } else {
        str += val[i];
      }
    }
    return str;
  }
}
