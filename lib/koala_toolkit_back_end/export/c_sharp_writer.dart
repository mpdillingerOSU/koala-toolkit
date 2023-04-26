import 'dart:io';

import '../../file_management.dart';
import '../../koala_strings.dart';
import '../data/moves/move.dart';
import '../data/units/unit.dart';

class CSharpWriter {
  CSharpWriter._();

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
using System;

public sealed class Move
{
    public readonly string NAME;
    public readonly int MOVE_NUM;
    public readonly string ELEMENT;
    public readonly string MOVE_TYPE;
    public readonly EnergyCost ENERGY_COST;
    public readonly Power? POWER;
    public readonly Range RANGE;
    public readonly Accuracy ACCURACY;
    public readonly Knockback? KNOCKBACK;
    public readonly Lunge? LUNGE;
    public readonly LOS? LOS;
    public readonly RangeBoostable? RANGE_BOOSTABLE;
    public readonly DirectContact? DIRECT_CONTACT;
    public readonly Utility? UTILITY;
    public readonly CompoundingPower? COMPOUNDING_POWER;
    public readonly DeprecatingPower? DEPRECATING_POWER;
    public readonly MultiHit? MULTI_HIT;
    public readonly Pull? PULL;
    public readonly BattleEffect? BATTLE_EFFECT;
    public readonly Bounceback? BOUNCEBACK;
    public readonly Recoil? RECOIL;
    public readonly Cooldown? COOLDOWN;
    public readonly SideEffect? SIDE_EFFECT;
    public readonly CrashDamage? CRASH_DAMAGE;

    public Move(string NAME, int MOVE_NUM, string ELEMENT, string MOVE_TYPE, EnergyCost ENERGY_COST, Power? POWER, Range RANGE, Accuracy ACCURACY, Knockback? KNOCKBACK, Lunge? LUNGE, LOS? LOS, RangeBoostable? RANGE_BOOSTABLE, DirectContact? DIRECT_CONTACT, Utility? UTILITY, CompoundingPower? COMPOUNDING_POWER, DeprecatingPower? DEPRECATING_POWER, MultiHit? MULTI_HIT, Pull? PULL, BattleEffect? BATTLE_EFFECT, Bounceback? BOUNCEBACK, Recoil? RECOIL, Cooldown? COOLDOWN, SideEffect? SIDE_EFFECT, CrashDamage? CRASH_DAMAGE)
    {
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
    
    public override string ToString()
    {
      return NAME;
    }
}

''';

    await File('${dir.path}/Move.cs').writeAsString(moveClass);
  }

  static Future<void> _addMoveListClass(Directory dir, String folderName, List<Move> moves) async {
    String start = '''
using System;

public sealed class MoveList
{
    private MoveList(){}
''';

    String middle = '';
    for (Move move in moves) {
      middle += '''

    public static readonly Move ${toSnakeCase(move.name).toUpperCase()} = new Move("${move.name}", ${move.moveNum}, "${move.element}", "${move.moveType}", new EnergyCost(${move.energyCost}), ${move.hasPower ? 'new Power(${move.powerMin}, ${move.powerMax})' : 'null'}, new Range(${move.rangeMin}, ${move.rangeMax}), new Accuracy(${move.accuracy}), ${move.hasKnockback ? 'new Knockback(${move.knockbackValue}, ${move.isKnockbackAirborne}, "${move.knockbackType}")' : 'null'}, ${move.hasLunge ? 'new Lunge(${move.lungeValue}, ${move.isLungeAirborne})' : 'null'}, ${move.hasLOSModifier ? 'new LOS(${move.hasLOS})' : 'null'}, ${move.hasRangeBoostableModifier ? 'new RangeBoostable(${move.isRangeBoostable})' : 'null'}, ${move.hasDirectContactModifier ? 'new DirectContact(${move.hasDirectContact})' : 'null'}, ${move.hasUtility ? 'new Utility("${move.utilityType}")' : 'null'}, ${move.hasCompoundingPowerModifier ? 'new CompoundingPower(${move.hasCompoundingPower})' : 'null'}, ${move.hasDeprecatingPowerModifier ? 'new DeprecatingPower(${move.hasDeprecatingPower})' : 'null'}, ${move.hasMultiHit ? 'new MultiHit(${move.multiHitValue})' : 'null'}, ${move.hasPull ? 'new Pull(${move.pullValue}, ${move.isPullAirborne}, "${move.pullPriority}", "${move.pullType}")' : 'null'}, ${move.hasBattleEffect ? 'new BattleEffect("${move.battleEffectType}")' : 'null'}, ${move.hasBounceback ? 'new Bounceback(${move.bouncebackValue}, ${move.isBouncebackAirborne}, "${move.bouncebackPriority}")' : 'null'}, ${move.hasRecoil ? 'new Recoil(${move.recoilMin}, ${move.recoilMax})' : 'null'}, ${move.hasCooldown ? 'new Cooldown(${move.cooldownValue})' : 'null'}, ${move.hasSideEffect ? 'new SideEffect("${move.sideEffectType}")' : 'null'}, ${move.hasCrashDamage ? 'new CrashDamage(${move.crashDamageMin}, ${move.crashDamageMax})' : 'null'});
''';
    }

    String end ='''
}

''';

    await File('${dir.path}/MoveList.cs').writeAsString(start + middle + end);
  }

  static Future<void> _addMoveModifierClasses(Directory dir, String folderName) async {
    await File('${dir.path}/EnergyCost.cs').writeAsString('''
using System;

public sealed class EnergyCost
{
    public readonly int VAL;

    public EnergyCost(int VAL)
    {
        this.VAL = Math.Max(VAL, 1);
    }
}

'''
    );

    await File('${dir.path}/Power.cs').writeAsString('''
using System;

public sealed class Power
{
    public readonly int MIN;
    public readonly int MAX;

    public Power(int MIN, int MAX)
    {
        this.MIN = Math.Max(MIN, 1);
        this.MAX = Math.Max(MAX, this.MIN);
    }
}

'''
    );

    await File('${dir.path}/Range.cs').writeAsString('''
using System;

public sealed class Range
{
    public readonly int MIN;
    public readonly int MAX;

    public Range(int MIN, int MAX)
    {
        this.MIN = Math.Max(MIN, 1);
        this.MAX = Math.Max(MAX, this.MIN);
    }
}

'''
    );

    await File('${dir.path}/Accuracy.cs').writeAsString('''
using System;

public sealed class Accuracy
{
    public readonly int VAL;

    public Accuracy(int VAL)
    {
        this.VAL = Math.Max(1, Math.Min(VAL, 100));
    }
}

'''
    );

    await File('${dir.path}/Knockback.cs').writeAsString('''
using System;

public sealed class Knockback
{
    public readonly int VAL;
    public readonly bool IS_AIRBORNE;
    public readonly string TYPE;

    public Knockback(int VAL, bool IS_AIRBORNE, string TYPE)
    {
        this.VAL = Math.Max(VAL, 1);
        this.IS_AIRBORNE = IS_AIRBORNE;
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/Lunge.cs').writeAsString('''
using System;

public sealed class Lunge
{
    public readonly int VAL;
    public readonly bool IS_AIRBORNE;

    public Lunge(int VAL, bool IS_AIRBORNE)
    {
        this.VAL = Math.Max(VAL, 1);
        this.IS_AIRBORNE = IS_AIRBORNE;
    }
}

'''
    );

    await File('${dir.path}/LOS.cs').writeAsString('''
using System;

public sealed class LOS
{
    public readonly bool HAS;

    public LOS(bool HAS)
    {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/RangeBoostable.cs').writeAsString('''
using System;

public sealed class RangeBoostable
{
    public readonly bool HAS;

    public RangeBoostable(bool HAS)
    {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/DirectContact.cs').writeAsString('''
using System;

public sealed class DirectContact
{
    public readonly bool HAS;

    public DirectContact(bool HAS)
    {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/Utility.cs').writeAsString('''
using System;

public sealed class Utility
{
    public readonly string TYPE;

    public Utility(string TYPE)
    {
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/CompoundingPower.cs').writeAsString('''
using System;

public sealed class CompoundingPower
{
    public readonly bool HAS;

    public CompoundingPower(bool HAS)
    {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/DeprecatingPower.cs').writeAsString('''
using System;

public sealed class DeprecatingPower
{
    public readonly bool HAS;

    public DeprecatingPower(bool HAS)
    {
        this.HAS = HAS;
    }
}

'''
    );

    await File('${dir.path}/MultiHit.cs').writeAsString('''
using System;

public sealed class MultiHit
{
    public readonly int VAL;

    public MultiHit(int VAL)
    {
        this.VAL = Math.Max(VAL, 2);
    }
}

'''
    );

    await File('${dir.path}/Pull.cs').writeAsString('''
using System;

public sealed class Pull
{
    public readonly int VAL;
    public readonly bool IS_AIRBORNE;
    public readonly string PRIORITY;
    public readonly string TYPE;

    public Pull(int VAL, bool IS_AIRBORNE, string PRIORITY, string TYPE)
    {
        this.VAL = Math.Max(VAL, 1);
        this.IS_AIRBORNE = IS_AIRBORNE;
        this.PRIORITY = PRIORITY;
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/BattleEffect.cs').writeAsString('''
using System;

public sealed class BattleEffect
{
    public readonly string TYPE;

    public BattleEffect(string TYPE)
    {
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/Bounceback.cs').writeAsString('''
using System;

public sealed class Bounceback
{
    public readonly int VAL;
    public readonly bool IS_AIRBORNE;
    public readonly string PRIORITY;

    public Bounceback(int VAL, bool IS_AIRBORNE, string PRIORITY)
    {
        this.VAL = Math.Max(VAL, 1);
        this.IS_AIRBORNE = IS_AIRBORNE;
        this.PRIORITY = PRIORITY;
    }
}

'''
    );

    await File('${dir.path}/Recoil.cs').writeAsString('''
using System;

public sealed class Recoil
{
    public readonly int MIN;
    public readonly int MAX;

    public Recoil(int MIN, int MAX)
    {
        this.MIN = Math.Max(MIN, 1);
        this.MAX = Math.Max(MAX, this.MIN);
    }
}

'''
    );

    await File('${dir.path}/Cooldown.cs').writeAsString('''
using System;

public sealed class Cooldown
{
    public readonly int VAL;

    public Cooldown(int VAL)
    {
        this.VAL = Math.Max(VAL, 1);
    }
}

'''
    );

    await File('${dir.path}/SideEffect.cs').writeAsString('''
using System;

public sealed class SideEffect
{
    public readonly string TYPE;

    public SideEffect(string TYPE)
    {
        this.TYPE = TYPE;
    }
}

'''
    );

    await File('${dir.path}/CrashDamage.cs').writeAsString('''
using System;

public sealed class CrashDamage
{
    public readonly int MIN;
    public readonly int MAX;

    public CrashDamage(int MIN, int MAX)
    {
        this.MIN = Math.Max(MIN, 1);
        this.MAX = Math.Max(MAX, this.MIN);
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
