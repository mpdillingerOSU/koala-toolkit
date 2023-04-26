import 'package:flutter/material.dart';

enum BattleEffect {
  burn._(
    'Burn',
    Icons.circle,
    1,
  ),
  drench._(
    'Drench',
    Icons.circle,
    2,
  ),
  blurryVision._(
    'Blurry Vision',
    Icons.circle,
    3,
  ),
  eagleEye._(
    'Eagle Eye',
    Icons.circle,
    4,
  ),
  paralysis._(
    'Paralysis',
    Icons.circle,
    5,
  ),
  fear._(
    'Fear',
    Icons.circle,
    6,
  ),
  frostbite._(
    'Frostbite',
    Icons.circle,
    7,
  ),
  rage._(
    'Rage',
    Icons.circle,
    8,
  ),
  sleep._(
    'Sleep',
    Icons.circle,
    9,
  ),
  purification._(
    'Purification',
    Icons.circle,
    10,
  ),
  hypnosis._(
    'Hypnosis',
    Icons.circle,
    11,
  ),
  petrification._(
    'Petrification',
    Icons.circle,
    12,
  ),
  confusion._(
    'Confusion',
    Icons.circle,
    13,
  ),
  grounding._(
    'Grounding',
    Icons.circle,
    14,
  ),
  shielding._(
    'Shielding',
    Icons.circle,
    15,
  ),
  protection._(
    'Protection',
    Icons.circle,
    16,
  );

  static final Map<String, IconData> _map = _generateMap();
  static final Map<String, BattleEffect> _nameMap = _generateNameMap();

  final String name;
  final IconData icon;
  final int ordinal;

  const BattleEffect._(this.name, this.icon, this.ordinal);

  static Map<String, IconData> _generateMap() {
    Map<String, IconData> returnMap = {};
    for (BattleEffect effect in BattleEffect.values) {
      returnMap[effect.name] = effect.icon;
    }
    return returnMap;
  }

  static Map<String, BattleEffect> _generateNameMap(){
    Map<String, BattleEffect> returnMap = {};
    for(BattleEffect effect in BattleEffect.values){
      returnMap[effect.name] = effect;
    }
    return returnMap;
  }

  static Map<String, IconData> get map {
    return {..._map};
  }

  static List<String> allNames() {
    List<String> names = [];
    for (BattleEffect effect in values) {
      names.add(effect.name);
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
