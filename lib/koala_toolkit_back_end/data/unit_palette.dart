import 'package:gaming_toolkit/koala_toolkit_back_end/data/unit_field.dart';

const String tableUnitPalettes = 'unitPalettes';

class UnitPaletteFields {
  static const String id = '_id';
  static const String fields = 'fields';
}

class UnitPalette {
  static const int staticID = 1;
  late final List<UnitField> _fields;

  UnitPalette({
    required List<UnitField> fields,
  }) {
    _fields = [...fields];
  }

  List<UnitField> get fields => [..._fields];

  UnitPalette copy() => UnitPalette(fields: _fields);

  bool equals(UnitPalette comp) {
    for (UnitField field in _fields) {
      bool hasEquality = false;
      for (UnitField compField in comp._fields) {
        if (field.equals(compField)) {
          hasEquality = true;
          break;
        }
      }
      if (!hasEquality) return false;
    }
    return true;
  }

  List<UnitFieldData> generateDefaults() {
    List<UnitFieldData> returnList = [];
    for (UnitField field in _fields) {
      returnList.add(UnitFieldData(field, field.defaultVal));
    }
    return returnList;
  }

  UnitField? get(String name){
    for(UnitField field in _fields) {
      if(field.name == name) return field;
    }
    return null;
  }
}
