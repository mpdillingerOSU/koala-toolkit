import 'package:gaming_toolkit/koala_toolkit_back_end/sorters/sorter.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/utility.dart';

import '../../koala_strings.dart';
import '../battle_effect.dart';
import '../move_element.dart';
import '../data/moves/move.dart';
import '../move_type.dart';

class MoveSorter {
  late MoveSortType type;
  late SortDirection direction;

  MoveSorter({
    this.type = MoveSortType.moveNum,
    this.direction = SortDirection.ascending,
  });

  List<Move> sort(List<Move> moves) {
    List<Move> sortedMoves = [...moves];
    subsort(sortedMoves, 0, moves.length - 1);
    return direction == SortDirection.ascending
        ? sortedMoves
        : sortedMoves.reversed.toList();
  }

  void subsort(List<Move> moves, int l, int r) {
    if (l < r) {
      int m = l + ((r - l) ~/ 2);
      subsort(moves, l, m);
      subsort(moves, m + 1, r);
      merge(moves, l, m, r);
    }
  }

  void merge(List<Move> moves, int l, int m, int r) {
    int n1 = m - l + 1;
    List<Move> L = [];
    for (int i = 0; i < n1; ++i) {
      L.add(moves[l + i]);
    }

    int n2 = r - m;
    List<Move> R = [];
    for (int j = 0; j < n2; ++j) {
      R.add(moves[m + 1 + j]);
    }

    int i = 0, j = 0;

    int k = l;
    while (i < n1 && j < n2) {
      if (type.compared(L[i], R[j])) {
        moves[k] = L[i];
        i++;
      } else {
        moves[k] = R[j];
        j++;
      }
      k++;
    }

    while (i < n1) {
      moves[k] = L[i];
      i++;
      k++;
    }

    while (j < n2) {
      moves[k] = R[j];
      j++;
      k++;
    }
  }

  void flipDirection() {
    direction = direction == SortDirection.ascending
        ? SortDirection.descending
        : SortDirection.ascending;
  }
}

enum MoveSortType {
  moveNum('Move Number', MoveFields.moveNum, _compareMoveNum),
  moveName('Move Name', MoveFields.name, _compareName),
  element('Element', MoveFields.element, _compareElement),
  moveType('Move Type', MoveFields.moveType, _compareMoveType),
  energyCost('Energy Cost', MoveFields.energyCost, _compareEnergyCost),
  powerMin('Power Min', MoveFields.powerMin, _comparePowerMin),
  powerMedian('Power Median', '', _comparePowerMedian),
  powerMax('Power Max', MoveFields.powerMax, _comparePowerMax),
  range('Range', MoveFields.rangeMax, _compareRange),
  accuracy('Accuracy', MoveFields.accuracy, _compareAccuracy),
  knockback('Knockback', MoveFields.knockbackValue, _compareKnockback),
  lunge('Lunge', MoveFields.lungeValue, _compareLunge),
  utility('Utility', MoveFields.utilityType, _compareUtility),
  multiHit('Multi-Hit', MoveFields.multiHitValue, _compareMultiHit),
  pull('Pull', MoveFields.pullValue, _comparePull),
  battleEffect('Battle Effect', MoveFields.battleEffectType, _compareBattleEffect),
  bounceback('Bounceback', MoveFields.bouncebackValue, _compareBounceback),
  recoilMin('Recoil Min', MoveFields.recoilMin, _compareRecoilMin),
  recoilMedian('Recoil Median', '', _compareRecoilMedian),
  recoilMax('Recoil Max', MoveFields.recoilMax, _compareRecoilMax),
  cooldown('Cooldown', MoveFields.cooldownValue, _compareCooldown),
  sideEffect('Side Effect', MoveFields.sideEffectType, _compareSideEffect),
  crashDamageMin('Crash Damage Min', MoveFields.crashDamageMin, _compareCrashDamageMin),
  crashDamageMedian('Crash Damage Median', '', _compareCrashDamageMedian),
  crashDamageMax('Crash Damage Max', MoveFields.crashDamageMax, _compareCrashDamageMax);

  final String name;
  final String moveField;
  final bool Function(Move, Move) compared;

  const MoveSortType(this.name, this.moveField, this.compared);

  @override
  String toString() => name;

  static bool _compareMoveNum(Move l, Move r) => l.moveNum <= r.moveNum;

  static bool _compareName(Move l, Move r) =>
      asLowercaseAlphanumeric(l.name).compareTo(asLowercaseAlphanumeric(r.name)) <= 0;

  static bool _compareElement(Move l, Move r) =>
      (MoveElement.ordinalOf(l.element) ?? -1) <=
      (MoveElement.ordinalOf(r.element) ?? -1);

  static bool _compareMoveType(Move l, Move r) =>
      (MoveType.ordinalOf(l.moveType) ?? -1) <=
      (MoveType.ordinalOf(r.moveType) ?? -1);

  static bool _compareEnergyCost(Move l, Move r) =>
      l.energyCost <= r.energyCost;

  static bool _comparePowerMin(Move l, Move r) => l.powerMin <= r.powerMin;

  static bool _comparePowerMedian(Move l, Move r) =>
      (l.powerMin + l.powerMax) <= (r.powerMin + r.powerMax);

  static bool _comparePowerMax(Move l, Move r) => l.powerMax <= r.powerMax;

  static bool _compareRange(Move l, Move r) => l.rangeMax <= r.rangeMax;

  static bool _compareAccuracy(Move l, Move r) => l.accuracy <= r.accuracy;

  static bool _compareKnockback(Move l, Move r) =>
      l.knockbackValue <= r.knockbackValue;

  static bool _compareLunge(Move l, Move r) => l.lungeValue <= r.lungeValue;

  static bool _compareUtility(Move l, Move r) =>
      (Utility.ordinalOf(l.utilityType) ?? -1) <=
      (Utility.ordinalOf(r.utilityType) ?? -1);

  static bool _compareMultiHit(Move l, Move r) =>
      l.multiHitValue <= r.multiHitValue;

  static bool _comparePull(Move l, Move r) => l.pullValue <= r.pullValue;

  static bool _compareBattleEffect(Move l, Move r) =>
      (BattleEffect.ordinalOf(l.battleEffectType) ?? -1) <=
      (BattleEffect.ordinalOf(r.battleEffectType) ?? -1);

  static bool _compareBounceback(Move l, Move r) =>
      l.bouncebackValue <= r.bouncebackValue;

  static bool _compareRecoilMin(Move l, Move r) => l.recoilMin <= r.recoilMin;

  static bool _compareRecoilMedian(Move l, Move r) =>
      (l.recoilMin + l.recoilMax) <= (r.recoilMin + r.recoilMax);

  static bool _compareRecoilMax(Move l, Move r) => l.recoilMax <= r.recoilMax;

  static bool _compareCooldown(Move l, Move r) =>
      l.cooldownValue <= r.cooldownValue;

  static bool _compareSideEffect(Move l, Move r) =>
      (BattleEffect.ordinalOf(l.sideEffectType) ?? -1) <=
      (BattleEffect.ordinalOf(r.sideEffectType) ?? -1);

  static bool _compareCrashDamageMin(Move l, Move r) =>
      l.crashDamageMin <= r.crashDamageMin;

  static bool _compareCrashDamageMedian(Move l, Move r) =>
      (l.crashDamageMin + l.crashDamageMax) <=
      (r.crashDamageMin + r.crashDamageMax);

  static bool _compareCrashDamageMax(Move l, Move r) =>
      l.crashDamageMax <= r.crashDamageMax;

  static List<String> allNames() {
    List<String> names = [];
    for (MoveSortType sort in values) {
      names.add(sort.name);
    }
    return names;
  }
}
