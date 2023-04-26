import 'package:gaming_toolkit/koala_toolkit_back_end/databases/unit_lists_database.dart';

import '../../koala_strings.dart';
import '../data/moves/move.dart';
import '../data/moves/move_list.dart';
import '../data/moves/moveset.dart';
import '../data/project.dart';
import '../data/unit_field.dart';
import '../data/unit_palette.dart';
import '../data/units/unit.dart';
import '../data/units/unit_list.dart';
import 'move_lists_database.dart';
import 'moves_database.dart';

class DatabaseReader {
  DatabaseReader._();

  static Project toProject(Map<String, Object?> json) {
    return Project(
      name: json[ProjectFields.name] as String,
      createdDate: json[ProjectFields.createdDate] as String,
      lastSavedDate: json[ProjectFields.lastSavedDate] as String,
      version: json[ProjectFields.version] as double,
    );
  }

  static Move toMove(Map<String, Object?> json) {
    return Move(
      id: json[MoveFields.id] as int?,
      name: json[MoveFields.name] as String,
      description: json[MoveFields.description] as String,
      moveNum: json[MoveFields.moveNum] as int,
      element: json[MoveFields.element] as String,
      moveType: json[MoveFields.moveType] as String,
      energyCost: json[MoveFields.energyCost] as int,
      hasPower: json[MoveFields.hasPower] == 1,
      powerMin: json[MoveFields.powerMin] as int,
      powerMax: json[MoveFields.powerMax] as int,
      rangeMin: json[MoveFields.rangeMin] as int,
      rangeMax: json[MoveFields.rangeMax] as int,
      accuracy: json[MoveFields.accuracy] as int,
      hasKnockback: json[MoveFields.hasKnockback] == 1,
      knockbackValue: json[MoveFields.knockbackValue] as int,
      isKnockbackAirborne: json[MoveFields.isKnockbackAirborne] == 1,
      knockbackType: json[MoveFields.knockbackType] as String,
      hasLunge: json[MoveFields.hasLunge] == 1,
      lungeValue: json[MoveFields.lungeValue] as int,
      isLungeAirborne: json[MoveFields.isLungeAirborne] == 1,
      hasLOSModifier: json[MoveFields.hasLOSModifier] == 1,
      hasLOS: json[MoveFields.hasLOS] == 1,
      hasRangeBoostableModifier:
          json[MoveFields.hasRangeBoostableModifier] == 1,
      isRangeBoostable: json[MoveFields.isRangeBoostable] == 1,
      hasDirectContactModifier: json[MoveFields.hasDirectContactModifier] == 1,
      hasDirectContact: json[MoveFields.hasDirectContact] == 1,
      hasUtility: json[MoveFields.hasUtility] == 1,
      utilityType: json[MoveFields.utilityType] as String,
      hasCompoundingPowerModifier:
          json[MoveFields.hasCompoundingPowerModifier] == 1,
      hasCompoundingPower: json[MoveFields.hasCompoundingPower] == 1,
      hasDeprecatingPowerModifier:
          json[MoveFields.hasDeprecatingPowerModifier] == 1,
      hasDeprecatingPower: json[MoveFields.hasDeprecatingPower] == 1,
      hasMultiHit: json[MoveFields.hasMultiHit] == 1,
      multiHitValue: json[MoveFields.multiHitValue] as int,
      hasPull: json[MoveFields.hasPull] == 1,
      pullValue: json[MoveFields.pullValue] as int,
      isPullAirborne: json[MoveFields.isPullAirborne] == 1,
      pullPriority: json[MoveFields.pullPriority] as String,
      pullType: json[MoveFields.pullType] as String,
      hasBattleEffect: json[MoveFields.hasBattleEffect] == 1,
      battleEffectType: json[MoveFields.battleEffectType] as String,
      hasBounceback: json[MoveFields.hasBounceback] == 1,
      bouncebackValue: json[MoveFields.bouncebackValue] as int,
      isBouncebackAirborne: json[MoveFields.isBouncebackAirborne] == 1,
      bouncebackPriority: json[MoveFields.bouncebackPriority] as String,
      hasRecoil: json[MoveFields.hasRecoil] == 1,
      recoilMin: json[MoveFields.recoilMin] as int,
      recoilMax: json[MoveFields.recoilMax] as int,
      hasCooldown: json[MoveFields.hasCooldown] == 1,
      cooldownValue: json[MoveFields.cooldownValue] as int,
      hasSideEffect: json[MoveFields.hasSideEffect] == 1,
      sideEffectType: json[MoveFields.sideEffectType] as String,
      hasCrashDamage: json[MoveFields.hasCrashDamage] == 1,
      crashDamageMin: json[MoveFields.crashDamageMin] as int,
      crashDamageMax: json[MoveFields.crashDamageMax] as int,
    );
  }

  static MoveList toMoveList(Map<String, Object?> json) {
    return MoveList(
      id: json[MoveListFields.id] as int?,
      name: json[MoveListFields.name] as String,
      listNum: json[MoveListFields.listNum] as int,
    );
  }

  static UnitField? toUnitField(Map<String, Object> map) {
    if (map['type'] == UnitFieldTypes.intType) {
      return UnitFieldInt(
        name: map['name'] as String,
        defaultVal: map['defaultVal'] as int,
        minVal: map['minVal'] as int,
        maxVal: map['maxVal'] as int,
      );
    } else if (map['type'] == UnitFieldTypes.boolType) {
      return UnitFieldBool(
        name: map['name'] as String,
        defaultVal: map['defaultVal'] as bool,
      );
    } else if (map['type'] == UnitFieldTypes.stringType) {
      return UnitFieldString(
        name: map['name'] as String,
        defaultVal: map['defaultVal'] as String,
      );
    } else if (map['type'] == UnitFieldTypes.enumType) {
      List<String> vals = [];
      for(Object obj in map['vals'] as List<Object>){
        vals.add(obj.toString());
      }
      return UnitFieldEnum(
        name: map['name'] as String,
        vals: vals,
      );
    }
    return null;
  }

  static UnitPalette toUnitPalette(Map<String, Object?> json) {
    List<UnitField> list = [];
    List<Map<String, Object>> fields = [];
    for(Object obj in _getList(json[UnitPaletteFields.fields] as String, 0) ?? []){
      if(obj is Map){
        Map<String, Object> map = {};
        for(Object key in obj.keys){
          if(key is String){
            map[key] = obj[key];
          }
        }
        fields.add(map);
      }
    }

    for (Map<String, Object> data in fields) {
      UnitField? unitField = toUnitField(data);
      if (unitField != null) {
        list.add(unitField);
      }
    }

    return UnitPalette(fields: list);
  }

  static Future<UnitFieldData?> toUnitFieldData(
    List<Object> data,
    String unitListFileName,
    UnitPalette palette,
    Project project,
  ) async {
    if (data.length == 2 && data[0] is String) {
      String fieldName = data[0] as String;
      Object val = data[1];
      List<UnitList>? unitLists =
          await (await UnitListsDatabase.get(project))?.readAll();
      if (unitLists != null) {
        for (UnitList list in unitLists) {
          if (list.fileName == unitListFileName) {
            List<UnitField> unitFields = palette.fields;
            for (UnitField unitField in unitFields) {
              if (unitField.name == fieldName) {
                if (unitField.type == UnitFieldTypes.intType) {
                  int? intVal = int.tryParse(val.toString());
                  return intVal != null
                      ? UnitFieldData(unitField, intVal)
                      : null;
                } else if (unitField.type == UnitFieldTypes.boolType) {
                  bool? boolVal = val.toString() == 'true'
                      ? true
                      : val.toString() == 'false'
                          ? false
                          : null;
                  return boolVal != null
                      ? UnitFieldData(unitField, boolVal)
                      : null;
                } else if (unitField.type == UnitFieldTypes.stringType) {
                  return UnitFieldData(unitField, val);
                } else if (unitField.type == UnitFieldTypes.enumType) {
                  return UnitFieldData(unitField, val);
                }
                return null;
              }
            }
            return null;
          }
        }
      }
    }
    return null;
  }

  static Future<Unit> toUnit(
    Map<String, Object?> json,
    String unitListFileName,
    UnitPalette palette,
    Project project,
  ) async {
    return Unit(
      id: json[UnitFields.id] as int?,
      name: json[UnitFields.name] as String,
      description: json[UnitFields.description] as String,
      unitNum: json[UnitFields.unitNum] as int,
      moveset: await _movesetFromString(
        json[UnitFields.moveset] as String,
        project,
      ),
      fields: await _fieldsFromString(
        json[UnitFields.fields] as String,
        unitListFileName,
        palette,
        project,
      ),
    );
  }

  static Future<Moveset> _movesetFromString(
    String json,
    Project project,
  ) async {
    List<MoveGroup> groups = [];
    List<MoveList>? lists =
        await (await MoveListsDatabase.get(project))?.readAll();
    if (lists != null) {
      Map<String, List<Move>> moveMap = {};
      for (MoveList list in lists) {
        moveMap[list.name] =
            await (await MovesDatabase.get(project, list.fileName))
                    ?.readAll() ??
                [];
      }

      Map<Object, Object>? rawMap = _getDictionary(json, 0);
      if (rawMap != null) {
        Map<String, List<List<String>>> map = {};
        for(Object key in rawMap.keys){
          if(key is String){
            Object? rawVal = rawMap[key];
            if(rawVal != null && rawVal is List){
              List<List<String>> val = [];
              for(Object pair in rawVal){
                if(pair is List && pair.length == 2){
                  val.add([pair[0].toString(), pair[1].toString()]);
                }
              }
              map[key] = val;
            }
          }
        }

        for (String key in map.keys) {
          List<List<String>> pairStrings = map[key]!;
          List<MoveGroupPair> pairs = [];
          for (List<String> pair in pairStrings) {
            if (pair.length == 2) {
              MoveList? moveList;
              for (MoveList list in lists) {
                if (pair[1] == list.name) {
                  moveList = list;
                  break;
                }
              }
              if (moveList != null) {
                Move? move;
                for (Move search in moveMap[moveList.name] ?? []) {
                  if (pair[0] == search.name) {
                    move = search;
                    break;
                  }
                }
                if (move != null) {
                  pairs.add(MoveGroupPair(move, moveList));
                }
              }
            }
          }
          groups.add(MoveGroup(key, pairs));
        }
      }
    }

    return Moveset(groups);
  }

  static Future<List<UnitFieldData>> _fieldsFromString(
    String json,
    String unitListFileName,
    UnitPalette palette,
    Project project,
  ) async {
    List<UnitFieldData> datas = [];
    List<Object>? rawList = _getList(json, 0);
    if (rawList != null) {
      List<List<Object>> list = [];
      for(Object rawInnerList in rawList){
        if(rawInnerList is List){
          List<Object> innerList = [];
          for(Object obj in rawInnerList){
            innerList.add(obj);
          }
          list.add(innerList);
        }
      }

      List<UnitFieldData> temp = [];
      for (List<Object> data in list) {
        UnitFieldData? fieldData =
            await toUnitFieldData(data, unitListFileName, palette, project);
        if (fieldData != null) {
          temp.add(fieldData);
        }
      }

      for(UnitField field in palette.fields){
        bool added = false;
        for(UnitFieldData data in temp){
          if(data.field.name == field.name){
            datas.add(data);
            added = true;
            break;
          }
        }
        if(!added) datas.add(UnitFieldData(field, field.defaultVal));
      }
    }
    return datas;
  }

  static UnitList toUnitList(Map<String, Object?> json) {
    return UnitList(
      id: json[UnitListFields.id] as int?,
      name: json[UnitListFields.name] as String,
      listNum: json[UnitListFields.listNum] as int,
    );
  }

  static int _backslashCount(String val) {
    int backslashes = 0;
    int pos = val.length - 1;
    while (val[pos] == '\\' && pos > -1) {
      backslashes++;
      pos--;
    }
    return backslashes;
  }

  static String _removeEscapeCharacters(String val) {
    String str = '';
    for (int i = 0; i < val.length; i++) {
      if (val[i] == '\\' && i + 1 < val.length) {
        str += val[1 + i++];
      } else {
        str += val[i];
      }
    }

    return str;
  }

  static Map<Object, Object>? _getDictionary(String str, int startIndex) {
    String? dictStr = _getDictionaryString(str, startIndex);
    if (dictStr != null) {
      Map<Object, Object> dict = {};
      for (int i = 0; i < dictStr.length; i++) {
        String char = dictStr[i];
        if (!char.contains(whitespace)) {
          _SearchCapsule? capsule = _getNextData(dictStr, i);
          if (capsule != null) {
            Object key = capsule.obj;
            int? valPos = _getDictValPos(dictStr, capsule.endIndex + 1);
            if (valPos == null || valPos == -1) {
              return dict;
            } else {
              for (int j = valPos; j < dictStr.length; j++) {
                String char = dictStr[j];
                if (!char.contains(whitespace)) {
                  _SearchCapsule? capsule = _getNextData(dictStr, j);
                  if (capsule != null) {
                    dict[key] = capsule.obj;
                    int? nextPos =
                        _getNextElementPos(dictStr, capsule.endIndex + 1);
                    if (nextPos == null || nextPos == -1) {
                      return dict;
                    } else {
                      i = nextPos - 1;
                      break;
                    }
                  } else {
                    return dict;
                  }
                }
              }
            }
          } else {
            return dict;
          }
        }
      }
      return dict;
    }
    return null;
  }

  static List<Object>? _getList(String str, int startIndex) {
    String? listStr = _getListString(str, startIndex);
    if (listStr != null) {
      List<Object> list = [];
      for (int i = 0; i < listStr.length; i++) {
        String char = listStr[i];
        if (!char.contains(whitespace)) {
          _SearchCapsule? capsule = _getNextData(listStr, i);
          if (capsule != null) {
            list.add(capsule.obj);
            int? nextPos = _getNextElementPos(listStr, capsule.endIndex + 1);
            if (nextPos == null || nextPos == -1) {
              return list;
            } else {
              i = nextPos - 1;
            }
          } else {
            return list;
          }
        }
      }
      return list;
    }
    return null;
  }

  static _SearchCapsule? _getNextData(String str, int start) {
    for (int i = start; i < str.length; i++) {
      String char = str[i];
      if (!char.contains(whitespace)) {
        if (char == '{') {
          Map<Object, Object>? data = _getDictionary(str, i);
          return data != null
              ? _SearchCapsule(data, _getDictionaryEnd(str, i))
              : null;
        } else if (char == '[') {
          List<Object>? data = _getList(str, i);
          return data != null
              ? _SearchCapsule(data, _getListEnd(str, i))
              : null;
        } else if (char == '"') {
          String? data = _getString(str, i);
          return data != null
              ? _SearchCapsule(data, _getStringEnd(str, i))
              : null;
        }

        int j = i + 1;
        for (; j < str.length; j++) {
          String subChar = str[j];
          if (subChar == ',' ||
              subChar == '"' ||
              subChar == '[' ||
              subChar == ']' ||
              subChar == '{' ||
              subChar == '}' ||
              subChar == ':' ||
              subChar.contains(whitespace)) {
            break;
          }
        }

        String subStr = str.substring(i, j);
        Object? data = _parseObj(subStr);
        return data != null ? _SearchCapsule(data, j - 1) : null;
      }
    }
    return null;
  }

  static Object? _parseObj(String str) {
    if (int.tryParse(str) != null) {
      return int.parse(str);
    } else if (double.tryParse(str) != null) {
      return double.parse(str);
    } else if (str == 'true') {
      return true;
    } else if (str == 'false') {
      return false;
    }
    return null;
  }

  static int? _getNextElementPos(String str, int start) =>
      _getAfter(str, start, ',');

  static int? _getDictValPos(String str, int start) =>
      _getAfter(str, start, ':');

  static int? _getAfter(String str, int start, String signifier) {
    for (int i = start; i < str.length; i++) {
      if (str[i] == signifier) {
        for (int j = i + 1; j < str.length; j++) {
          if (!str[j].contains(whitespace)) {
            return str[j] == ',' || str[j] == ':' ? null : j;
          }
        }
        return null;
      } else if (!str[i].contains(whitespace)) {
        return null;
      }
    }
    return -1;
  }

  static String? _getDictionaryString(String str, int startIndex) =>
      _getContents(str, startIndex, _getDictionaryEnd(str, startIndex))?.trim();

  static String? _getListString(String str, int startIndex) =>
      _getContents(str, startIndex, _getListEnd(str, startIndex))?.trim();

  static String? _getString(String str, int startIndex) {
    String? returnStr = _getContents(str, startIndex, _getStringEnd(str, startIndex));
    return returnStr != null ? _removeEscapeCharacters(returnStr) : null;
  }

  static String? _getContents(String str, int startIndex, int endIndex) =>
      endIndex != -1
          ? endIndex > startIndex + 1
              ? str.substring(startIndex + 1, endIndex)
              : ''
          : null;

  static int _getDictionaryEnd(String str, int startIndex) =>
      _getDataStructureEnd(str, startIndex, '}');

  static int _getListEnd(String str, int startIndex) =>
      _getDataStructureEnd(str, startIndex, ']');

  static int _getDataStructureEnd(
    String str,
    int startIndex,
    String signifier,
  ) {
    for (int i = startIndex + 1; i < str.length; i++) {
      String char = str[i];
      if (char == signifier) {
        return i;
      } else {
        if (char == '{') {
          i = _getDictionaryEnd(str, i);
        } else if (char == '[') {
          i = _getListEnd(str, i);
        } else if (char == '"') {
          i = _getStringEnd(str, i);
        }
        if (i == -1) return -1;
      }
    }
    return -1;
  }

  static int _getStringEnd(String str, int startIndex) {
    for (int i = startIndex + 1; i < str.length; i++) {
      if (str[i] == '"' && _backslashCount(str.substring(0, i)) % 2 == 0) {
        return i;
      }
    }
    return -1;
  }
}

class _SearchCapsule {
  Object obj;
  int endIndex;

  _SearchCapsule(this.obj, this.endIndex);
}
