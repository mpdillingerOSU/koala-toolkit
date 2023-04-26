import 'dart:io';

import '../../file_management.dart';
import '../../koala_strings.dart';
import '../data/moves/move.dart';
import '../data/units/unit.dart';

class PythonWriter {
  PythonWriter._();

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
class Move:
  def __init__(self, name, move_num, element, move_type, energy_cost, power, range, accuracy, knockback, lunge, los, range_boostable, direct_contact, utility, compounding_power, deprecating_power, multi_hit, pull, battle_effect, bounceback, recoil, cooldown, side_effect, crash_damage):
    self._name = name
    self._move_num = move_num
    self._element = element
    self._move_type = move_type
    self._energy_cost = energy_cost
    self._power = power
    self._range = range
    self._accuracy = accuracy
    self._knockback = knockback
    self._lunge = lunge
    self._los = los
    self._range_boostable = range_boostable
    self._direct_contact = direct_contact
    self._utility = utility
    self._compounding_power = compounding_power
    self._deprecating_power = deprecating_power
    self._multi_hit = multi_hit
    self._pull = pull
    self._battle_effect = battle_effect
    self._bounceback = bounceback
    self._recoil = recoil
    self._cooldown = cooldown
    self._side_effect = side_effect
    self._crash_damage = crash_damage
  
  def get_name(self):
    return self._name
    
  def get_move_num(self):
    return self._move_num
    
  def get_element(self):
    return self._element
    
  def get_move_type(self):
    return self._move_type
    
  def get_energy_cost(self):
    return self._energy_cost
    
  def get_power(self):
    return self._power
    
  def get_range(self):
    return self._range
    
  def get_accuracy(self):
    return self._accuracy
    
  def get_knockback(self):
    return self._knockback
    
  def get_lunge(self):
    return self._lunge
    
  def get_los(self):
    return self._los
    
  def get_range_boostable(self):
    return self._range_boostable
    
  def get_direct_contact(self):
    return self._direct_contact
    
  def get_utility(self):
    return self._utility
    
  def get_compounding_power(self):
    return self._compounding_power
    
  def get_deprecating_power(self):
    return self._deprecating_power
    
  def get_multi_hit(self):
    return self._multi_hit
    
  def get_pull(self):
    return self._pull
    
  def get_battle_effect(self):
    return self._battle_effect
    
  def get_bounceback(self):
    return self._bounceback
    
  def get_recoil(self):
    return self._recoil
    
  def get_cooldown(self):
    return self._cooldown
    
  def get_side_effect(self):
    return self._side_effect
    
  def get_crash_damage(self):
    return self._crash_damage

  def __str__(self):
    return self._name

''';

    await File('${dir.path}/Move.py').writeAsString(moveClass);
  }

  static Future<void> _addMoveListClass(Directory dir, String folderName, List<Move> moves) async {
    String start = '''
from $folderName.Move import Move
from $folderName.Modifiers.EnergyCost import EnergyCost
from $folderName.Modifiers.Power import Power
from $folderName.Modifiers.Range import Range
from $folderName.Modifiers.Accuracy import Accuracy
from $folderName.Modifiers.Knockback import Knockback
from $folderName.Modifiers.Lunge import Lunge
from $folderName.Modifiers.LOS import LOS
from $folderName.Modifiers.RangeBoostable import RangeBoostable
from $folderName.Modifiers.DirectContact import DirectContact
from $folderName.Modifiers.Utility import Utility
from $folderName.Modifiers.CompoundingPower import CompoundingPower
from $folderName.Modifiers.DeprecatingPower import DeprecatingPower
from $folderName.Modifiers.MultiHit import MultiHit
from $folderName.Modifiers.Pull import Pull
from $folderName.Modifiers.BattleEffect import BattleEffect
from $folderName.Modifiers.Bounceback import Bounceback
from $folderName.Modifiers.Recoil import Recoil
from $folderName.Modifiers.Cooldown import Cooldown
from $folderName.Modifiers.SideEffect import SideEffect
from $folderName.Modifiers.CrashDamage import CrashDamage

class MoveList:
''';


    String middle = '';
    for (Move move in moves) {
      middle += '''
  ${toSnakeCase(move.name).toUpperCase()} = Move('${move.name}', ${move.moveNum}, '${move.element}', '${move.moveType}', EnergyCost(${move.energyCost}), ${move.hasPower ? 'Power(${move.powerMin}, ${move.powerMax})' : 'None'}, Range(${move.rangeMin}, ${move.rangeMax}), Accuracy(${move.accuracy}), ${move.hasKnockback ? 'Knockback(${move.knockbackValue}, ${move.isKnockbackAirborne}, \'${move.knockbackType}\')' : 'None'}, ${move.hasLunge ? 'Lunge(${move.lungeValue}, ${move.isLungeAirborne})' : 'None'}, ${move.hasLOSModifier ? 'LOS(${move.hasLOS})' : 'None'}, ${move.hasRangeBoostableModifier ? 'RangeBoostable(${move.isRangeBoostable})' : 'None'}, ${move.hasDirectContactModifier ? 'DirectContact(${move.hasDirectContact})' : 'None'}, ${move.hasUtility ? 'Utility(\'${move.utilityType}\')' : 'None'}, ${move.hasCompoundingPowerModifier ? 'CompoundingPower(${move.hasCompoundingPower})' : 'None'}, ${move.hasDeprecatingPowerModifier ? 'DeprecatingPower(${move.hasDeprecatingPower})' : 'None'}, ${move.hasMultiHit ? 'MultiHit(${move.multiHitValue})' : 'None'}, ${move.hasPull ? 'Pull(${move.pullValue}, ${move.isPullAirborne}, \'${move.pullPriority}\', \'${move.pullType}\')' : 'None'}, ${move.hasBattleEffect ? 'BattleEffect(\'${move.battleEffectType}\')' : 'None'}, ${move.hasBounceback ? 'Bounceback(${move.bouncebackValue}, ${move.isBouncebackAirborne}, \'${move.bouncebackPriority}\')' : 'None'}, ${move.hasRecoil ? 'Recoil(${move.recoilMin}, ${move.recoilMax})' : 'None'}, ${move.hasCooldown ? 'Cooldown(${move.cooldownValue})' : 'None'}, ${move.hasSideEffect ? 'SideEffect(\'${move.sideEffectType}\')' : 'None'}, ${move.hasCrashDamage ? 'CrashDamage(${move.crashDamageMin}, ${move.crashDamageMax})' : 'None'})
  
''';
    }

    String end = '''''';

    await File('${dir.path}/MoveList.py').writeAsString(start + middle + end);
  }

  static Future<void> _addMoveModifierClasses(Directory dir, String folderName) async {
    await File('${dir.path}/EnergyCost.py').writeAsString('''
class EnergyCost:
  def __init__(self, val):
    self._val = val if val > 1 else 1
    
  def get_val(self):
    return self._val

'''
    );

    await File('${dir.path}/Power.py').writeAsString('''
class Power:
  def __init__(self, min, max):
    self._min = min if min > 1 else 1
    self._max = max if max > self._min else self._min
    
  def get_min(self):
    return self._min
    
  def get_max(self):
    return self._max

'''
    );

    await File('${dir.path}/Range.py').writeAsString('''
class Range:
  def __init__(self, min, max):
    self._min = min if min > 0 else 0
    self._max = max if max > self._min else self._min
    
  def get_min(self):
    return self._min
    
  def get_max(self):
    return self._max

'''
    );

    await File('${dir.path}/Accuracy.py').writeAsString('''
class Accuracy:
  def __init__(self, val):
    self._val = 1 if val < 2 else 100 if val > 99 else val

  def get_val(self):
    return self._val

'''
    );

    await File('${dir.path}/Knockback.py').writeAsString('''
class Knockback:
  def __init__(self, val, is_airborne, type):
    self._val = val if val > 1 else 1
    self._is_airborne = is_airborne
    self._type = type

  def get_val(self):
    return self._val
    
  def get_is_airborne(self):
    return self._is_airborne
    
  def get_type(self):
    return self._type

'''
    );

    await File('${dir.path}/Lunge.py').writeAsString('''
class Lunge:
  def __init__(self, val, is_airborne):
    self._val = val if val > 1 else 1
    self._is_airborne = is_airborne

  def get_val(self):
    return self._val
    
  def get_is_airborne(self):
    return self._is_airborne

'''
    );

    await File('${dir.path}/LOS.py').writeAsString('''
class LOS:
  def __init__(self, has):
    self._has = has

  def has(self):
    return self._has

'''
    );

    await File('${dir.path}/RangeBoostable.py').writeAsString('''
class RangeBoostable:
  def __init__(self, has):
    self._has = has

  def has(self):
    return self._has

'''
    );

    await File('${dir.path}/DirectContact.py').writeAsString('''
class DirectContact:
  def __init__(self, has):
    self._has = has

  def has(self):
    return self._has

'''
    );

    await File('${dir.path}/Utility.py').writeAsString('''
class Utility:
  def __init__(self, type):
    self._type = type

  def get_type(self):
    return self._type

'''
    );

    await File('${dir.path}/CompoundingPower.py').writeAsString('''
class CompoundingPower:
  def __init__(self, has):
    self._has = has

  def has(self):
    return self._has 

'''
    );

    await File('${dir.path}/DeprecatingPower.py').writeAsString('''
class DeprecatingPower:
  def __init__(self, has):
    self._has = has

  def has(self):
    return self._has

'''
    );

    await File('${dir.path}/MultiHit.py').writeAsString('''
class MultiHit:
  def __init__(self, val):
    self._val = val if val > 2 else 2

  def get_val(self):
    return self._val

'''
    );

    await File('${dir.path}/Pull.py').writeAsString('''
class Pull:
  def __init__(self, val, is_airborne, priority, type):
    self._val = val if val > 1 else 1
    self._is_airborne = is_airborne
    self._priority = priority
    self._type = type

  def get_val(self):
    return self._val
    
  def get_is_airborne(self):
    return self._is_airborne

  def get_priority(self):
    return self._priority
    
  def get_type(self):
    return self._type

'''
    );

    await File('${dir.path}/BattleEffect.py').writeAsString('''
class BattleEffect:
  def __init__(self, type):
    self._type = type

  def get_type(self):
    return self._type

'''
    );

    await File('${dir.path}/Bounceback.py').writeAsString('''
class Bounceback:
  def __init__(self, val, is_airborne, priority):
    self._val = val if val > 1 else 1
    self._is_airborne = is_airborne
    self._priority = priority

  def get_val(self):
    return self._val

  def get_is_airborne(self):
    return self._is_airborne
    
  def get_priority(self):
    return self._priority

'''
    );

    await File('${dir.path}/Recoil.py').writeAsString('''
class Recoil:
  def __init__(self, min, max):
    self._min = min if min > 1 else 1
    self._max = max if max > self._min else self._min

  def get_min(self):
    return self._min
    
  def get_max(self):
    return self._max

'''
    );

    await File('${dir.path}/Cooldown.py').writeAsString('''
class Cooldown:
  def __init__(self, val):
    self._val = val if val > 1 else 1

  def get_val(self):
    return self._val

'''
    );

    await File('${dir.path}/SideEffect.py').writeAsString('''
class SideEffect:
  def __init__(self, type):
    self._type = type

  def get_type(self):
    return self._type

'''
    );

    await File('${dir.path}/CrashDamage.py').writeAsString('''
class CrashDamage:
  def __init__(self, min, max):
    self._min = min if min > 1 else 1
    self._max = max if max > self._min else self._min
    
  def get_min(self):
    return self._min
    
  def get_max(self):
    return self._max

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
