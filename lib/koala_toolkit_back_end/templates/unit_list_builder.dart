import '../data/units/unit.dart';

class UnitListBuilder {
  final String name;
  final List<Unit> _units = [];

  UnitListBuilder(this.name, List<Unit> units){
    for(int i = 0; i < units.length; i++){
      _units.add(units[i].copyWith(unitNum: i + 1));
    }
  }

  List<Unit> get units => [..._units];
}