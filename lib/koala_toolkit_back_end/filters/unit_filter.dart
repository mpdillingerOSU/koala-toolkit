import 'package:gaming_toolkit/koala_strings.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/filters/unit_field_filter.dart';

import '../data/units/unit.dart';
import '../data/unit_field.dart';
import '../data/unit_palette.dart';

class UnitFilter {
  String searchTerm = '';
  final Map<String, UnitFieldFilter> _filters = {};

  UnitFilter(UnitPalette palette){
    for(UnitField field in palette.fields){
      if(field is UnitFieldInt){
        _filters[field.name] = UnitFieldIntFilter(field.name, field.minVal, field.maxVal);
      } else if (field is UnitFieldBool){
        _filters[field.name] = UnitFieldBoolFilter(field.name);
      } else if (field is UnitFieldString){
        _filters[field.name] = UnitFieldStringFilter(field.name);
      } else if (field is UnitFieldEnum){
        _filters[field.name] = UnitFieldEnumFilter(field.name, field.vals);
      }
    }
  }

  List<String> allApplied(){
    List<String> returnList = [];
    for(UnitFieldFilter filter in _filters.values){
      if(filter.isApplied){
        returnList.add(filter.name);
      }
    }
    return returnList;
  }

  UnitFieldFilter? get(String fieldName){
    return _filters[fieldName];
  }

  List<UnitFieldFilter> getAll() => _filters.values.toList();

  List<Unit> apply(List<Unit> units) {
    List<Unit> filteredUnits = [];

    for (Unit unit in units) {
      if(!hasSubsequence(asLowercaseAlphanumeric(unit.name), asLowercaseAlphanumeric(searchTerm))){
        continue;
      }

      bool addUnit = true;
      for(String key in _filters.keys.toList()){
        if(!(_filters[key]?.check(unit) ?? false)){
          addUnit = false;
          break;
        }
      }

      if(addUnit) {
        filteredUnits.add(unit);
      }
    }

    return filteredUnits;
  }

  void clearAll() {
    for(String key in _filters.keys.toList()){
      _filters[key]?.clear();
    }
  }

  void setEqualTo(UnitFilter other) {
    searchTerm = other.searchTerm;
    _filters.clear();
    for(String key in other._filters.keys.toList()){
      _filters[key] = other._filters[key]!.copy();
    }
  }

  bool equals(UnitFilter comp) {
    if(searchTerm != comp.searchTerm || _filters.keys.length != comp._filters.keys.length) return false;

    for(String key in _filters.keys.toList()){
      UnitFieldFilter? filter = _filters[key];
      UnitFieldFilter? compFilter = comp._filters[key];
      if(filter == null || compFilter == null || !filter.equals(compFilter)){
        return false;
      }
    }
    return true;
  }
}
