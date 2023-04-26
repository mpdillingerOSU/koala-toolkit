import 'package:gaming_toolkit/koala_toolkit_back_end/templates/move_list_builder.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/template.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/unit_list_builder.dart';

import '../battle_effect.dart';
import '../data/moves/move.dart';
import '../data/unit_field.dart';
import '../data/unit_palette.dart';
import '../move_element.dart';
import '../move_type.dart';

class SciFiTemplate extends Template {
  SciFiTemplate() : super('Sci-Fi');

  final Move _sonicPistol = Move(
    name: 'Sonic Pistol',
    description: 'Pew, pew! Pew, pew! Sonic means sound, right?',
    moveNum: 1,
    element: MoveElement.electric.toString(),
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
    hasBattleEffect: false,
    hasBounceback: false,
    hasRecoil: false,
    hasCooldown: false,
    hasSideEffect: false,
    hasCrashDamage: false,
  );

  final Move _plasmaRifle = Move(
    name: 'Plasma Rifle',
    description: 'This gun uses the fourth state of matter. You know, the one they don\'t teach in school.',
    moveNum: 2,
    element: MoveElement.electric.toString(),
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
    hasBattleEffect: false,
    hasBounceback: false,
    hasRecoil: false,
    hasCooldown: false,
    hasSideEffect: false,
    hasCrashDamage: false,
  );

  final Move _thermalDetonator = Move(
    name: 'Thermal Detonator',
    description: 'Like playing tennis? This ball\'s the same size, but it goes boom!',
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
        'Guns',
        [
          _sonicPistol,
          _plasmaRifle,
        ],
      ),
      MoveListBuilder(
        'Explosives',
        [
          _thermalDetonator,
        ],
      ),
    ];
  }

  @override
  List<UnitListBuilder> generateUnits() {
    return [];
  }
}
