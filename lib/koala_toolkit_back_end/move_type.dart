import 'package:flutter/material.dart';

import 'move_icons.dart';

enum MoveType {
  physical._(
    'Physical',
    MoveIcons.flash,
    1,
    true,
  ),
  ethereal._(
    'Ethereal',
    MoveIcons.ethereal_outlined,
    2,
    true,
  ),
  healing._(
    'Healing',
    MoveIcons.healing_alt,
    3,
    true,
  ),
  support._(
    'Support',
    MoveIcons.support,
    4,
    false,
  );

  static final Map<String, IconData> _map = _generateMap();
  static final Map<String, MoveType> _nameMap = _generateNameMap();

  final String name;
  final IconData icon;
  final int ordinal;
  final bool hasPower;

  const MoveType._(this.name, this.icon, this.ordinal, this.hasPower);

  static Map<String, IconData> _generateMap() {
    Map<String, IconData> returnMap = {};
    for (MoveType moveType in MoveType.values) {
      returnMap[moveType.name] = moveType.icon;
    }
    return returnMap;
  }

  static Map<String, MoveType> _generateNameMap(){
    Map<String, MoveType> returnMap = {};
    for(MoveType moveType in MoveType.values){
      returnMap[moveType.name] = moveType;
    }
    return returnMap;
  }

  static Map<String, IconData> get map {
    return {..._map};
  }

  static Map<String, MoveType> get nameMap {
    return {..._nameMap};
  }

  static List<String> allNames(){
    List<String> names = [];
    for(MoveType moveType in values){
      names.add(moveType.name);
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
