import 'package:flutter/material.dart';

enum Utility {
  piercing._(
    'Piercing',
    Icons.circle,
    1,
  ),
  slashing._(
    'Slashing',
    Icons.circle,
    2,
  ),
  highImpact._(
    'High Impact',
    Icons.circle,
    3,
  ),
  bludgeoning._(
    'Bludgeoning',
    Icons.circle,
    4,
  ),
  constriction._(
    'Constriction',
    Icons.circle,
    5,
  ),
  crushing._(
    'Crushing',
    Icons.circle,
    6,
  );

  static final Map<String, IconData> _map = _generateMap();
  static final Map<String, Utility> _nameMap = _generateNameMap();

  final String name;
  final IconData icon;
  final int ordinal;

  const Utility._(this.name, this.icon, this.ordinal);

  static Map<String, IconData> _generateMap() {
    Map<String, IconData> returnMap = {};
    for (Utility utility in Utility.values) {
      returnMap[utility.name] = utility.icon;
    }
    return returnMap;
  }

  static Map<String, Utility> _generateNameMap(){
    Map<String, Utility> returnMap = {};
    for(Utility utility in Utility.values){
      returnMap[utility.name] = utility;
    }
    return returnMap;
  }

  static Map<String, IconData> get map {
    return {..._map};
  }

  static List<String> allNames() {
    List<String> names = [];
    for (Utility utility in values) {
      names.add(utility.name);
    }
    return names;
  }

  static int? ordinalOf(String name){
    return _nameMap[name]?.ordinal;
  }

  @override
  String toString() {
    return name;
  }
}
