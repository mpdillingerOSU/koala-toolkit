import 'package:gaming_toolkit/koala_strings.dart';

import '../../components/range.dart';
import '../battle_effect.dart';
import '../move_element.dart';
import '../forced_movement_type.dart';
import '../modifier_move_timing.dart';
import '../data/moves/move.dart';
import '../move_type.dart';
import '../utility.dart';

class MoveFilter {
  String searchTerm = '';
  List<String>? _elementFilters;
  List<String>? _moveTypeFilters;
  Range? _energyCostFilter;
  bool? _hasPowerFilter;
  Range? _powerMinFilter;
  Range? _powerMaxFilter;
  Range? _rangeFilter;
  Range? _accuracyFilter;
  bool? _hasKnockbackFilter;
  Range? _knockbackValueFilter;
  bool? _knockbackAirborneFilter;
  List<String>? _knockbackTypeFilters;
  bool? _hasLungeFilter;
  Range? _lungeValueFilter;
  bool? _lungeAirborneFilter;
  bool? _hasLOSFilter;
  bool? _hasRangeBoostableFilter;
  bool? _hasDirectContactFilter;
  bool? _hasUtilityFilter;
  List<String>? _utilityFilters;
  bool? _hasCompoundingPowerFilter;
  bool? _hasDeprecatingPowerFilter;
  bool? _hasMultiHitFilter;
  Range? _multiHitValueFilter;
  bool? _hasPullFilter;
  Range? _pullValueFilter;
  bool? _pullAirborneFilter;
  List<String>? _pullPriorityFilters;
  List<String>? _pullTypeFilters;
  bool? _hasBattleEffectFilter;
  List<String>? _battleEffectFilters;
  bool? _hasBouncebackFilter;
  Range? _bouncebackValueFilter;
  bool? _bouncebackAirborneFilter;
  List<String>? _bouncebackPriorityFilters;
  bool? _hasRecoilFilter;
  Range? _recoilMinFilter;
  Range? _recoilMaxFilter;
  bool? _hasCooldownFilter;
  Range? _cooldownValueFilter;
  bool? _hasSideEffectFilter;
  List<String>? _sideEffectFilters;
  bool? _hasCrashDamageFilter;
  Range? _crashDamageMinFilter;
  Range? _crashDamageMaxFilter;

  List<String>? get elementFilters =>
      _elementFilters == null ? null : [...?_elementFilters];
  List<String>? get moveTypeFilters =>
      _moveTypeFilters == null ? null : [...?_moveTypeFilters];
  Range? get energyCostFilter => _energyCostFilter;
  bool? get hasPowerFilter => _hasPowerFilter;
  Range? get powerMinFilter => _powerMinFilter;
  Range? get powerMaxFilter => _powerMaxFilter;
  Range? get rangeFilter => _rangeFilter;
  Range? get accuracyFilter => _accuracyFilter;
  bool? get hasKnockbackFilter => _hasKnockbackFilter;
  Range? get knockbackValueFilter => _knockbackValueFilter;
  bool? get knockbackAirborneFilter => _knockbackAirborneFilter;
  List<String>? get knockbackTypeFilters =>
      _knockbackTypeFilters == null ? null : [...?_knockbackTypeFilters];
  bool? get hasLungeFilter => _hasLungeFilter;
  Range? get lungeValueFilter => _lungeValueFilter;
  bool? get lungeAirborneFilter => _lungeAirborneFilter;
  bool? get hasLOSFilter => _hasLOSFilter;
  bool? get hasRangeBoostableFilter => _hasRangeBoostableFilter;
  bool? get hasDirectContactFilter => _hasDirectContactFilter;
  bool? get hasUtilityFilter => _hasUtilityFilter;
  List<String>? get utilityFilters =>
      _utilityFilters == null ? null : [...?_utilityFilters];
  bool? get hasCompoundingPowerFilter => _hasCompoundingPowerFilter;
  bool? get hasDeprecatingPowerFilter => _hasDeprecatingPowerFilter;
  bool? get hasMultiHitFilter => _hasMultiHitFilter;
  Range? get multiHitValueFilter => _multiHitValueFilter;
  bool? get hasPullFilter => _hasPullFilter;
  Range? get pullValueFilter => _pullValueFilter;
  bool? get pullAirborneFilter => _pullAirborneFilter;
  List<String>? get pullPriorityFilters =>
      _pullPriorityFilters == null ? null : [...?_pullPriorityFilters];
  List<String>? get pullTypeFilters =>
      _pullTypeFilters == null ? null : [...?_pullTypeFilters];
  bool? get hasBattleEffectFilter => _hasBattleEffectFilter;
  List<String>? get battleEffectFilters =>
      _battleEffectFilters == null ? null : [...?_battleEffectFilters];
  bool? get hasBouncebackFilter => _hasBouncebackFilter;
  Range? get bouncebackValueFilter => _bouncebackValueFilter;
  bool? get bouncebackAirborneFilter => _bouncebackAirborneFilter;
  List<String>? get bouncebackPriorityFilters =>
      _bouncebackPriorityFilters == null ? null : [...?_bouncebackPriorityFilters];
  bool? get hasRecoilFilter => _hasRecoilFilter;
  Range? get recoilMinFilter => _recoilMinFilter;
  Range? get recoilMaxFilter => _recoilMaxFilter;
  bool? get hasCooldownFilter => _hasCooldownFilter;
  Range? get cooldownValueFilter => _cooldownValueFilter;
  bool? get hasSideEffectFilter => _hasSideEffectFilter;
  List<String>? get sideEffectFilters =>
      _sideEffectFilters == null ? null : [...?_sideEffectFilters];
  bool? get hasCrashDamageFilter => _hasCrashDamageFilter;
  Range? get crashDamageMinFilter => _crashDamageMinFilter;
  Range? get crashDamageMaxFilter => _crashDamageMaxFilter;

  List<Move> apply(List<Move> moves) {
    List<Move> filteredMoves = [];

    for (Move move in moves) {
      if(!hasSubsequence(asLowercaseAlphanumeric(move.name), asLowercaseAlphanumeric(searchTerm))){
        continue;
      }

      if (_elementFilters != null && !_elementFilters!.contains(move.element)) {
        continue;
      }

      if (_moveTypeFilters != null &&
          !_moveTypeFilters!.contains(move.moveType)) {
        continue;
      }

      if (_energyCostFilter != null &&
          !_energyCostFilter!.contains(move.energyCost)) {
        continue;
      }

      if (_hasPowerFilter != null) {
        if (move.hasPower != _hasPowerFilter) {
          continue;
        }
        if (_hasPowerFilter!) {
          if (_powerMinFilter != null &&
              !_powerMinFilter!.contains(move.powerMin)) {
            continue;
          }
          if (_powerMaxFilter != null &&
              !_powerMaxFilter!.contains(move.powerMax)) {
            continue;
          }
        }
      }

      if (_rangeFilter != null && !_rangeFilter!.contains(move.rangeMax)) {
        continue;
      }

      if (_accuracyFilter != null &&
          !_accuracyFilter!.contains(move.accuracy)) {
        continue;
      }

      if (_hasKnockbackFilter != null) {
        if (move.hasKnockback != _hasKnockbackFilter) {
          continue;
        }
        if (_hasKnockbackFilter!) {
          if (_knockbackValueFilter != null &&
              !_knockbackValueFilter!.contains(move.knockbackValue)) {
            continue;
          }
          if (_knockbackAirborneFilter != null &&
              _knockbackAirborneFilter != move.isKnockbackAirborne) {
            continue;
          }
          if (_knockbackTypeFilters != null &&
              !_knockbackTypeFilters!.contains(move.knockbackType)) {
            continue;
          }
        }
      }

      if (_hasLungeFilter != null) {
        if (move.hasLunge != _hasLungeFilter) {
          continue;
        }
        if (_hasLungeFilter!) {
          if (_lungeValueFilter != null &&
              !_lungeValueFilter!.contains(move.lungeValue)) {
            continue;
          }
          if (_lungeAirborneFilter != null &&
              _lungeAirborneFilter != move.isLungeAirborne) {
            continue;
          }
        }
      }

      if (_hasLOSFilter != null && _hasLOSFilter != move.hasLOS) {
        continue;
      }

      if (_hasRangeBoostableFilter != null &&
          _hasRangeBoostableFilter != move.isRangeBoostable) {
        continue;
      }

      if (_hasDirectContactFilter != null &&
          _hasDirectContactFilter != move.hasDirectContact) {
        continue;
      }

      if (_hasUtilityFilter != null) {
        if (move.hasUtility != _hasUtilityFilter) {
          continue;
        }
        if (_hasUtilityFilter!) {
          if (_utilityFilters != null &&
              !_utilityFilters!.contains(move.utilityType)) {
            continue;
          }
        }
      }

      if (_hasCompoundingPowerFilter != null &&
          _hasCompoundingPowerFilter != move.hasCompoundingPower) {
        continue;
      }

      if (_hasDeprecatingPowerFilter != null &&
          _hasDeprecatingPowerFilter != move.hasDeprecatingPower) {
        continue;
      }

      if (_hasMultiHitFilter != null) {
        if (move.hasMultiHit != _hasMultiHitFilter) {
          continue;
        }
        if (_hasMultiHitFilter!) {
          if (_multiHitValueFilter != null &&
              !_multiHitValueFilter!.contains(move.multiHitValue)) {
            continue;
          }
        }
      }

      if (_hasPullFilter != null) {
        if (move.hasPull != _hasPullFilter) {
          continue;
        }
        if (_hasPullFilter!) {
          if (_pullValueFilter != null &&
              !_pullValueFilter!.contains(move.pullValue)) {
            continue;
          }
          if (_pullAirborneFilter != null &&
              _pullAirborneFilter != move.isPullAirborne) {
            continue;
          }
          if (_pullPriorityFilters != null &&
              !_pullPriorityFilters!.contains(move.pullPriority)) {
            continue;
          }
          if (_pullTypeFilters != null &&
              !_pullTypeFilters!.contains(move.pullType)) {
            continue;
          }
        }
      }

      if (_hasBattleEffectFilter != null) {
        if (move.hasBattleEffect != _hasBattleEffectFilter) {
          continue;
        }
        if (_hasBattleEffectFilter!) {
          if (_battleEffectFilters != null &&
              !_battleEffectFilters!.contains(move.battleEffectType)) {
            continue;
          }
        }
      }

      if (_hasBouncebackFilter != null) {
        if (move.hasBounceback != _hasBouncebackFilter) {
          continue;
        }
        if (_hasBouncebackFilter!) {
          if (_bouncebackValueFilter != null &&
              !_bouncebackValueFilter!.contains(move.bouncebackValue)) {
            continue;
          }
          if (_bouncebackAirborneFilter != null &&
              _bouncebackAirborneFilter != move.isBouncebackAirborne) {
            continue;
          }
          if (_bouncebackPriorityFilters != null &&
              !_bouncebackPriorityFilters!.contains(move.bouncebackPriority)) {
            continue;
          }
        }
      }

      if (_hasRecoilFilter != null) {
        if (move.hasRecoil != _hasRecoilFilter) {
          continue;
        }
        if (_hasRecoilFilter!) {
          if (_recoilMinFilter != null &&
              !_recoilMinFilter!.contains(move.recoilMin)) {
            continue;
          }
          if (_recoilMaxFilter != null &&
              !_recoilMaxFilter!.contains(move.recoilMax)) {
            continue;
          }
        }
      }

      if (_hasCooldownFilter != null) {
        if (move.hasCooldown != _hasCooldownFilter) {
          continue;
        }
        if (_hasCooldownFilter!) {
          if (_cooldownValueFilter != null &&
              !_cooldownValueFilter!.contains(move.cooldownValue)) {
            continue;
          }
        }
      }

      if (_hasSideEffectFilter != null) {
        if (move.hasSideEffect != _hasSideEffectFilter) {
          continue;
        }
        if (_hasSideEffectFilter!) {
          if (_sideEffectFilters != null &&
              !_sideEffectFilters!.contains(move.sideEffectType)) {
            continue;
          }
        }
      }

      if (_hasCrashDamageFilter != null) {
        if (move.hasCrashDamage != _hasCrashDamageFilter) {
          continue;
        }
        if (_hasCrashDamageFilter!) {
          if (_crashDamageMinFilter != null &&
              !_crashDamageMinFilter!.contains(move.crashDamageMin)) {
            continue;
          }
          if (_crashDamageMaxFilter != null &&
              !_crashDamageMaxFilter!.contains(move.crashDamageMax)) {
            continue;
          }
        }
      }

      filteredMoves.add(move);
    }

    return filteredMoves;
  }

  void addElementFilter(String element) {
    if (MoveElement.allNames().contains(element)) {
      _elementFilters == null
          ? _elementFilters = [element]
          : _elementFilters?.add(element);
    }
  }

  void removeElementFilter(String element) => _elementFilters?.remove(element);

  void applyAllElementFilters() {
    _elementFilters = MoveElement.allNames();
  }

  void clearElementFilters() => _elementFilters = null;

  void addMoveTypeFilter(String moveType) {
    if (MoveType.allNames().contains(moveType)) {
      _moveTypeFilters == null
          ? _moveTypeFilters = [moveType]
          : _moveTypeFilters?.add(moveType);
    }
  }

  void removeMoveTypeFilter(String moveType) =>
      _moveTypeFilters?.remove(moveType);

  void applyAllMoveTypeFilters() {
    _moveTypeFilters = MoveType.allNames();
  }

  void clearMoveTypeFilters() => _moveTypeFilters = null;

  void setEnergyCostFilter(Range? comparative) =>
      _energyCostFilter = comparative;

  void clearEnergyCostFilter() => _energyCostFilter = null;

  void setHasPowerFilter(bool? value) =>
      value == null ? clearHasPowerFilter() : _hasPowerFilter = value;

  void clearHasPowerFilter() {
    _hasPowerFilter = null;
    clearPowerMinFilter();
    clearPowerMaxFilter();
  }

  void setPowerMinFilter(Range? comparative) =>
      _powerMinFilter = comparative;

  void clearPowerMinFilter() => _powerMinFilter = null;

  void setPowerMaxFilter(Range? comparative) =>
      _powerMaxFilter = comparative;

  void clearPowerMaxFilter() => _powerMaxFilter = null;

  void setRangeFilter(Range? comparative) =>
      _rangeFilter = comparative;

  void clearRangeFilter() => _rangeFilter = null;

  void setAccuracyFilter(Range? comparative) =>
      _accuracyFilter = comparative;

  void clearAccuracyFilter() => _accuracyFilter = null;

  void setHasKnockbackFilter(bool? value) =>
      value == null ? clearHasKnockbackFilter() : _hasKnockbackFilter = value;

  void clearHasKnockbackFilter() {
    _hasKnockbackFilter = null;
    clearKnockbackValueFilter();
    clearKnockbackAirborneFilter();
    clearKnockbackTypeFilters();
  }

  void setKnockbackValueFilter(Range? comparative) =>
      _knockbackValueFilter = comparative;

  void clearKnockbackValueFilter() => _knockbackValueFilter = null;

  void setKnockbackAirborneFilter(bool? value) =>
      _knockbackAirborneFilter = value;

  void clearKnockbackAirborneFilter() => _knockbackAirborneFilter = null;

  void addKnockbackTypeFilter(String knockbackType) {
    if (ForcedMovementType.allNames().contains(knockbackType)) {
      _knockbackTypeFilters == null
          ? _knockbackTypeFilters = [knockbackType]
          : _knockbackTypeFilters?.add(knockbackType);
    }
  }

  void removeKnockbackTypeFilter(String knockbackType) =>
      _knockbackTypeFilters?.remove(knockbackType);

  void applyAllKnockbackTypeFilters() {
    _knockbackTypeFilters = ForcedMovementType.allNames();
  }

  void clearKnockbackTypeFilters() => _knockbackTypeFilters = null;

  void setHasLungeFilter(bool? value) =>
      value == null ? clearHasLungeFilter() : _hasLungeFilter = value;

  void clearHasLungeFilter() {
    _hasLungeFilter = null;
    clearLungeValueFilter();
    clearLungeAirborneFilter();
  }

  void setLungeValueFilter(Range? comparative) =>
      _lungeValueFilter = comparative;

  void clearLungeValueFilter() => _lungeValueFilter = null;

  void setLungeAirborneFilter(bool? value) => _lungeAirborneFilter = value;

  void clearLungeAirborneFilter() => _lungeAirborneFilter = null;

  void setHasLOSFilter(bool? value) =>
      value == null ? clearHasLOSFilter() : _hasLOSFilter = value;

  void clearHasLOSFilter() => _hasLOSFilter = null;

  void setHasRangeBoostableFilter(bool? value) => value == null
      ? clearHasRangeBoostableFilter()
      : _hasRangeBoostableFilter = value;

  void clearHasRangeBoostableFilter() => _hasRangeBoostableFilter = null;

  void setHasDirectContactFilter(bool? value) => value == null
      ? clearHasDirectContactFilter()
      : _hasDirectContactFilter = value;

  void clearHasDirectContactFilter() => _hasDirectContactFilter = null;

  void setHasUtilityFilter(bool? value) =>
      value == null ? clearHasUtilityFilter() : _hasUtilityFilter = value;

  void clearHasUtilityFilter() {
    _hasUtilityFilter = null;
    clearUtilityFilters();
  }

  void addUtilityFilter(String utility) {
    if (Utility.allNames().contains(utility)) {
      _utilityFilters == null
          ? _utilityFilters = [utility]
          : _utilityFilters?.add(utility);
    }
  }

  void removeUtilityFilter(String utility) => _utilityFilters?.remove(utility);

  void applyAllUtilityFilters() {
    _utilityFilters = Utility.allNames();
  }

  void clearUtilityFilters() => _utilityFilters = null;

  void setHasCompoundingPowerFilter(bool? value) => value == null
      ? clearHasCompoundingPowerFilter()
      : _hasCompoundingPowerFilter = value;

  void clearHasCompoundingPowerFilter() => _hasCompoundingPowerFilter = null;

  void setHasDeprecatingPowerFilter(bool? value) => value == null
      ? clearHasDeprecatingPowerFilter()
      : _hasDeprecatingPowerFilter = value;

  void clearHasDeprecatingPowerFilter() => _hasDeprecatingPowerFilter = null;

  void setHasMultiHitFilter(bool? value) =>
      value == null ? clearHasMultiHitFilter() : _hasMultiHitFilter = value;

  void clearHasMultiHitFilter() {
    _hasMultiHitFilter = null;
    clearMultiHitValueFilter();
  }

  void setMultiHitValueFilter(Range? comparative) =>
      _multiHitValueFilter = comparative;

  void clearMultiHitValueFilter() => _multiHitValueFilter = null;

  void setHasPullFilter(bool? value) =>
      value == null ? clearHasPullFilter() : _hasPullFilter = value;

  void clearHasPullFilter() {
    _hasPullFilter = null;
    clearPullValueFilter();
    clearPullAirborneFilter();
    clearPullPriorityFilters();
    clearPullTypeFilters();
  }

  void setPullValueFilter(Range? comparative) =>
      _pullValueFilter = comparative;

  void clearPullValueFilter() => _pullValueFilter = null;

  void setPullAirborneFilter(bool? value) => _pullAirborneFilter = value;

  void clearPullAirborneFilter() => _pullAirborneFilter = null;

  void addPullPriorityFilter(String pullPriority) {
    if (Priority.allNames().contains(pullPriority)) {
      _pullPriorityFilters == null
          ? _pullPriorityFilters = [pullPriority]
          : _pullPriorityFilters?.add(pullPriority);
    }
  }

  void removePullPriorityFilter(String pullPriority) =>
      _pullPriorityFilters?.remove(pullPriority);

  void applyAllPullPriorityFilters() {
    _pullPriorityFilters = Priority.allNames();
  }

  void clearPullPriorityFilters() => _pullPriorityFilters = null;

  void addPullTypeFilter(String pullType) {
    if (ForcedMovementType.allNames().contains(pullType)) {
      _pullTypeFilters == null
          ? _pullTypeFilters = [pullType]
          : _pullTypeFilters?.add(pullType);
    }
  }

  void removePullTypeFilter(String pullType) =>
      _pullTypeFilters?.remove(pullType);

  void applyAllPullTypeFilters() {
    _pullTypeFilters = ForcedMovementType.allNames();
  }

  void clearPullTypeFilters() => _pullTypeFilters = null;

  void setHasBattleEffectFilter(bool? value) => value == null
      ? clearHasBattleEffectFilter()
      : _hasBattleEffectFilter = value;

  void clearHasBattleEffectFilter() {
    _hasBattleEffectFilter = null;
    clearBattleEffectFilters();
  }

  void addBattleEffectFilter(String battleEffect) {
    if (BattleEffect.allNames().contains(battleEffect)) {
      _battleEffectFilters == null
          ? _battleEffectFilters = [battleEffect]
          : _battleEffectFilters?.add(battleEffect);
    }
  }

  void removeBattleEffectFilter(String battleEffect) =>
      _battleEffectFilters?.remove(battleEffect);

  void applyAllBattleEffectFilters() {
    _battleEffectFilters = BattleEffect.allNames();
  }

  void clearBattleEffectFilters() => _battleEffectFilters = null;

  void setHasBouncebackFilter(bool? value) =>
      value == null ? clearHasBouncebackFilter() : _hasBouncebackFilter = value;

  void clearHasBouncebackFilter() {
    _hasBouncebackFilter = null;
    clearBouncebackValueFilter();
    clearBouncebackAirborneFilter();
    clearBouncebackPriorityFilters();
  }

  void setBouncebackValueFilter(Range? comparative) =>
      _bouncebackValueFilter = comparative;

  void clearBouncebackValueFilter() => _bouncebackValueFilter = null;

  void setBouncebackAirborneFilter(bool? value) =>
      _bouncebackAirborneFilter = value;

  void clearBouncebackAirborneFilter() => _bouncebackAirborneFilter = null;

  void addBouncebackPriorityFilter(String bouncebackPriority) {
    if (Priority.allNames().contains(bouncebackPriority)) {
      _bouncebackPriorityFilters == null
          ? _bouncebackPriorityFilters = [bouncebackPriority]
          : _bouncebackPriorityFilters?.add(bouncebackPriority);
    }
  }

  void removeBouncebackPriorityFilter(String bouncebackPriority) =>
      _bouncebackPriorityFilters?.remove(bouncebackPriority);

  void applyAllBouncebackPriorityFilters() {
    _bouncebackPriorityFilters = Priority.allNames();
  }

  void clearBouncebackPriorityFilters() => _bouncebackPriorityFilters = null;

  void setHasRecoilFilter(bool? value) =>
      value == null ? clearHasRecoilFilter() : _hasRecoilFilter = value;

  void clearHasRecoilFilter() {
    _hasRecoilFilter = null;
    clearRecoilMinFilter();
    clearRecoilMaxFilter();
  }

  void setRecoilMinFilter(Range? comparative) =>
      _recoilMinFilter = comparative;

  void clearRecoilMinFilter() => _recoilMinFilter = null;

  void setRecoilMaxFilter(Range? comparative) =>
      _recoilMaxFilter = comparative;

  void clearRecoilMaxFilter() => _recoilMaxFilter = null;

  void setHasCooldownFilter(bool? value) =>
      value == null ? clearHasCooldownFilter() : _hasCooldownFilter = value;

  void clearHasCooldownFilter() {
    _hasCooldownFilter = null;
    clearCooldownValueFilter();
  }

  void setCooldownValueFilter(Range? comparative) =>
      _cooldownValueFilter = comparative;

  void clearCooldownValueFilter() => _cooldownValueFilter = null;

  void setHasSideEffectFilter(bool? value) =>
      value == null ? clearHasSideEffectFilter() : _hasSideEffectFilter = value;

  void clearHasSideEffectFilter() {
    _hasSideEffectFilter = null;
    clearSideEffectFilters();
  }

  void addSideEffectFilter(String sideEffect) {
    if (BattleEffect.allNames().contains(sideEffect)) {
      _sideEffectFilters == null
          ? _sideEffectFilters = [sideEffect]
          : _sideEffectFilters?.add(sideEffect);
    }
  }

  void removeSideEffectFilter(String sideEffect) =>
      _sideEffectFilters?.remove(sideEffect);

  void applyAllSideEffectFilters() {
    _sideEffectFilters = BattleEffect.allNames();
  }

  void clearSideEffectFilters() => _sideEffectFilters = null;

  void setHasCrashDamageFilter(bool? value) => value == null
      ? clearHasCrashDamageFilter()
      : _hasCrashDamageFilter = value;

  void clearHasCrashDamageFilter() {
    _hasCrashDamageFilter = null;
    clearCrashDamageMinFilter();
    clearCrashDamageMaxFilter();
  }

  void setCrashDamageMinFilter(Range? comparative) =>
      _crashDamageMinFilter = comparative;

  void clearCrashDamageMinFilter() => _crashDamageMinFilter = null;

  void setCrashDamageMaxFilter(Range? comparative) =>
      _crashDamageMaxFilter = comparative;

  void clearCrashDamageMaxFilter() => _crashDamageMaxFilter = null;

  void clearAll() {
    _elementFilters = null;
    _moveTypeFilters = null;
    _energyCostFilter = null;
    _hasPowerFilter = null;
    _powerMinFilter = null;
    _powerMaxFilter = null;
    _rangeFilter = null;
    _accuracyFilter = null;
    _hasKnockbackFilter = null;
    _knockbackValueFilter = null;
    _knockbackAirborneFilter = null;
    _knockbackTypeFilters = null;
    _hasLungeFilter = null;
    _lungeValueFilter = null;
    _lungeAirborneFilter = null;
    _hasLOSFilter = null;
    _hasRangeBoostableFilter = null;
    _hasDirectContactFilter = null;
    _hasUtilityFilter = null;
    _utilityFilters = null;
    _hasCompoundingPowerFilter = null;
    _hasDeprecatingPowerFilter = null;
    _hasMultiHitFilter = null;
    _multiHitValueFilter = null;
    _hasPullFilter = null;
    _pullValueFilter = null;
    _pullAirborneFilter = null;
    _pullPriorityFilters = null;
    _pullTypeFilters = null;
    _hasBattleEffectFilter = null;
    _battleEffectFilters = null;
    _hasBouncebackFilter = null;
    _bouncebackValueFilter = null;
    _bouncebackAirborneFilter = null;
    _bouncebackPriorityFilters = null;
    _hasRecoilFilter = null;
    _recoilMinFilter = null;
    _recoilMaxFilter = null;
    _hasCooldownFilter = null;
    _cooldownValueFilter = null;
    _hasSideEffectFilter = null;
    _sideEffectFilters = null;
    _hasCrashDamageFilter = null;
    _crashDamageMinFilter = null;
    _crashDamageMaxFilter = null;
  }

  void setEqualTo(MoveFilter other) {
    searchTerm = other.searchTerm;
    _elementFilters =
        other._elementFilters == null ? null : [...?other._elementFilters];
    _moveTypeFilters =
        other._moveTypeFilters == null ? null : [...?other._moveTypeFilters];
    _energyCostFilter = other._energyCostFilter;
    _hasPowerFilter = other._hasPowerFilter;
    _powerMinFilter = other._powerMinFilter;
    _powerMaxFilter = other._powerMaxFilter;
    _rangeFilter = other._rangeFilter;
    _accuracyFilter = other._accuracyFilter;
    _hasKnockbackFilter = other._hasKnockbackFilter;
    _knockbackValueFilter = other._knockbackValueFilter;
    _knockbackAirborneFilter = other._knockbackAirborneFilter;
    _knockbackTypeFilters = other._knockbackTypeFilters == null
        ? null
        : [...?other._knockbackTypeFilters];
    _hasLungeFilter = other._hasLungeFilter;
    _lungeValueFilter = other._lungeValueFilter;
    _lungeAirborneFilter = other._lungeAirborneFilter;
    _hasLOSFilter = other._hasLOSFilter;
    _hasRangeBoostableFilter = other._hasRangeBoostableFilter;
    _hasDirectContactFilter = other._hasDirectContactFilter;
    _hasUtilityFilter = other._hasUtilityFilter;
    _utilityFilters =
        other._utilityFilters == null ? null : [...?other._utilityFilters];
    _hasCompoundingPowerFilter = other._hasCompoundingPowerFilter;
    _hasDeprecatingPowerFilter = other._hasDeprecatingPowerFilter;
    _hasMultiHitFilter = other._hasMultiHitFilter;
    _multiHitValueFilter = other._multiHitValueFilter;
    _hasPullFilter = other._hasPullFilter;
    _pullValueFilter = other._pullValueFilter;
    _pullAirborneFilter = other._pullAirborneFilter;
    _pullPriorityFilters =
        other._pullPriorityFilters == null ? null : [...?other._pullPriorityFilters];
    _pullTypeFilters =
        other._pullTypeFilters == null ? null : [...?other._pullTypeFilters];
    _hasBattleEffectFilter = other._hasBattleEffectFilter;
    _battleEffectFilters = other._battleEffectFilters == null
        ? null
        : [...?other._battleEffectFilters];
    _hasBouncebackFilter = other._hasBouncebackFilter;
    _bouncebackValueFilter = other._bouncebackValueFilter;
    _bouncebackAirborneFilter = other._bouncebackAirborneFilter;
    _bouncebackPriorityFilters = other._bouncebackPriorityFilters == null
        ? null
        : [...?other._bouncebackPriorityFilters];
    _hasRecoilFilter = other._hasRecoilFilter;
    _recoilMinFilter = other._recoilMinFilter;
    _recoilMaxFilter = other._recoilMaxFilter;
    _hasCooldownFilter = other._hasCooldownFilter;
    _cooldownValueFilter = other._cooldownValueFilter;
    _hasSideEffectFilter = other._hasSideEffectFilter;
    _sideEffectFilters = other._sideEffectFilters == null
        ? null
        : [...?other._sideEffectFilters];
    _hasCrashDamageFilter = other._hasCrashDamageFilter;
    _crashDamageMinFilter = other._crashDamageMinFilter;
    _crashDamageMaxFilter = other._crashDamageMaxFilter;
  }

  bool equals(MoveFilter comp) {
    return searchTerm == comp.searchTerm
        && _listsAreEqual(_elementFilters, comp._elementFilters)
        && _listsAreEqual(_moveTypeFilters, comp._moveTypeFilters)
        && _rangesAreEqual(_energyCostFilter, comp._energyCostFilter)
        && _hasPowerFilter == comp._hasPowerFilter
        && _rangesAreEqual(_powerMinFilter, comp._powerMinFilter)
        && _rangesAreEqual(_powerMaxFilter, comp._powerMaxFilter)
        && _rangesAreEqual(_rangeFilter, comp._rangeFilter)
        && _rangesAreEqual(_accuracyFilter, comp._accuracyFilter)
        && _hasKnockbackFilter == comp._hasKnockbackFilter
        && _rangesAreEqual(_knockbackValueFilter, comp._knockbackValueFilter)
        && _knockbackAirborneFilter == comp._knockbackAirborneFilter
        && _listsAreEqual(_knockbackTypeFilters , comp._knockbackTypeFilters)
        && _hasLungeFilter == comp._hasLungeFilter
        && _rangesAreEqual(_lungeValueFilter, comp._lungeValueFilter)
        && _lungeAirborneFilter == comp._lungeAirborneFilter
        && _hasLOSFilter == comp._hasLOSFilter
        && _hasRangeBoostableFilter == comp._hasRangeBoostableFilter
        && _hasDirectContactFilter == comp._hasDirectContactFilter
        && _hasUtilityFilter == comp._hasUtilityFilter
        && _listsAreEqual(_utilityFilters, comp._utilityFilters)
        && _hasCompoundingPowerFilter == comp._hasCompoundingPowerFilter
        && _hasDeprecatingPowerFilter == comp._hasDeprecatingPowerFilter
        && _hasMultiHitFilter == comp._hasMultiHitFilter
        && _rangesAreEqual(_multiHitValueFilter, comp._multiHitValueFilter)
        && _hasPullFilter == comp._hasPullFilter
        && _rangesAreEqual(_pullValueFilter, comp._pullValueFilter)
        && _pullAirborneFilter == comp._pullAirborneFilter
        && _listsAreEqual(_pullPriorityFilters, comp._pullPriorityFilters)
        && _listsAreEqual(_pullTypeFilters, comp._pullTypeFilters)
        && _hasBattleEffectFilter == comp._hasBattleEffectFilter
        && _listsAreEqual(_battleEffectFilters, comp._battleEffectFilters)
        && _hasBouncebackFilter == comp._hasBouncebackFilter
        && _rangesAreEqual(_bouncebackValueFilter, comp._bouncebackValueFilter)
        && _bouncebackAirborneFilter == comp._bouncebackAirborneFilter
        && _listsAreEqual(_bouncebackPriorityFilters, comp._bouncebackPriorityFilters)
        && _hasRecoilFilter == comp._hasRecoilFilter
        && _rangesAreEqual(_recoilMinFilter, comp._recoilMinFilter)
        && _rangesAreEqual(_recoilMaxFilter, comp._recoilMaxFilter)
        && _hasCooldownFilter == comp._hasCooldownFilter
        && _rangesAreEqual(_cooldownValueFilter, comp._cooldownValueFilter)
        && _hasSideEffectFilter == comp._hasSideEffectFilter
        && _listsAreEqual(_sideEffectFilters, comp._sideEffectFilters)
        && _hasCrashDamageFilter == comp._hasCrashDamageFilter
        && _rangesAreEqual(_crashDamageMinFilter, comp._crashDamageMinFilter)
        && _rangesAreEqual(_crashDamageMaxFilter, comp._crashDamageMaxFilter);
  }

  bool _listsAreEqual(List<String>? first, List<String>? second){
    if(first != null && second != null){
      if(first.length != second.length) return false;
      first = _asSet(first);
      second = _asSet(second);
      for(String element in first){
        if(!second.contains(element)){
          return false;
        }
      }
      return true;
    }
    ///The else if essentially returns whether both are null, as the if
    /// statement above already accounts for when both are not null. Thus, if
    /// first != second, then one is not null, and the lists are not equal.
    return first == second;
  }

  List<String> _asSet(List<String> list){
    List<String> temp = [];
    for(String element in list){
      if(!temp.contains(element)){
        temp.add(element);
      }
    }
    return temp;
  }

  bool _rangesAreEqual(Range? first, Range? second){
    ///Just as with [_listsAreEqual], the final [first == second], the LHS
    /// already accounts for when both are not null. Thus, if first != second,
    /// then one is not null, and the ranges are not equal.
    return first != null && second != null ? first.equals(second) : first == second;
  }
}
