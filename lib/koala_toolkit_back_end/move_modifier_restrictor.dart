import 'data/moves/move.dart';
import 'move_modifier.dart';

class MoveModifierRestrictor {
  Map<MoveModifier, RestrictionPair> _restrictions = {};

  Map<MoveModifier, RestrictionPair> get restrictions => {..._restrictions};

  void _add(MoveModifier modifier, String reason){
    if(_restrictions[modifier] == null) _restrictions[modifier] = RestrictionPair(modifier);
    _restrictions[modifier]?._addReason(reason);
  }

  MoveModifierRestrictor(Move move){
    for(MoveModifier modifier in MoveModifier.values){
      if(move.has(modifier)){
        _add(modifier, 'The move already uses the $modifier modifier.');
      }
      if(modifier == MoveModifier.compoundingPower){
        if(!move.hasPower){
          _add(modifier, 'The move has a Move Type of ${move.moveType}, which does not have Power.');
        }
        if(move.has(MoveModifier.deprecatingPower)){
          _add(modifier, 'The move already uses the ${MoveModifier.deprecatingPower} modifier, and cannot have both ${MoveModifier.compoundingPower} and ${MoveModifier.deprecatingPower}.');
        }
      } else if(modifier == MoveModifier.deprecatingPower){
        if(!
        move.hasPower){
          _add(modifier, 'The move has a Move Type of ${move.moveType}, which does not have Power.');
        }
        if(move.has(MoveModifier.compoundingPower)){
          _add(modifier, 'The move already uses the ${MoveModifier.compoundingPower} modifier, and cannot have both ${MoveModifier.compoundingPower} and ${MoveModifier.deprecatingPower}.');
        }
      }
    }
  }
}

class RestrictionPair {
  final MoveModifier modifier;
  List<String> _reasons = [];

  RestrictionPair(this.modifier);

  _addReason(String reason){
    _reasons.add(reason);
  }

  List<String> get reasons => [..._reasons];
}