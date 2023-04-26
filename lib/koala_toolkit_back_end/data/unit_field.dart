import 'dart:math';

import '../../koala_strings.dart';

class UnitFieldTypes {
  UnitFieldTypes._();

  static const String intType = 'int';
  static const String boolType = 'bool';
  static const String stringType = 'string';
  static const String enumType = 'enum';
}

class UnitFieldData<T> {
  final UnitField<T> field;
  final T val;

  UnitFieldData(
    this.field,
    this.val,
  );

  bool equals(UnitFieldData<T> comp) {
    return field.equals(comp.field) && val == comp.val;
  }

  bool compareTo(UnitFieldData<T> comp) {
    if (field is UnitFieldInt) {
      return comp.field is UnitFieldInt && (val as int) <= (comp.val as int);
    } else if (field is UnitFieldBool) {
      return comp.field is UnitFieldBool &&
          ((val as bool) ? 1 : 0) <= ((comp.val as bool) ? 1 : 0);
    } else if (field is UnitFieldString) {
      return comp.field is UnitFieldString &&
          asLowercaseAlphanumeric(val as String)
                  .compareTo(asLowercaseAlphanumeric(comp.val as String)) <=
              0;
    } else if (field is UnitFieldEnum) {
      if (comp.field is UnitFieldEnum) {
        int compVal =
            (field as UnitFieldEnum)._vals.indexOf((comp.val as String));
        return compVal != -1 ||
            (field as UnitFieldEnum)._vals.indexOf((val as String)) <= compVal;
      }
      return false;
    }
    return false;
  }

  UnitFieldData<T> copy() {
    return UnitFieldData(field, val);
  }

  @override
  String toString(){
    return '[${field.name}, $val]';
  }
}

enum JsonDecoderStage {
  keyStart,
  valStart;
}

abstract class UnitField<T> {
  final String name;
  late final String identifier;
  final String type;
  final T defaultVal;

  bool equals(UnitField comp);

  UnitField._({
    required this.name,
    required this.type,
    required this.defaultVal,
  }) {
    identifier = toCamelCase(name);
  }

  @override
  String toString() {
    return name;
  }
}

class UnitFieldInt extends UnitField<int> {
  final int minVal;
  final int maxVal;

  UnitFieldInt({
    required String name,
    required int defaultVal,
    required this.minVal,
    required this.maxVal,
  }) : super._(
          name: name,
          type: UnitFieldTypes.intType,
          defaultVal: max(minVal, min(defaultVal, maxVal)),
        );

  @override
  bool equals(UnitField comp) =>
      comp is UnitFieldInt &&
      name == comp.name &&
      defaultVal == comp.defaultVal &&
      minVal == comp.minVal &&
      maxVal == comp.maxVal;
}

class UnitFieldBool extends UnitField<bool> {
  UnitFieldBool({
    required String name,
    required bool defaultVal,
  }) : super._(
          name: name,
          type: UnitFieldTypes.boolType,
          defaultVal: defaultVal,
        );

  @override
  bool equals(UnitField comp) {
    return comp is UnitFieldBool &&
        name == comp.name &&
        defaultVal == comp.defaultVal;
  }
}

class UnitFieldString extends UnitField<String> {
  UnitFieldString({
    required String name,
    required String defaultVal,
  }) : super._(
          name: name,
          type: UnitFieldTypes.stringType,
          defaultVal: defaultVal,
        );

  @override
  bool equals(UnitField comp) {
    return comp is UnitFieldString &&
        name == comp.name &&
        defaultVal == comp.defaultVal;
  }
}

class UnitFieldEnum extends UnitField<String> {
  late final List<String> _vals;

  UnitFieldEnum({
    required String name,
    required List<String> vals,
  }) : super._(
          name: name,
          type: UnitFieldTypes.enumType,
          defaultVal: vals.isNotEmpty ? vals[0] : '-',
        ) {
    _vals = vals.isNotEmpty ? [...vals] : ['-'];
  }

  List<String> get vals => [..._vals];

  @override
  bool equals(UnitField comp) {
    return comp is UnitFieldEnum &&
        name == comp.name &&
        defaultVal == comp.defaultVal;
  }
}
