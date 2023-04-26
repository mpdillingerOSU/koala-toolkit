import 'package:flutter/material.dart';

enum MoveModifier {
  knockback._(
    1,
    'Knockback',
    Icons.circle_rounded,
    'The target is knocked back the given distance. The user may also specify:\n\n\t- whether the move causes the target to become airborne, and\n\t- whether the target is knocked back relative to the origin of where the move landed or the direction from where the move came.'
  ),
  lunge._(
    2,
    'Lunge',
    Icons.circle_rounded,
    'The user lunges forward the given distance. The user may also specify:\n\n\t- whether the move causes the target to become airborne.'
  ),
  los._(
    3,
    'Line of Sight',
    Icons.circle_rounded,
    'Most moves need a clear line of sight between the user and the target, with no obstructions. However, some moves may ignore line of sight, and pass through any obstacles.',
  ),
  rangeBoostable._(
    4,
    'Range Boostable',
    Icons.circle_rounded,
    'Most moves can have their range boosted. However, in cases such as close combat with punches and swords, it would be more logical to have them not be range boostable.'
  ),
  directContact._(
    5,
    'Direct Contact',
    Icons.circle_rounded,
    'The move will make direct contact between the user and the target - such as when the user\'s own body comes into contact with the target.'
  ),
  utility._(
    6,
    'Utility',
    Icons.circle_rounded,
    'The move will have a special utility, which usually come with perks - such as piercing through an ignoring armor, or having increased damage when bludgeoning soldiers made of stone.'
  ),
  compoundingPower._(
    7,
    'Compounding Power',
    Icons.circle_rounded,
    'The move will have increased damage through repeated use.'
  ),
  deprecatingPower._(
    8,
    'Deprecating Power',
    Icons.circle_rounded,
    'The move will have lowered damage with each repeated use.'
  ),
  multiHit._(
    9,
    'Multi-Hit',
    Icons.circle_rounded,
    'Each single use of the move will strike the opponent the given number of times.'
  ),
  pull._(
    10,
    'Pull',
    Icons.circle_rounded,
    'The target is pulled towards the target by the given distance. The user may also specify:\n\n\t- whether the move causes the target to become airborne, \n\t- whether the pull occurs pre-strike (before damage and/or battle effects) or post-strike (after damage and/or battle effects), and\n\t- whether the target is knocked back relative to the origin of where the move landed or the direction from where the move came.'
  ),
  battleEffect._(
    11,
    'Battle Effect',
    Icons.circle_rounded,
    'The target will become afflicted by the given special effect.'
  ),
  bounceback._(
    12,
    'Bounceback',
    Icons.circle_rounded,
    'The user will be bounced back by the given distance. The user may also specify:\n\n\t- whether the move causes the target to become airborne, and\n\t- whether the pull occurs pre-strike (before damage and/or battle effects) or post-strike (after damage and/or battle effects).'
  ),
  recoil._(
    13,
    'Recoil',
    Icons.circle_rounded,
    'At the end of the move, the user will be hurt by the given power factor.'
  ),
  cooldown._(
    14,
    'Cooldown',
    Icons.circle_rounded,
    'Upon using the move, the user must wait the given amount of time, before being able to use the move again.'
  ),
  sideEffect._(
    15,
    'Side Effect',
    Icons.circle_rounded,
    'At the end of the move, the user will become afflicted by the given special effect.'
  ),
  crashDamage._(
    16,
    'Crash Damage',
    Icons.circle_rounded,
    'If the move misses, the user will be hurt by the given power factor.'
  );

  static final Map<String, IconData> _map = _generateMap();
  static final Map<String, MoveModifier> _nameMap = _generateNameMap();

  final int ordinal;
  final String name;
  final IconData icon;
  final String description;

  const MoveModifier._(
    this.ordinal,
    this.name,
    this.icon,
    this.description,
  );

  static Map<String, IconData> _generateMap() {
    Map<String, IconData> returnMap = {};
    for (MoveModifier moveModifier in MoveModifier.values) {
      returnMap[moveModifier.name] = moveModifier.icon;
    }
    return returnMap;
  }

  static Map<String, MoveModifier> _generateNameMap() {
    Map<String, MoveModifier> returnMap = {};
    for (MoveModifier moveModifier in MoveModifier.values) {
      returnMap[moveModifier.name] = moveModifier;
    }
    return returnMap;
  }

  static Map<String, IconData> get map {
    return {..._map};
  }

  static List<String> allNames() {
    List<String> names = [];
    for (MoveModifier moveModifier in values) {
      names.add(moveModifier.name);
    }
    return names;
  }

  static int? ordinalOf(String name) {
    return _nameMap[name]?.ordinal;
  }

  @override
  String toString() {
    return name;
  }
}
