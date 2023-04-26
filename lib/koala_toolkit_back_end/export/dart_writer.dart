import 'dart:io';

import '../../file_management.dart';
import '../../koala_strings.dart';
import '../data/moves/move.dart';
import '../data/units/unit.dart';

class DartWriter {
  DartWriter._();

  static Future<Directory> writeMoves(String folderName, List<Move> moves) async {
    await FileManagement.clearTemp();
    Directory dir = await Directory('${await FileManagement.tempPath}/$folderName').create();

    await _addMoveClass(dir, folderName);
    await _addMoveListClass(dir, folderName, moves);
    await _addMoveModifierClasses(await Directory('${dir.path}/modifiers').create(), folderName);

    return dir;
  }

  static Future<void> _addMoveClass(Directory dir, String folderName) async {
    String moveClass = '''
import '../$folderName.dart';

class Move {
  final String name;
  final int moveNum;
  final String element;
  final String moveType;
  final EnergyCost energyCost;
  final Power? power;
  final Range range;
  final Accuracy accuracy;
  final Knockback? knockback;
  final Lunge? lunge;
  final LOS? los;
  final RangeBoostable? rangeBoostable;
  final DirectContact? directContact;
  final Utility? utility;
  final CompoundingPower? compoundingPower;
  final DeprecatingPower? deprecatingPower;
  final MultiHit? multiHit;
  final Pull? pull;
  final BattleEffect? battleEffect;
  final Bounceback? bounceback;
  final Recoil? recoil;
  final Cooldown? cooldown;
  final SideEffect? sideEffect;
  final CrashDamage? crashDamage;

  Move({
    required this.name,
    required this.moveNum,
    required this.element,
    required this.moveType,
    required this.energyCost,
    required this.power,
    required this.range,
    required this.accuracy,
    required this.knockback,
    required this.lunge,
    required this.los,
    required this.rangeBoostable,
    required this.directContact,
    required this.utility,
    required this.compoundingPower,
    required this.deprecatingPower,
    required this.multiHit,
    required this.pull,
    required this.battleEffect,
    required this.bounceback,
    required this.recoil,
    required this.cooldown,
    required this.sideEffect,
    required this.crashDamage,
  });
  
  @override
  String toString() => name;
}

''';

    await File('${dir.path}/move.dart').writeAsString(moveClass);
  }

  static Future<void> _addMoveListClass(Directory dir, String folderName, List<Move> moves) async {
    String start = '''
import '../$folderName.dart';
import 'move.dart';

class MoveList {
  MoveList._();
''';

    String middle = '';
    for (Move move in moves) {
      middle += '''

  static final Move ${toCamelCase(move.name)} = Move(
    name: '${move.name}',
    moveNum: ${move.moveNum},
    element: '${move.element}',
    moveType: '${move.moveType}',
    energyCost: EnergyCost(${move.energyCost}),
    power: ${move.hasPower ? 'Power(${move.powerMin}, ${move.powerMax})' : 'null'},
    range: Range(${move.rangeMin}, ${move.rangeMax}),
    accuracy: Accuracy(${move.accuracy}),
    knockback: ${move.hasKnockback ? 'Knockback(${move.knockbackValue}, ${move.isKnockbackAirborne}, \'${move.knockbackType}\')' : 'null'},
    lunge: ${move.hasLunge ? 'Lunge(${move.lungeValue}, ${move.isLungeAirborne})' : 'null'},
    los: ${move.hasLOSModifier ? 'LOS(${move.hasLOS})' : 'null'},
    rangeBoostable: ${move.hasRangeBoostableModifier ? 'RangeBoostable(${move.isRangeBoostable})' : 'null'},
    directContact: ${move.hasDirectContactModifier ? 'DirectContact(${move.hasDirectContact})' : 'null'},
    utility: ${move.hasUtility ? 'Utility(\'${move.utilityType}\')' : 'null'},
    compoundingPower: ${move.hasCompoundingPowerModifier ? 'CompoundingPower(${move.hasCompoundingPower})' : 'null'},
    deprecatingPower: ${move.hasDeprecatingPowerModifier ? 'DeprecatingPower(${move.hasDeprecatingPower})' : 'null'},
    multiHit: ${move.hasMultiHit ? 'MultiHit(${move.multiHitValue})' : 'null'},
    pull: ${move.hasPull ? 'Pull(${move.pullValue}, ${move.isPullAirborne}, \'${move.pullPriority}\', \'${move.pullType}\')' : 'null'},
    battleEffect: ${move.hasBattleEffect ? 'BattleEffect(\'${move.battleEffectType}\')' : 'null'},
    bounceback: ${move.hasBounceback ? 'Bounceback(${move.bouncebackValue}, ${move.isBouncebackAirborne}, \'${move.bouncebackPriority}\')' : 'null'},
    recoil: ${move.hasRecoil ? 'Recoil(${move.recoilMin}, ${move.recoilMax})' : 'null'},
    cooldown: ${move.hasCooldown ? 'Cooldown(${move.cooldownValue})' : 'null'},
    sideEffect: ${move.hasSideEffect ? 'SideEffect(\'${move.sideEffectType}\')' : 'null'},
    crashDamage: ${move.hasCrashDamage ? 'CrashDamage(${move.crashDamageMin}, ${move.crashDamageMax})' : 'null'},
  );
''';
    }

    String end ='''
}

''';

    await File('${dir.path}/move_list.dart').writeAsString(start + middle + end);
  }

  static Future<void> _addMoveModifierClasses(Directory dir, String folderName) async {
    await File('${dir.path}/energy_cost.dart').writeAsString('''
class EnergyCost {
  late final int val;

  EnergyCost(
    int val,
  ) {
    this.val = val > 1 ? val : 1;
  }
}

'''
    );

    await File('${dir.path}/power.dart').writeAsString('''
class Power {
  late final int min;
  late final int max;

  Power(
    int min,
    int max,
  ) {
    this.min = min > 1 ? min : 1;
    this.max = max > this.min ? max : this.min;
  }
}

'''
    );

    await File('${dir.path}/range.dart').writeAsString('''
class Range {
  late final int min;
  late final int max;

  Range(
    int min,
    int max,
  ) {
    this.min = min > 1 ? min : 1;
    this.max = max > this.min ? max : this.min;
  }
}

'''
    );

    await File('${dir.path}/accuracy.dart').writeAsString('''
class Accuracy {
  late final int val;

  Accuracy(int val) {
    this.val = val < 2
  ? 1
        : val > 99
            ? 100
            : val;
  }
}

'''
    );

    await File('${dir.path}/knockback.dart').writeAsString('''
class Knockback {
  late final int val;
  final bool isAirborne;
  final String type;

  Knockback(
    int val,
    this.isAirborne,
    this.type,
  ) {
    this.val = val > 1 ? val : 1;
  }
}

'''
    );

    await File('${dir.path}/lunge.dart').writeAsString('''
class Lunge {
  late final int val;
  final bool isAirborne;

  Lunge(
    int val,
    this.isAirborne,
  ) {
    this.val = val > 1 ? val : 1;
  }
}

'''
    );

    await File('${dir.path}/los.dart').writeAsString('''
class LOS {
  final bool has;

  LOS(
    this.has,
  );
}

'''
    );

    await File('${dir.path}/range_boostable.dart').writeAsString('''
class RangeBoostable {
  final bool has;

  RangeBoostable(
    this.has,
  );
}

'''
    );

    await File('${dir.path}/direct_contact.dart').writeAsString('''
class DirectContact {
  final bool has;

  DirectContact(
    this.has,
  );
}

'''
    );

    await File('${dir.path}/utility.dart').writeAsString('''
class Utility {
  final String type;

  Utility(
    this.type,
  );
}

'''
    );

    await File('${dir.path}/compounding_power.dart').writeAsString('''
class CompoundingPower {
  final bool has;

  CompoundingPower(
    this.has,
  );
}

'''
    );

    await File('${dir.path}/deprecating_power.dart').writeAsString('''
class DeprecatingPower {
  final bool has;

  DeprecatingPower(
    this.has,
  );
}

'''
    );

    await File('${dir.path}/multi_hit.dart').writeAsString('''
class MultiHit {
  late final int val;

  MultiHit(
    int val,
  ) {
    this.val = val > 2 ? val : 2;
  }
}

'''
    );

    await File('${dir.path}/pull.dart').writeAsString('''
class Pull {
  late final int val;
  final bool isAirborne;
  final String priority;
  final String type;

  Pull(
    int val,
    this.isAirborne,
    this.priority,
    this.type,
  ) {
    this.val = val > 1 ? val : 1;
  }
}

'''
    );

    await File('${dir.path}/battle_effect.dart').writeAsString('''
class BattleEffect {
  final String type;

  BattleEffect(
    this.type,
  );
}

'''
    );

    await File('${dir.path}/bounceback.dart').writeAsString('''
class Bounceback {
  late final int val;
  final bool isAirborne;
  final String priority;

  Bounceback(
    int val,
    this.isAirborne,
    this.priority,
  ) {
    this.val = val > 1 ? val : 1;
  }
}

'''
    );

    await File('${dir.path}/recoil.dart').writeAsString('''
class Recoil {
  late final int min;
  late final int max;

  Recoil(
    int min,
    int max,
  ) {
    this.min = min > 1 ? min : 1;
    this.max = max > this.min ? max : this.min;
  }
}

'''
    );

    await File('${dir.path}/cooldown.dart').writeAsString('''
class Cooldown {
  late final int val;

  Cooldown(
    int val,
  ) {
    this.val = val > 1 ? val : 1;
  }
}

'''
    );

    await File('${dir.path}/side_effect.dart').writeAsString('''
class SideEffect {
  final String type;

  SideEffect(
    this.type,
  );
}

'''
    );

    await File('${dir.path}/crash_damage.dart').writeAsString('''
class CrashDamage {
  late final int min;
  late final int max;

  CrashDamage(
    int min,
    int max,
  ) {
    this.min = min > 1 ? min : 1;
    this.max = max > this.min ? max : this.min;
  }
}

'''
    );
  }

  static Future<Directory> writeUnits(String folderName, List<Unit> units) async {
    await FileManagement.clearTemp();
    Directory dir = await Directory('${await FileManagement.tempPath}/$folderName').create();

    //TODO: Write helper methods

    return dir;
  }
}
