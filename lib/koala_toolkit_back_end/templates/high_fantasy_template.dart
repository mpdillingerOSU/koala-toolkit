import 'package:gaming_toolkit/koala_toolkit_back_end/data/moves/moveset.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/move_list_builder.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/template.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/unit_list_builder.dart';

import '../battle_effect.dart';
import '../data/moves/move.dart';
import '../data/moves/move_list.dart';
import '../data/unit_field.dart';
import '../data/unit_palette.dart';
import '../data/units/unit.dart';
import '../move_element.dart';
import '../move_type.dart';

class HighFantasyTemplate extends Template {
  HighFantasyTemplate() : super('High Fantasy');

  final Move _slash = Move(
    name: 'Slash',
    description: 'So simple, a baby could do it.',
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
  final Move _stab = Move(
    name: 'Stab',
    description: 'Don\'t forget to use the plant leg for a little more umph!',
    moveNum: 2,
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
  final Move _bonk = Move(
    name: 'Bonk',
    description: 'A little love tap for a little sleepy-sleep.',
    moveNum: 3,
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

  final Move _arrow = Move(
    name: 'Arrow',
    description: 'Arrow. Bow. Pheesh. Thwak!.',
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
  final Move _serratedArrow = Move(
    name: 'Serrated Arrow',
    description:
        'Try pulling one of these out of leg without crying for momma.',
    moveNum: 2,
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

  final Move _fireball = Move(
    name: 'Fireball',
    description: 'Every baby pyromancer\'s dream.',
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

  final Move _explosivePowder = Move(
    name: 'Explosive Powder',
    description: 'Can you say, boom!',
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

  final Move _catapult = Move(
    name: 'Catapult',
    description: 'It\'s raining, it\'s pouring, the rocks\'re gonna crush us!.',
    moveNum: 1,
    element: MoveElement.earth.toString(),
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
  final Move _ballista = Move(
    name: 'Ballista',
    description:
        'Who needs to wait for Humpty-Dumpty to fall, when you can just crush the wall he\'s on?',
    moveNum: 2,
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
  final Move _batteringRam = Move(
    name: 'Battering Ram',
    description:
        'Why can\'t you hide in your room? Because papa\'s gonna use this bad boy!',
    moveNum: 3,
    element: MoveElement.flora.toString(),
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

  final MoveList _melee = MoveList(name: 'Melee', listNum: 1);
  final MoveList _ranged = MoveList(name: 'Ranged', listNum: 2);
  final MoveList _magic = MoveList(name: 'Magic', listNum: 3);
  final MoveList _explosives = MoveList(name: 'Explosives', listNum: 4);
  final MoveList _siege = MoveList(name: 'Siege', listNum: 5);

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
        _melee.name,
        [
          _slash,
          _stab,
          _bonk,
        ],
      ),
      MoveListBuilder(
        _ranged.name,
        [
          _arrow,
          _serratedArrow,
        ],
      ),
      MoveListBuilder(
        _magic.name,
        [
          _fireball,
        ],
      ),
      MoveListBuilder(
        _explosives.name,
        [
          _explosivePowder,
        ],
      ),
      MoveListBuilder(
        _siege.name,
        [
          _catapult,
          _ballista,
          _batteringRam,
        ],
      ),
    ];
  }

  @override
  List<UnitListBuilder> generateUnits() {
    return [
      UnitListBuilder(
        'Soldiers',
        [
          Unit(
            name: 'Infantry',
            description: 'The peasants sent to the meat grinder of war.',
            unitNum: 1,
            moveset: Moveset(
              [
                MoveGroup(
                  _melee.name,
                  [
                    MoveGroupPair(
                      _slash,
                      _melee,
                    ),
                    MoveGroupPair(
                      _stab,
                      _melee,
                    ),
                    MoveGroupPair(
                      _bonk,
                      _melee,
                    ),
                  ],
                ),
              ],
            ),
            fields: [
              UnitFieldData(_vitality, 25),
              UnitFieldData(_strength, 35),
              UnitFieldData(_intelligence, 25),
              UnitFieldData(_wisdom, 25),
              UnitFieldData(_agility, 25),
              UnitFieldData(_luck, 25),
              UnitFieldData(_flying, false),
              UnitFieldData(_element, MoveElement.neutral.name),
            ],
          ),
          Unit(
            name: 'Archer',
            description: 'Doesn\'t bring a sword to an arrow fight.',
            unitNum: 2,
            moveset: Moveset(
              [
                MoveGroup(
                  _ranged.name,
                  [
                    MoveGroupPair(
                      _arrow,
                      _ranged,
                    ),
                    MoveGroupPair(
                      _serratedArrow,
                      _ranged,
                    ),
                  ],
                ),
              ],
            ),
            fields: [
              UnitFieldData(_vitality, 25),
              UnitFieldData(_strength, 20),
              UnitFieldData(_intelligence, 35),
              UnitFieldData(_wisdom, 25),
              UnitFieldData(_agility, 35),
              UnitFieldData(_luck, 25),
              UnitFieldData(_flying, false),
              UnitFieldData(_element, MoveElement.neutral.name),
            ],
          ),
          Unit(
            name: 'Mage',
            description: 'Pointy hat, cool staff. Enough said?',
            unitNum: 3,
            moveset: Moveset(
              [
                MoveGroup(
                  _magic.name,
                  [
                    MoveGroupPair(
                      _fireball,
                      _magic,
                    ),
                  ],
                ),
              ],
            ),
            fields: [
              UnitFieldData(_vitality, 25),
              UnitFieldData(_strength, 20),
              UnitFieldData(_intelligence, 35),
              UnitFieldData(_wisdom, 40),
              UnitFieldData(_agility, 25),
              UnitFieldData(_luck, 25),
              UnitFieldData(_flying, true),
              UnitFieldData(_element, MoveElement.neutral.name),
            ],
          ),
          Unit(
            name: 'Bombardier',
            description: 'Everything goes boom, boom!',
            unitNum: 4,
            moveset: Moveset(
              [
                MoveGroup(
                  _explosives.name,
                  [
                    MoveGroupPair(
                      _explosivePowder,
                      _explosives,
                    ),
                  ],
                ),
              ],
            ),
            fields: [
              UnitFieldData(_vitality, 35),
              UnitFieldData(_strength, 30),
              UnitFieldData(_intelligence, 25),
              UnitFieldData(_wisdom, 25),
              UnitFieldData(_agility, 25),
              UnitFieldData(_luck, 35),
              UnitFieldData(_flying, false),
              UnitFieldData(_element, MoveElement.fire.name),
            ],
          ),
        ],
      ),
      UnitListBuilder(
        'Monsters',
        [
          Unit(
            name: 'Goblin',
            description: 'Sneaky little bastard.',
            unitNum: 1,
            moveset: Moveset(
              [],
            ),
            fields: [
              UnitFieldData(_vitality, 20),
              UnitFieldData(_strength, 20),
              UnitFieldData(_intelligence, 35),
              UnitFieldData(_wisdom, 25),
              UnitFieldData(_agility, 45),
              UnitFieldData(_luck, 25),
              UnitFieldData(_flying, false),
              UnitFieldData(_element, MoveElement.flora.name),
            ],
          ),
          //TODO: _griffin,
          Unit(
            name: 'Dragon',
            description: 'Big. Breathes fire. Do you really need to know anything else?',
            unitNum: 3,
            moveset: Moveset(
              [
                MoveGroup(
                  _melee.name,
                  [
                    MoveGroupPair(
                      _slash,
                      _melee,
                    ),
                  ],
                ),
                MoveGroup(
                  _magic.name,
                  [
                    MoveGroupPair(
                      _fireball,
                      _magic,
                    ),
                  ],
                ),
              ],
            ),
            fields: [
              UnitFieldData(_vitality, 45),
              UnitFieldData(_strength, 45),
              UnitFieldData(_intelligence, 45),
              UnitFieldData(_wisdom, 45),
              UnitFieldData(_agility, 45),
              UnitFieldData(_luck, 45),
              UnitFieldData(_flying, true),
              UnitFieldData(_element, MoveElement.fire.name),
            ],
          ),
        ],
      ),
    ];
  }
}
