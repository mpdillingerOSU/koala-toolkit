import 'package:gaming_toolkit/koala_toolkit_back_end/templates/template.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/unit_list_builder.dart';

import '../battle_effect.dart';
import '../data/moves/move.dart';
import '../data/unit_field.dart';
import '../data/unit_palette.dart';
import '../move_element.dart';
import '../move_type.dart';
import 'move_list_builder.dart';

class HorrorTemplate extends Template {
  HorrorTemplate() : super('Horror');

  //TODO: One user characteristic is 'Sanity'...

  final Move _axe = Move(
    name: 'Axe',
    description: 'A heavily worn axe - chipped, yet freshly sharpened.',
    moveNum: 1,
    element: MoveElement.steel.toString(),
    moveType: MoveType.physical.toString(),
    energyCost: 10,
    hasPower: true,
    powerMin: 25,
    powerMax: 35,
    rangeMin: 0,
    rangeMax: 1,
    accuracy: 100,
    hasKnockback: false,
    hasLunge: false,
    hasLOSModifier: false,
    hasRangeBoostableModifier: false,
    hasDirectContactModifier: false,
    hasUtility: false,
    hasCompoundingPowerModifier: false,
    hasDeprecatingPowerModifier: false,
    hasMultiHit: false,
    hasPull: false,
    hasBattleEffect: false,
    hasBounceback: false,
    hasRecoil: false,
    hasCooldown: false,
    hasSideEffect: false,
    hasCrashDamage: false,
  );
  final Move _machete = Move(
    name: 'Machete',
    description: 'Unless you have a pretense for certain pleasures, its pretty useless for those not in the jungle.',
    moveNum: 2,
    element: MoveElement.steel.toString(),
    moveType: MoveType.physical.toString(),
    energyCost: 10,
    hasPower: true,
    powerMin: 25,
    powerMax: 35,
    rangeMin: 0,
    rangeMax: 1,
    accuracy: 100,
    hasKnockback: false,
    hasLunge: false,
    hasLOSModifier: false,
    hasRangeBoostableModifier: false,
    hasDirectContactModifier: false,
    hasUtility: false,
    hasCompoundingPowerModifier: false,
    hasDeprecatingPowerModifier: false,
    hasMultiHit: false,
    hasPull: false,
    hasBattleEffect: false,
    hasBounceback: false,
    hasRecoil: false,
    hasCooldown: false,
    hasSideEffect: false,
    hasCrashDamage: false,
  );

  final Move _pistol = Move(
    name: 'Pistol',
    description: 'Simple to use, simple to understand.',
    moveNum: 1,
    element: MoveElement.steel.toString(),
    moveType: MoveType.physical.toString(),
    energyCost: 10,
    hasPower: true,
    powerMin: 25,
    powerMax: 35,
    rangeMin: 0,
    rangeMax: 5,
    accuracy: 100,
    hasKnockback: false,
    hasLunge: false,
    hasLOSModifier: false,
    hasRangeBoostableModifier: false,
    hasDirectContactModifier: false,
    hasUtility: false,
    hasCompoundingPowerModifier: false,
    hasDeprecatingPowerModifier: false,
    hasMultiHit: false,
    hasPull: false,
    hasBattleEffect: false,
    hasBounceback: false,
    hasRecoil: false,
    hasCooldown: false,
    hasSideEffect: false,
    hasCrashDamage: false,
  );

  final Move _hellfire = Move(
    name: 'Hellfire',
    description: 'Licking flames so hot that they burn the skin, yet so cold that they shatter the soul.',
    moveNum: 1,
    element: MoveElement.fire.toString(),
    moveType: MoveType.ethereal.toString(),
    energyCost: 10,
    hasPower: true,
    powerMin: 25,
    powerMax: 35,
    rangeMin: 0,
    rangeMax: 5,
    accuracy: 100,
    hasKnockback: false,
    hasLunge: false,
    hasLOSModifier: false,
    hasRangeBoostableModifier: false,
    hasDirectContactModifier: false,
    hasUtility: false,
    hasCompoundingPowerModifier: false,
    hasDeprecatingPowerModifier: false,
    hasMultiHit: false,
    hasPull: false,
    hasBattleEffect: true,
    battleEffectType: BattleEffect.burn.toString(),
    hasBounceback: false,
    hasRecoil: false,
    hasCooldown: false,
    hasSideEffect: false,
    hasCrashDamage: false,
  );

  final UnitFieldInt _vitality = UnitFieldInt(
    name: 'Vitality',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _strength = UnitFieldInt(
    name: 'Strength',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _intelligence = UnitFieldInt(
    name: 'Intelligence',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _wisdom = UnitFieldInt(
    name: 'Wisdom',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _agility = UnitFieldInt(
    name: 'Agility',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _luck = UnitFieldInt(
    name: 'Luck',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldBool _flying = UnitFieldBool(
    name: 'Flying',
    defaultVal: false,
  );
  final UnitFieldEnum _element = UnitFieldEnum(
    name: 'Element',
    vals: MoveElement.map.keys.toList(),
  );

  @override
  UnitPalette generateUnitPalette() {
    return UnitPalette(
      fields: [
        _vitality,
        _strength,
        _intelligence,
        _wisdom,
        _agility,
        _luck,
        _flying,
        _element,
      ],
    );
  }

  @override
  List<MoveListBuilder> generateMoves() {
    return [
      MoveListBuilder(
        'Close Combat',
        [
          _axe,
          _machete,
        ],
      ),
      MoveListBuilder(
        'Guns',
        [
          _pistol,
        ],
      ),
      MoveListBuilder(
        'Supernatural',
        [
          _hellfire,
        ],
      ),
    ];
  }

  @override
  List<UnitListBuilder> generateUnits() {
    return [];
  }
}
