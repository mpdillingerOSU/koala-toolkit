import 'package:flutter/material.dart';

import 'move_icons.dart';

enum MoveElement {
  neutral._(
    'Neutral',
    Icons.circle_rounded,
    1,
  ),
  fire._(
    'Fire',
    MoveIcons.fire,
    2,
  ),
  earth._(
    'Earth',
    Icons.terrain_rounded,
    3,
  ),
  water._(
    'Water',
    Icons.water_drop_rounded,
    4,
  ),
  wind._(
    'Wind',
    Icons.air_rounded,
    5,
  ),
  flora._(
    'Flora',
    MoveIcons.flora,
    6,
  ),
  electric._(
    'Electric',
    Icons.electric_bolt_rounded,
    7,
  ),
  ice._(
    'Ice',
    MoveIcons.ice,
    8,
  ),
  steel._(
    'Steel',
    MoveIcons.steel,
    9,
  );

  static final Map<String, IconData> _map = _generateMap();
  static final Map<String, MoveElement> _nameMap = _generateNameMap();

  final String name;
  final IconData icon;
  final int ordinal;

  const MoveElement._(this.name, this.icon, this.ordinal);

  static Map<String, IconData> _generateMap(){
    Map<String, IconData> returnMap = {};
    for(MoveElement element in MoveElement.values){
      returnMap[element.name] = element.icon;
    }
    return returnMap;
  }

  static Map<String, MoveElement> _generateNameMap(){
    Map<String, MoveElement> returnMap = {};
    for(MoveElement element in MoveElement.values){
      returnMap[element.name] = element;
    }
    return returnMap;
  }

  static Map<String, IconData> get map {
    return {..._map};
  }

  static List<String> allNames(){
    List<String> names = [];
    for(MoveElement element in values){
      names.add(element.name);
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
