import 'dart:io';

import '../../file_management.dart';
import '../../koala_strings.dart';
import '../data/moves/move.dart';
import '../data/units/unit.dart';

class CPPWriter {
  CPPWriter._();

  static Future<Directory> writeMoves(String folderName, List<Move> moves) async {
    await FileManagement.clearTemp();
    Directory dir = await Directory('${await FileManagement.tempPath}/$folderName').create();

    await _addMoveClass(dir, folderName);
    await _addMoveListClass(dir, folderName, moves);
    await _addMoveModifierClasses(await Directory('${dir.path}/Modifiers').create(), folderName);

    return dir;
  }

  static Future<void> _addMoveClass(Directory dir, String folderName) async {
    String moveClass = '''
package $folderName;

import $folderName.Modifiers.*;

public final class Move {
    public:
        final String NAME;
        final int MOVE_NUM;
        final String ELEMENT;
        final String MOVE_TYPE;
        final EnergyCost ENERGY_COST;
        final Power POWER;
        final Range RANGE;
        final Accuracy ACCURACY;
        final Knockback KNOCKBACK;
        final Lunge LUNGE;
        final LOS LOS;
        final RangeBoostable RANGE_BOOSTABLE;
        final DirectContact DIRECT_CONTACT;
        final Utility UTILITY;
        final CompoundingPower COMPOUNDING_POWER;
        final DeprecatingPower DEPRECATING_POWER;
        final MultiHit MULTI_HIT;
        final Pull PULL;
        final BattleEffect BATTLE_EFFECT;
        final Bounceback BOUNCEBACK;
        final Recoil RECOIL;
        final Cooldown COOLDOWN;
        final SideEffect SIDE_EFFECT;
        final CrashDamage CRASH_DAMAGE;
    
        Move(String NAME, int MOVE_NUM, String ELEMENT, String MOVE_TYPE, EnergyCost ENERGY_COST, Power POWER, Range RANGE, Accuracy ACCURACY, Knockback KNOCKBACK, Lunge LUNGE, LOS LOS, RangeBoostable RANGE_BOOSTABLE, DirectContact DIRECT_CONTACT, Utility UTILITY, CompoundingPower COMPOUNDING_POWER, DeprecatingPower DEPRECATING_POWER, MultiHit MULTI_HIT, Pull PULL, BattleEffect BATTLE_EFFECT, Bounceback BOUNCEBACK, Recoil RECOIL, Cooldown COOLDOWN, SideEffect SIDE_EFFECT, CrashDamage CRASH_DAMAGE){
            this.NAME = NAME;
            this.MOVE_NUM = MOVE_NUM;
            this.ELEMENT = ELEMENT;
            this.MOVE_TYPE = MOVE_TYPE;
            this.ENERGY_COST = ENERGY_COST;
            this.POWER = POWER;
            this.RANGE = RANGE;
            this.ACCURACY = ACCURACY;
            this.KNOCKBACK = KNOCKBACK;
            this.LUNGE = LUNGE;
            this.LOS = LOS;
            this.RANGE_BOOSTABLE = RANGE_BOOSTABLE;
            this.DIRECT_CONTACT = DIRECT_CONTACT;
            this.UTILITY = UTILITY;
            this.COMPOUNDING_POWER = COMPOUNDING_POWER;
            this.DEPRECATING_POWER = DEPRECATING_POWER;
            this.MULTI_HIT = MULTI_HIT;
            this.PULL = PULL;
            this.BATTLE_EFFECT = BATTLE_EFFECT;
            this.BOUNCEBACK = BOUNCEBACK;
            this.RECOIL = RECOIL;
            this.COOLDOWN = COOLDOWN;
            this.SIDE_EFFECT = SIDE_EFFECT;
            this.CRASH_DAMAGE = CRASH_DAMAGE;
        }
        
        @Override
        String toString() {
            return NAME;
        }
}

''';

    await File('${dir.path}/move.cpp').writeAsString(moveClass);
  }

  static Future<void> _addMoveListClass(Directory dir, String folderName, List<Move> moves) async {
    String start = '''
package $folderName;

import $folderName.Modifiers.*;

public final class MoveList {
    private MoveList(){}
''';

    String middle = '';
    for (Move move in moves) {
      middle += '''

    public static final Move ${toSnakeCase(move.name).toUpperCase()} = new Move("${move.name}", ${move.moveNum}, "${move.element}", "${move.moveType}", new EnergyCost(${move.energyCost}), ${move.hasPower ? 'new Power(${move.powerMin}, ${move.powerMax})' : 'null'}, new Range(${move.rangeMin}, ${move.rangeMax}), new Accuracy(${move.accuracy}), ${move.hasKnockback ? 'new Knockback(${move.knockbackValue}, ${move.isKnockbackAirborne}, "${move.knockbackType}")' : 'null'}, ${move.hasLunge ? 'new Lunge(${move.lungeValue}, ${move.isLungeAirborne})' : 'null'}, ${move.hasLOSModifier ? 'new LOS(${move.hasLOS})' : 'null'}, ${move.hasRangeBoostableModifier ? 'new RangeBoostable(${move.isRangeBoostable})' : 'null'}, ${move.hasDirectContactModifier ? 'new DirectContact(${move.hasDirectContact})' : 'null'}, ${move.hasUtility ? 'new Utility("${move.utilityType}")' : 'null'}, ${move.hasCompoundingPowerModifier ? 'new CompoundingPower(${move.hasCompoundingPower})' : 'null'}, ${move.hasDeprecatingPowerModifier ? 'new DeprecatingPower(${move.hasDeprecatingPower})' : 'null'}, ${move.hasMultiHit ? 'new MultiHit(${move.multiHitValue})' : 'null'}, ${move.hasPull ? 'new Pull(${move.pullValue}, ${move.isPullAirborne}, "${move.pullPriority}", "${move.pullType}")' : 'null'}, ${move.hasBattleEffect ? 'new BattleEffect("${move.battleEffectType}")' : 'null'}, ${move.hasBounceback ? 'new Bounceback(${move.bouncebackValue}, ${move.isBouncebackAirborne}, "${move.bouncebackPriority}")' : 'null'}, ${move.hasRecoil ? 'new Recoil(${move.recoilMin}, ${move.recoilMax})' : 'null'}, ${move.hasCooldown ? 'new Cooldown(${move.cooldownValue})' : 'null'}, ${move.hasSideEffect ? 'new SideEffect("${move.sideEffectType}")' : 'null'}, ${move.hasCrashDamage ? 'new CrashDamage(${move.crashDamageMin}, ${move.crashDamageMax})' : 'null'});
''';
    }

    String end ='''
}

''';

    await File('${dir.path}/moveList.cpp').writeAsString(start + middle + end);
  }

  static Future<void> _addMoveModifierClasses(Directory dir, String folderName) async {
    await File('${dir.path}/energyCost.cpp').writeAsString('''
package $folderName.Modifiers;

public final class EnergyCost {
    public final int VAL;

    public EnergyCost(int VAL) {
        this.VAL = Math.max(VAL, 1);
    }
}

'''
    );

    await File('${dir.path}/power.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Power {
    public final int MIN;
    public final int MAX;

    public Power(int MIN, int MAX) {
        this.MIN = Math.max(MIN, 1);
        this.MAX = Math.max(MAX, this.MIN);
    }
}

'''
    );

    await File('${dir.path}/range.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Range {
    public final int MIN;
    public final int MAX;

    public Range(int MIN, int MAX) {
        this.MIN = Math.max(MIN, 1);
        this.MAX = Math.max(MAX, this.MIN);
    }
}

'''
    );

    await File('${dir.path}/accuracy.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Accuracy {
    public final int VAL;

    public Accuracy(int VAL) {
        this.VAL = Math.max(1, Math.min(VAL, 100));
    }
}

'''
    );

    await File('${dir.path}/knockback.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Knockback {
    public final int VAL;
    public final boolean IS_AIRBORNE;
    public final String TYPE;

    public Knockback(int VAL, boolean IS_AIRBORNE, String TYPE) {
        this.VAL = Math.max(VAL, 1);
        this.IS_AIRBORNE = IS_AIRBORNE;
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/lunge.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Lunge {
    public final int VAL;
    public final boolean IS_AIRBORNE;

    public Lunge(int VAL, boolean IS_AIRBORNE) {
        this.VAL = Math.max(VAL, 1);
        this.IS_AIRBORNE = IS_AIRBORNE;
    }
}

'''
    );

    await File('${dir.path}/los.cpp').writeAsString('''
package $folderName.Modifiers;

public final class LOS {
    public final boolean HAS;

    public LOS(boolean HAS) {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/rangeBoostable.cpp').writeAsString('''
package $folderName.Modifiers;

public final class RangeBoostable {
    public final boolean HAS;

    public RangeBoostable(boolean HAS) {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/directContact.cpp').writeAsString('''
package $folderName.Modifiers;

public final class DirectContact {
    public final boolean HAS;

    public DirectContact(boolean HAS) {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/utility.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Utility {
    public final String TYPE;

    public Utility(String TYPE) {
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/compoundingPower.cpp').writeAsString('''
package $folderName.Modifiers;

public final class CompoundingPower {
    public final boolean HAS;

    public CompoundingPower(boolean HAS) {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/deprecatingPower.cpp').writeAsString('''
package $folderName.Modifiers;

public final class DeprecatingPower {
    public final boolean HAS;

    public DeprecatingPower(boolean HAS) {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/multiHit.cpp').writeAsString('''
package $folderName.Modifiers;

public final class MultiHit {
    public final int VAL;

    public MultiHit(int VAL) {
        this.VAL = Math.max(VAL, 2);
    }
}

'''
    );

    await File('${dir.path}/pull.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Pull {
    public final int VAL;
    public final boolean IS_AIRBORNE;
    public final String PRIORITY;
    public final String TYPE;

    public Pull(int VAL, boolean IS_AIRBORNE, String PRIORITY, String TYPE) {
        this.VAL = Math.max(VAL, 1);
        this.IS_AIRBORNE = IS_AIRBORNE;
        this.PRIORITY = PRIORITY;
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/battleEffect.cpp').writeAsString('''
package $folderName.Modifiers;

public final class BattleEffect {
    public final String TYPE;

    public BattleEffect(String TYPE) {
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/bounceback.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Bounceback {
    public final int VAL;
    public final boolean IS_AIRBORNE;
    public final String PRIORITY;

    public Bounceback(int VAL, boolean IS_AIRBORNE, String PRIORITY) {
        this.VAL = Math.max(VAL, 1);
        this.IS_AIRBORNE = IS_AIRBORNE;
        this.PRIORITY = PRIORITY;
    }
}

'''
    );

    await File('${dir.path}/recoil.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Recoil {
    public final int MIN;
    public final int MAX;

    public Recoil(int MIN, int MAX) {
        this.MIN = Math.max(MIN, 1);
        this.MAX = Math.max(MAX, this.MIN);
    }
}

'''
    );

    await File('${dir.path}/cooldown.cpp').writeAsString('''
package $folderName.Modifiers;

public final class Cooldown {
    public final int VAL;

    public Cooldown(int VAL) {
        this.VAL = Math.max(VAL, 1);
    }
}

'''
    );

    await File('${dir.path}/sideEffect.cpp').writeAsString('''
package $folderName.Modifiers;

public final class SideEffect {
    public final String TYPE;

    public SideEffect(String TYPE) {
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/crashDamage.cpp').writeAsString('''
package $folderName.Modifiers;

public final class CrashDamage {
    public final int MIN;
    public final int MAX;

    public CrashDamage(int MIN, int MAX) {
        this.MIN = Math.max(MIN, 1);
        this.MAX = Math.max(MAX, this.MIN);
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
