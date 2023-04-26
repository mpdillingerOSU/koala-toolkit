import '../data/moves/move.dart';
import '../data/moves/move_list.dart';
import '../data/moves/moveset.dart';
import '../data/project.dart';
import '../data/unit_field.dart';
import '../data/unit_palette.dart';
import '../data/units/unit.dart';
import '../data/units/unit_list.dart';

class DatabaseWriter {
  DatabaseWriter._();

  static Map<String, Object?> fromProject(Project project) {
    Map<String, Object?> returnMap = project.map;
    returnMap[ProjectFields.id] = Project.staticID;
    return returnMap;
  }

  static Map<String, Object?> fromMove(Move move) {
    return {
      MoveFields.id: move.id,
      MoveFields.name: move.name,
      MoveFields.description: move.description,
      MoveFields.moveNum: move.moveNum,
      MoveFields.element: move.element,
      MoveFields.moveType: move.moveType,
      MoveFields.energyCost: move.energyCost,
      MoveFields.hasPower: move.hasPower ? 1 : 0,
      MoveFields.powerMin: move.powerMin,
      MoveFields.powerMax: move.powerMax,
      MoveFields.rangeMin: move.rangeMin,
      MoveFields.rangeMax: move.rangeMax,
      MoveFields.accuracy: move.accuracy,
      MoveFields.hasKnockback: move.hasKnockback ? 1 : 0,
      MoveFields.knockbackValue: move.knockbackValue,
      MoveFields.isKnockbackAirborne: move.isKnockbackAirborne ? 1 : 0,
      MoveFields.knockbackType: move.knockbackType,
      MoveFields.hasLunge: move.hasLunge ? 1 : 0,
      MoveFields.lungeValue: move.lungeValue,
      MoveFields.isLungeAirborne: move.isLungeAirborne ? 1 : 0,
      MoveFields.hasLOSModifier: move.hasLOSModifier ? 1 : 0,
      MoveFields.hasLOS: move.hasLOS ? 1 : 0,
      MoveFields.hasRangeBoostableModifier:
          move.hasRangeBoostableModifier ? 1 : 0,
      MoveFields.isRangeBoostable: move.isRangeBoostable ? 1 : 0,
      MoveFields.hasDirectContactModifier:
          move.hasDirectContactModifier ? 1 : 0,
      MoveFields.hasDirectContact: move.hasDirectContact ? 1 : 0,
      MoveFields.hasUtility: move.hasUtility ? 1 : 0,
      MoveFields.utilityType: move.utilityType,
      MoveFields.hasCompoundingPowerModifier:
          move.hasCompoundingPowerModifier ? 1 : 0,
      MoveFields.hasCompoundingPower: move.hasCompoundingPower ? 1 : 0,
      MoveFields.hasDeprecatingPowerModifier:
          move.hasDeprecatingPowerModifier ? 1 : 0,
      MoveFields.hasDeprecatingPower: move.hasDeprecatingPower ? 1 : 0,
      MoveFields.hasMultiHit: move.hasMultiHit ? 1 : 0,
      MoveFields.multiHitValue: move.multiHitValue,
      MoveFields.hasPull: move.hasPull ? 1 : 0,
      MoveFields.pullValue: move.pullValue,
      MoveFields.isPullAirborne: move.isPullAirborne ? 1 : 0,
      MoveFields.pullPriority: move.pullPriority,
      MoveFields.pullType: move.pullType,
      MoveFields.hasBattleEffect: move.hasBattleEffect ? 1 : 0,
      MoveFields.battleEffectType: move.battleEffectType,
      MoveFields.hasBounceback: move.hasBounceback ? 1 : 0,
      MoveFields.bouncebackValue: move.bouncebackValue,
      MoveFields.isBouncebackAirborne: move.isBouncebackAirborne ? 1 : 0,
      MoveFields.bouncebackPriority: move.bouncebackPriority,
      MoveFields.hasRecoil: move.hasRecoil ? 1 : 0,
      MoveFields.recoilMin: move.recoilMin,
      MoveFields.recoilMax: move.recoilMax,
      MoveFields.hasCooldown: move.hasCooldown ? 1 : 0,
      MoveFields.cooldownValue: move.cooldownValue,
      MoveFields.hasSideEffect: move.hasSideEffect ? 1 : 0,
      MoveFields.sideEffectType: move.sideEffectType,
      MoveFields.hasCrashDamage: move.hasCrashDamage ? 1 : 0,
      MoveFields.crashDamageMin: move.crashDamageMin,
      MoveFields.crashDamageMax: move.crashDamageMax,
    };
  }

  static Map<String, Object?> fromMoveList(MoveList list) => list.map;

  static String fromUnitField(UnitField field) {
    if (field is UnitFieldInt) {
      return '{"name": "${_withEscapeCharacters(field.name)}", "type": "${_withEscapeCharacters(field.type)}", "defaultVal": ${field.defaultVal}, "minVal": ${field.minVal}, "maxVal": ${field.maxVal}}';
    } else if (field is UnitFieldBool) {
      return '{"name": "${_withEscapeCharacters(field.name)}", "type": "${_withEscapeCharacters(field.type)}", "defaultVal": ${field.defaultVal}}';
    } else if (field is UnitFieldString) {
      return '{"name": "${_withEscapeCharacters(field.name)}", "type": "${_withEscapeCharacters(field.type)}", "defaultVal": "${_withEscapeCharacters(field.defaultVal)}"}';
    } else if (field is UnitFieldEnum) {
      List<String> vals = field.vals;
      String strOfVals = '[';
      if (vals.isNotEmpty) {
        strOfVals += '"${_withEscapeCharacters(vals[0])}"';
        for (int i = 1; i < vals.length; i++) {
          strOfVals += ', "${_withEscapeCharacters(vals[i])}"';
        }
      }
      strOfVals += ']';
      return '{"name": "${_withEscapeCharacters(field.name)}", "type": "${_withEscapeCharacters(field.type)}", "vals": $strOfVals}';
    } else {
      return '{}';
    }
  }

  static Map<String, Object?> fromUnitPalette(UnitPalette palette) {
    List<UnitField> fields = palette.fields;
    String fieldsStr = '[';
    if (fields.isNotEmpty) {
      fieldsStr += DatabaseWriter.fromUnitField(fields.first);
      for (int i = 1; i < fields.length; i++) {
        fieldsStr += ', ${DatabaseWriter.fromUnitField(fields[i])}';
      }
    }
    fieldsStr += ']';

    return {
      UnitPaletteFields.id: UnitPalette.staticID,
      UnitPaletteFields.fields: fieldsStr,
    };
  }

  static String fromUnitFieldData(UnitFieldData data) {
    String val = data.val is String ? '"${_withEscapeCharacters(data.val)}"' : '${data.val}';
    return '["${_withEscapeCharacters(data.field.toString())}", $val]';
  }

  static Map<String, Object?> fromUnit(Unit unit) {
    List<UnitFieldData> fields = unit.fields;
    String fieldsStr = '[';
    if (fields.isNotEmpty) {
      fieldsStr += DatabaseWriter.fromUnitFieldData(fields[0]);
      for (int i = 1; i < fields.length; i++) {
        fieldsStr += ', ${DatabaseWriter.fromUnitFieldData(fields[i])}';
      }
    }
    fieldsStr += ']';

    return {
      UnitFields.id: unit.id,
      UnitFields.name: unit.name,
      UnitFields.description: unit.description,
      UnitFields.unitNum: unit.unitNum,
      UnitFields.moveset: _movesetToString(unit.moveset),
      UnitFields.fields: fieldsStr,
    };
  }

  static String _movesetToString(Moveset moveset) {
    String str = '{';
    List<MoveGroup> groups = moveset.groups;
    //keys.sort((a, b) {
    //  return a.toLowerCase().compareTo(b.toLowerCase());
    //});
    if (groups.isNotEmpty) {
      str += _moveGroupToString(groups[0]);
      for (int i = 1; i < groups.length; i++) {
        str += ', ${_moveGroupToString(groups[i])}';
      }
    }
    return '$str}';
  }

  static String _moveGroupToString(MoveGroup group) {
    String str = '"${_withEscapeCharacters(group.name)}": [';
    List<MoveGroupPair> pairs = group.pairs;
    if (pairs.isNotEmpty) {
      str += _moveGroupPairToString(pairs.first);
      for (int i = 1; i < pairs.length; i++) {
        str += ', ${_moveGroupPairToString(pairs[i])}';
      }
    }
    return '$str]';
  }

  static String _moveGroupPairToString(MoveGroupPair pair) {
    return '["${_withEscapeCharacters(pair.move.toString())}", "${_withEscapeCharacters(pair.moveList.toString())}"]';
  }

  static Map<String, Object?> fromUnitList(UnitList list) => list.map;

  static String _withEscapeCharacters(String val) {
    String str = '';
    for (int i = 0; i < val.length; i++) {
      String char = val[i];
      str += '${(char == '\'' || char == '"' || char == '\\') ? '\\' : ''}$char';
    }
    return str;
  }
}
