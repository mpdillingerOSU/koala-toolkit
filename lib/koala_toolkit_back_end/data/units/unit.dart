import 'package:gaming_toolkit/koala_toolkit_back_end/data/unit_field.dart';

import '../koala_data_type.dart';
import '../moves/moveset.dart';

const String tableUnits = 'units';

class UnitFields {
  UnitFields._();

  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String unitNum = 'unitNum';
  static const String moveset = 'movset';
  static const String fields = 'fields';

  static final List<String> values = [
    id,
    name,
    description,
    unitNum,
    moveset,
    fields,
  ];
}

class Unit extends KoalaDataType {
  static const int? defaultID = null;
  static const String defaultName = 'unnamed';
  static const String defaultDescription = '';
  static const int defaultUnitNum = 1;

  final int? id;
  final String name;
  final String description;
  final int unitNum;
  final Moveset moveset;
  final List<UnitFieldData> _fields = [];

  late final Map<String, Object?> _map;

  Unit({
    this.id,
    required this.name,
    required this.description,
    required this.unitNum,
    required this.moveset,
    required List<UnitFieldData> fields,
  }) {
    for (UnitFieldData field in fields) {
      _fields.add(field.copy());
    }

    _map = {
      UnitFields.id: id,
      UnitFields.name: name,
      UnitFields.description: description,
      UnitFields.unitNum: unitNum,
      UnitFields.moveset: moveset,
    };
    for (UnitFieldData field in _fields) {
      _map[field.field.identifier] = field.val;
    }
  }

  Map<String, Object?> get map => {..._map};

  List<UnitFieldData> get fields {
    List<UnitFieldData> returnList = [];
    for (UnitFieldData data in _fields) {
      returnList.add(data.copy());
    }
    return returnList;
  }

  Unit copyWith({
    int? id,
    bool nullifyID = false,
    int? unitNum,
    String? name,
    String? description,
    Moveset? moveset,
    List<UnitFieldData>? fields,
  }) {
    List<UnitFieldData> copiedFields = [];
    for(UnitFieldData data in fields ?? _fields){
      copiedFields.add(data.copy());
    }
    return Unit(
      id: nullifyID ? null : id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      unitNum: unitNum ?? this.unitNum,
      moveset: moveset?.copy() ?? this.moveset.copy(),
      fields: copiedFields,
    );
  }

  @override
  bool equals(KoalaDataType comp) {
    if (comp is! Unit ||
        name != comp.name ||
        description != comp.description ||
        !moveset.equals(comp.moveset) ||
        _fields.length != comp._fields.length) {
      return false;
    }

    for (UnitFieldData data in _fields) {
      bool hasEqual = false;
      for (UnitFieldData compData in comp._fields) {
        if (data.equals(compData)) {
          hasEqual = true;
          break;
        }
      }
      if (!hasEqual) return false;
    }
    return true;
  }

  bool has(UnitField field) {
    for (UnitFieldData data in _fields) {
      if (field.equals(data.field)) {
        return true;
      }
    }
    return false;
  }

  static UnitFieldString nameAsField() {
    return UnitFieldString(name: 'Unit Name', defaultVal: 'unnamed');
  }

  UnitFieldData<String> nameAsFieldData() {
    return UnitFieldData(nameAsField(), name);
  }

  static UnitFieldInt unitNumAsField() {
    return UnitFieldInt(
        name: 'Unit Number', defaultVal: 1, minVal: 1, maxVal: 1 << 31);
  }

  UnitFieldData<int> unitNumAsFieldData() {
    return UnitFieldData<int>(unitNumAsField(), unitNum);
  }

  UnitFieldData? get(UnitField field) {
    if (field.equals(nameAsField())) {
      return nameAsFieldData();
    } else if (field.equals(unitNumAsField())) {
      return unitNumAsFieldData();
    }
    for (UnitFieldData data in _fields) {
      if (field.equals(data.field)) {
        return data;
      }
    }
    return null;
  }

  UnitFieldData? getByName(String fieldName) {
    if (fieldName == nameAsField().name) {
      return nameAsFieldData();
    } else if (fieldName == unitNumAsField().name) {
      return unitNumAsFieldData();
    }
    for (UnitFieldData data in _fields) {
      if (fieldName == data.field.name) {
        return data;
      }
    }
    return null;
  }

  @override
  String toString() {
    return name;
  }
}
