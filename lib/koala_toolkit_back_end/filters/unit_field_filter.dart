import '../../components/range.dart';
import '../data/units/unit.dart';
import '../data/unit_field.dart';

abstract class UnitFieldFilter {
  final String name;
  bool _isApplied = false;
  //bool _has = false;

  UnitFieldFilter(this.name);

  bool get isApplied => _isApplied;
  //bool get has => _has;

  /*
  set has(bool val) {
    _has = val;
    if (!_has) {
      subClear();
    }
  }

   */

  void apply() {
    if(!isApplied){
      _isApplied = true;
      subApply();
    }
  }

  void clear() {
    if(isApplied){
      _isApplied = false;
      //_has = false;
      subClear();
    }
  }

  void subApply();
  void subClear();
  UnitFieldFilter copy();
  bool equals(UnitFieldFilter comp);
  bool check(Unit unit);
}

class UnitFieldIntFilter extends UnitFieldFilter {
  int minVal;
  int maxVal;
  Range valRange = Range.unbounded;

  UnitFieldIntFilter(super.name, this.minVal, this.maxVal);

  @override
  void subApply() {}

  @override
  void subClear() {
    valRange = Range.unbounded;
  }

  @override
  UnitFieldFilter copy() {
    UnitFieldIntFilter returnFilter = UnitFieldIntFilter(name, minVal, maxVal);
    returnFilter._isApplied = _isApplied;
    //returnFilter._has = _has;
    returnFilter.valRange = Range(valRange.lowerBound, valRange.upperBound);
    return returnFilter;
  }

  @override
  bool equals(UnitFieldFilter comp) {
    return comp is UnitFieldIntFilter &&
        name == comp.name &&
        _isApplied == comp._isApplied &&
        //_has == comp._has &&
        minVal == comp.minVal &&
        maxVal == comp.maxVal &&
        valRange.equals(comp.valRange);
  }

  @override
  bool check(Unit unit) {
    if (!_isApplied) return true;

    UnitFieldData? data = unit.getByName(name);
    return data != null &&
        //TODO: 'has' check for dynamic fields, such as move modifiers
        data.field is UnitFieldInt &&
        valRange.contains(data.val);
  }
}

class UnitFieldBoolFilter extends UnitFieldFilter {
  bool val = false;

  UnitFieldBoolFilter(super.name);

  @override
  void subApply() {
    val = false;
  }

  @override
  void subClear() {
    val = false;
  }

  @override
  UnitFieldFilter copy() {
    UnitFieldBoolFilter returnFilter = UnitFieldBoolFilter(name);
    returnFilter._isApplied = _isApplied;
    //returnFilter._has = _has;
    returnFilter.val = val;
    return returnFilter;
  }

  @override
  bool equals(UnitFieldFilter comp) {
    return comp is UnitFieldBoolFilter &&
        name == comp.name &&
        _isApplied == comp._isApplied &&
        //_has == comp._has;
        val == comp.val;
  }

  @override
  bool check(Unit unit) {
    if (!_isApplied) return true;

    UnitFieldData? data = unit.getByName(name);
    //TODO: 'has' check for dynamic fields, such as move modifiers
    return data != null && data.field is UnitFieldBool && val == data.val;
  }
}

class UnitFieldStringFilter extends UnitFieldFilter {
  String? val;

  UnitFieldStringFilter(super.name);

  @override
  void subApply() {}

  @override
  void subClear() {
    val = null;
  }

  @override
  UnitFieldFilter copy() {
    UnitFieldStringFilter returnFilter = UnitFieldStringFilter(name);
    returnFilter._isApplied = _isApplied;
    //returnFilter._has = _has;
    returnFilter.val = val;
    return returnFilter;
  }

  @override
  bool equals(UnitFieldFilter comp) {
    return comp is UnitFieldStringFilter &&
        name == comp.name &&
        _isApplied == comp._isApplied &&
        //_has == comp._has &&
        val == comp.val;
  }

  @override
  bool check(Unit unit) {
    if (!_isApplied) return true;

    UnitFieldData? data = unit.getByName(name);
    //TODO: 'has' check for dynamic fields, such as move modifiers
    return data != null && data.field is UnitFieldString && val == data.val;
  }
}

class UnitFieldEnumFilter extends UnitFieldFilter {
  late final List<String> _values;
  final List<String> _filters = [];

  UnitFieldEnumFilter(super.name, List<String> values) {
    _values = [...values];
    _filters.addAll(_values);
  }

  List<String> get values => [..._values];
  List<String> get filters => [..._filters];

  void addFilter(String filter) {
    if (_values.contains(filter) && !_filters.contains(filter)) {
      _filters.add(filter);
    }
  }

  void removeFilter(String filter) {
    _filters.remove(filter);
  }

  void applyAllFilters() {
    _filters.clear();
    _filters.addAll(_values);
  }

  void clearAllFilters() {
    _filters.clear();
  }

  @override
  void subApply() {
    applyAllFilters();
  }

  @override
  void subClear() {
    clearAllFilters();
  }

  @override
  UnitFieldFilter copy() {
    UnitFieldEnumFilter returnFilter = UnitFieldEnumFilter(name, [..._values]);
    returnFilter._isApplied = _isApplied;
    //returnFilter._has = _has;
    returnFilter._filters.clear();
    returnFilter._filters.addAll(_filters);
    return returnFilter;
  }

  @override
  bool equals(UnitFieldFilter comp) {
    if (comp is! UnitFieldEnumFilter ||
        name != comp.name ||
        _isApplied != comp._isApplied ||
        //_has != comp._has ||
        _values.length != comp._values.length ||
        _filters.length != comp._filters.length) {
      return false;
    }

    for (String value in _values) {
      if (!comp._values.contains(value)) {
        return false;
      }
    }

    for (String filter in _filters) {
      if (!comp._filters.contains(filter)) {
        return false;
      }
    }

    return true;
  }

  @override
  bool check(Unit unit) {
    if (!_isApplied) return true;

    UnitFieldData? data = unit.getByName(name);
    return data != null &&
        //TODO: 'has' check for dynamic fields, such as move modifiers
        data.field is UnitFieldEnum &&
        _filters.contains(data.val);
  }
}
