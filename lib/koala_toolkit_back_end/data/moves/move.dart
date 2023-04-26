import '../../move_modifier.dart';
import '../koala_data_type.dart';

const String tableMoves = 'moves';

class MoveFields {
  MoveFields._();

  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String moveNum = 'moveNum';
  static const String element = 'element';
  static const String moveType = 'moveType';
  static const String energyCost = 'energyCost';
  static const String hasPower = 'hasPower';
  static const String powerMin = 'powerMin';
  static const String powerMax = 'powerMax';
  static const String rangeMin = 'rangeMin';
  static const String rangeMax = 'rangeMax';
  static const String accuracy = 'accuracy';
  static const String hasKnockback = 'hasKnockback';
  static const String knockbackValue = 'knockbackValue';
  static const String isKnockbackAirborne = 'isKnockbackAirborne';
  static const String knockbackType = 'knockbackType';
  static const String hasLunge = 'hasLunge';
  static const String lungeValue = 'lungeValue';
  static const String isLungeAirborne = 'isLungeAirborne';
  static const String hasLOSModifier = 'hasLOSModifier';
  static const String hasLOS = 'hasLOS';
  static const String hasRangeBoostableModifier = 'hasRangeBoostableModifier';
  static const String isRangeBoostable = 'isRangeBoostable';
  static const String hasDirectContactModifier = 'hasDirectContactModifier';
  static const String hasDirectContact = 'hasDirectContact';
  static const String hasUtility = 'hasUtility';
  static const String utilityType = 'utilityType';
  static const String hasCompoundingPowerModifier =
      'hasCompoundingPowerModifier';
  static const String hasCompoundingPower = 'hasCompoundingPower';
  static const String hasDeprecatingPowerModifier =
      'hasDeprecatingPowerModifier';
  static const String hasDeprecatingPower = 'hasDeprecatingPower';
  static const String hasMultiHit = 'hasMultiHit';
  static const String multiHitValue = 'multiHitValue';
  static const String hasPull = 'hasPull';
  static const String pullValue = 'pullValue';
  static const String isPullAirborne = 'isPullAirborne';
  static const String pullPriority = 'pullPriority';
  static const String pullType = 'pullType';
  static const String hasBattleEffect = 'hasBattleEffect';
  static const String battleEffectType = 'battleEffectType';
  static const String hasBounceback = 'hasBounceback';
  static const String bouncebackValue = 'bouncebackValue';
  static const String isBouncebackAirborne = 'isBouncebackAirborne';
  static const String bouncebackPriority = 'bouncebackPriority';
  static const String hasRecoil = 'hasRecoil';
  static const String recoilMin = 'recoilMin';
  static const String recoilMax = 'recoilMax';
  static const String hasCooldown = 'hasCooldown';
  static const String cooldownValue = 'cooldownValue';
  static const String hasSideEffect = 'hasSideEffect';
  static const String sideEffectType = 'sideEffectType';
  static const String hasCrashDamage = 'hasCrashDamage';
  static const String crashDamageMin = 'crashDamageMin';
  static const String crashDamageMax = 'crashDamageMax';

  static final List<String> values = [
    id,
    name,
    description,
    moveNum,
    element,
    moveType,
    energyCost,
    hasPower,
    powerMin,
    powerMax,
    rangeMin,
    rangeMax,
    accuracy,
    hasKnockback,
    knockbackValue,
    isKnockbackAirborne,
    knockbackType,
    hasLunge,
    lungeValue,
    isLungeAirborne,
    hasLOSModifier,
    hasLOS,
    hasRangeBoostableModifier,
    isRangeBoostable,
    hasDirectContactModifier,
    hasDirectContact,
    hasUtility,
    utilityType,
    hasCompoundingPowerModifier,
    hasCompoundingPower,
    hasDeprecatingPowerModifier,
    hasDeprecatingPower,
    hasMultiHit,
    multiHitValue,
    hasPull,
    pullValue,
    isPullAirborne,
    pullPriority,
    pullType,
    hasBattleEffect,
    battleEffectType,
    hasBounceback,
    bouncebackValue,
    isBouncebackAirborne,
    bouncebackPriority,
    hasRecoil,
    recoilMin,
    recoilMax,
    hasCooldown,
    cooldownValue,
    hasSideEffect,
    sideEffectType,
    hasCrashDamage,
    crashDamageMin,
    crashDamageMax,
  ];
}

class Move extends KoalaDataType {
  static const int? defaultID = null;
  static const String defaultName = 'unnamed';
  static const String defaultDescription = '';
  static const int defaultMoveNum = 1;
  static const String defaultElement = 'Neutral';
  static const String defaultMoveType = 'Physical';
  static const int defaultEnergyCost = 10;
  static const int defaultPowerMin = 0;
  static const int defaultPowerMax = 0;
  static const int defaultRangeMin = 1;
  static const int defaultRangeMax = 5;
  static const int defaultAccuracy = 100;
  static const bool defaultHasKnockback = false;
  static const int defaultKnockbackValue = 0;
  static const bool defaultIsKnockbackAirborne = false;
  static const String defaultKnockbackType = '';
  static const bool defaultHasLunge = false;
  static const int defaultLungeValue = 0;
  static const bool defaultIsLungeAirborne = false;
  static const bool defaultHasLOS = true;
  static const bool defaultIsRangeBoostable = true;
  static const bool defaultHasDirectContact = false;
  static const bool defaultHasUtility = false;
  static const String defaultUtilityType = '';
  static const bool defaultHasCompoundingPower = false;
  static const bool defaultHasDeprecatingPower = false;
  static const bool defaultHasMultiHit = false;
  static const int defaultMultiHitValue = 1;
  static const bool defaultHasPull = false;
  static const int defaultPullValue = 0;
  static const bool defaultIsPullAirborne = false;
  static const String defaultPullPriority = '';
  static const String defaultPullType = '';
  static const bool defaultHasBattleEffect = false;
  static const String defaultBattleEffectType = '';
  static const bool defaultHasBounceback = false;
  static const int defaultBouncebackValue = 0;
  static const bool defaultIsBouncebackAirborne = false;
  static const String defaultBouncebackPriority = '';
  static const bool defaultHasRecoil = false;
  static const int defaultRecoilMin = 0;
  static const int defaultRecoilMax = 0;
  static const bool defaultHasCooldown = false;
  static const int defaultCooldownValue = 0;
  static const bool defaultHasSideEffect = false;
  static const String defaultSideEffectType = '';
  static const bool defaultHasCrashDamage = false;
  static const int defaultCrashDamageMin = 0;
  static const int defaultCrashDamageMax = 0;

  static const int energyCostLowerBound = 1;
  static const int energyCostUpperBound = 50;
  static const int standardPowerMin = 25;
  static const int standardPowerMax = 35;
  static const int powerLowerBound = 1;
  static const int powerUpperBound = 250;
  static const int rangeLowerBound = 0;
  static const int rangeUpperBound = 50;
  static const int accuracyLowerBound = 1;
  static const int accuracyUpperBound = 100;
  static const int standardKnockbackValue = 1;
  static const bool standardIsKnockbackAirborne = false;
  static const String standardKnockbackType = 'Direction';
  static const int knockbackLowerBound = 1;
  static const int knockbackUpperBound = 8;
  static const int standardLungeValue = 1;
  static const bool standardIsLungeAirborne = false;
  static const int lungeLowerBound = 1;
  static const int lungeUpperBound = 8;
  static const String standardUtilityType = 'Piercing';
  static const int standardMultiHitValue = 2;
  static const int standardMultiHitLowerBound = 2;
  static const int standardMultiHitUpperBound = 8;
  static const int standardPullValue = 1;
  static const bool standardIsPullAirborne = true;
  static const String standardPullPriority = 'Post';
  static const String standardPullType = 'Origin';
  static const int pullLowerBound = 1;
  static const int pullUpperBound = 8;
  static const String standardBattleEffectType = 'Burn';
  static const int standardBouncebackValue = 1;
  static const bool standardIsBouncebackAirborne = false;
  static const String standardBouncebackPriority = 'Pre';
  static const int bouncebackLowerBound = 1;
  static const int bouncebackUpperBound = 8;
  static const int standardRecoilMin = 25;
  static const int standardRecoilMax = 35;
  static const int recoilLowerBound = 1;
  static const int recoilUpperBound = 250;
  static const int standardCooldownValue = 3;
  static const int cooldownLowerBound = 1;
  static const int cooldownUpperBound = 20;
  static const String standardSideEffectType = 'Burn';
  static const int standardCrashDamageMin = 25;
  static const int standardCrashDamageMax = 35;
  static const int crashDamageLowerBound = 1;
  static const int crashDamageUpperBound = 250;

  final int? id;
  final String name;
  final String description;
  final int moveNum;
  final String element;
  final String moveType;
  final int energyCost;
  final bool hasPower;
  late final int powerMin;
  late final int powerMax;
  final int rangeMin;
  final int rangeMax;
  final int accuracy;
  final bool hasKnockback;
  late final int knockbackValue;
  late final bool isKnockbackAirborne;
  late final String knockbackType;
  final bool hasLunge;
  late final int lungeValue;
  late final bool isLungeAirborne;
  final bool hasLOSModifier;
  late final bool hasLOS;
  final bool hasRangeBoostableModifier;
  late final bool isRangeBoostable;
  final bool hasDirectContactModifier;
  late final bool hasDirectContact;
  final bool hasUtility;
  late final String utilityType;
  final bool hasCompoundingPowerModifier;
  late final bool hasCompoundingPower;
  final bool hasDeprecatingPowerModifier;
  late final bool hasDeprecatingPower;
  final bool hasMultiHit;
  late final int multiHitValue;
  final bool hasPull;
  late final int pullValue;
  late final bool isPullAirborne;
  late final String pullPriority;
  late final String pullType;
  final bool hasBattleEffect;
  late final String battleEffectType;
  final bool hasBounceback;
  late final int bouncebackValue;
  late final bool isBouncebackAirborne;
  late final String bouncebackPriority;
  final bool hasRecoil;
  late final int recoilMin;
  late final int recoilMax;
  final bool hasCooldown;
  late final int cooldownValue;
  final bool hasSideEffect;
  late final String sideEffectType;
  final bool hasCrashDamage;
  late final int crashDamageMin;
  late final int crashDamageMax;

  late final Map<String, Object?> _map;

  Move({
    this.id,
    required this.name,
    required this.description,
    required this.moveNum,
    required this.element,
    required this.moveType,
    required this.energyCost,
    required this.hasPower,
    int powerMin = defaultPowerMin,
    int powerMax = defaultPowerMax,
    required this.rangeMin,
    required this.rangeMax,
    required this.accuracy,
    required this.hasKnockback,
    int knockbackValue = defaultKnockbackValue,
    bool isKnockbackAirborne = defaultIsKnockbackAirborne,
    String knockbackType = defaultKnockbackType,
    required this.hasLunge,
    int lungeValue = defaultLungeValue,
    bool isLungeAirborne = defaultIsLungeAirborne,
    required this.hasLOSModifier,
    bool? hasLOS,
    required this.hasRangeBoostableModifier,
    bool? isRangeBoostable,
    required this.hasDirectContactModifier,
    bool? hasDirectContact,
    required this.hasUtility,
    String utilityType = defaultUtilityType,
    required this.hasCompoundingPowerModifier,
    bool? hasCompoundingPower,
    required this.hasDeprecatingPowerModifier,
    bool? hasDeprecatingPower,
    required this.hasMultiHit,
    int multiHitValue = defaultMultiHitValue,
    required this.hasPull,
    int pullValue = defaultPullValue,
    bool isPullAirborne = defaultIsPullAirborne,
    String pullPriority = defaultPullPriority,
    String pullType = defaultPullType,
    required this.hasBattleEffect,
    String battleEffectType = defaultBattleEffectType,
    required this.hasBounceback,
    int bouncebackValue = defaultBouncebackValue,
    bool isBouncebackAirborne = defaultIsBouncebackAirborne,
    String bouncebackPriority = defaultBouncebackPriority,
    required this.hasRecoil,
    int recoilMin = defaultRecoilMin,
    int recoilMax = defaultRecoilMax,
    required this.hasCooldown,
    int cooldownValue = defaultCooldownValue,
    required this.hasSideEffect,
    String sideEffectType = defaultSideEffectType,
    required this.hasCrashDamage,
    int crashDamageMin = defaultCrashDamageMin,
    int crashDamageMax = defaultCrashDamageMax,
  }) {
    this.powerMin = hasPower ? powerMin : defaultPowerMin;
    this.powerMax = hasPower ? powerMax : defaultPowerMax;
    this.knockbackValue = hasKnockback ? knockbackValue : defaultKnockbackValue;
    this.isKnockbackAirborne =
        hasKnockback ? isKnockbackAirborne : defaultIsKnockbackAirborne;
    this.knockbackType = hasKnockback ? knockbackType : defaultKnockbackType;
    this.lungeValue = hasLunge ? lungeValue : defaultLungeValue;
    this.isLungeAirborne = hasLunge ? isLungeAirborne : defaultIsLungeAirborne;
    this.hasLOS = hasLOSModifier && hasLOS != null ? hasLOS : defaultHasLOS;
    this.isRangeBoostable =
        hasRangeBoostableModifier && isRangeBoostable != null
            ? isRangeBoostable
            : defaultIsRangeBoostable;
    this.hasDirectContact = hasDirectContactModifier && hasDirectContact != null
        ? hasDirectContact
        : defaultHasDirectContact;
    this.utilityType = hasUtility ? utilityType : defaultUtilityType;
    this.hasCompoundingPower =
        hasCompoundingPowerModifier && hasCompoundingPower != null
            ? hasCompoundingPower
            : defaultHasCompoundingPower;
    this.hasDeprecatingPower =
        hasDeprecatingPowerModifier && hasDeprecatingPower != null
            ? hasDeprecatingPower
            : defaultHasDeprecatingPower;
    this.multiHitValue = hasMultiHit ? multiHitValue : defaultMultiHitValue;
    this.pullValue = hasPull ? pullValue : defaultPullValue;
    this.isPullAirborne = hasPull ? isPullAirborne : defaultIsPullAirborne;
    this.pullPriority = hasPull ? pullPriority : defaultPullPriority;
    this.pullType = hasPull ? pullType : defaultPullType;
    this.battleEffectType =
        hasBattleEffect ? battleEffectType : defaultBattleEffectType;
    this.bouncebackValue =
        hasBounceback ? bouncebackValue : defaultBouncebackValue;
    this.isBouncebackAirborne =
        hasBounceback ? isBouncebackAirborne : defaultIsBouncebackAirborne;
    this.bouncebackPriority =
        hasBounceback ? bouncebackPriority : defaultBouncebackPriority;
    this.recoilMin = hasRecoil ? recoilMin : defaultRecoilMin;
    this.recoilMax = hasRecoil ? recoilMax : defaultRecoilMax;
    this.cooldownValue = hasCooldown ? cooldownValue : defaultCooldownValue;
    this.sideEffectType =
        hasSideEffect ? sideEffectType : defaultSideEffectType;
    this.crashDamageMin =
        hasCrashDamage ? crashDamageMin : defaultCrashDamageMin;
    this.crashDamageMax =
        hasCrashDamage ? crashDamageMax : defaultCrashDamageMax;

    _map = {
      MoveFields.id: id,
      MoveFields.name: name,
      MoveFields.description: description,
      MoveFields.moveNum: moveNum,
      MoveFields.element: element,
      MoveFields.moveType: moveType,
      MoveFields.energyCost: energyCost,
      MoveFields.hasPower: hasPower,
      MoveFields.powerMin: this.powerMin,
      MoveFields.powerMax: this.powerMax,
      MoveFields.rangeMin: rangeMin,
      MoveFields.rangeMax: rangeMax,
      MoveFields.accuracy: accuracy,
      MoveFields.hasKnockback: hasKnockback,
      MoveFields.knockbackValue: this.knockbackValue,
      MoveFields.isKnockbackAirborne: this.isKnockbackAirborne,
      MoveFields.knockbackType: this.knockbackType,
      MoveFields.hasLunge: hasLunge,
      MoveFields.lungeValue: this.lungeValue,
      MoveFields.isLungeAirborne: this.isLungeAirborne,
      MoveFields.hasLOSModifier: hasLOSModifier,
      MoveFields.hasLOS: this.hasLOS,
      MoveFields.hasRangeBoostableModifier: hasRangeBoostableModifier,
      MoveFields.isRangeBoostable: this.isRangeBoostable,
      MoveFields.hasDirectContactModifier: hasDirectContactModifier,
      MoveFields.hasDirectContact: this.hasDirectContact,
      MoveFields.hasUtility: hasUtility,
      MoveFields.utilityType: this.utilityType,
      MoveFields.hasCompoundingPowerModifier: hasCompoundingPowerModifier,
      MoveFields.hasCompoundingPower: this.hasCompoundingPower,
      MoveFields.hasDeprecatingPowerModifier: hasDeprecatingPowerModifier,
      MoveFields.hasDeprecatingPower: this.hasDeprecatingPower,
      MoveFields.hasMultiHit: hasMultiHit,
      MoveFields.multiHitValue: this.multiHitValue,
      MoveFields.hasPull: hasPull,
      MoveFields.pullValue: this.pullValue,
      MoveFields.isPullAirborne: this.isPullAirborne,
      MoveFields.pullPriority: this.pullPriority,
      MoveFields.pullType: this.pullType,
      MoveFields.hasBattleEffect: hasBattleEffect,
      MoveFields.battleEffectType: this.battleEffectType,
      MoveFields.hasBounceback: hasBounceback,
      MoveFields.bouncebackValue: this.bouncebackValue,
      MoveFields.isBouncebackAirborne: this.isBouncebackAirborne,
      MoveFields.bouncebackPriority: this.bouncebackPriority,
      MoveFields.hasRecoil: hasRecoil,
      MoveFields.recoilMin: this.recoilMin,
      MoveFields.recoilMax: this.recoilMax,
      MoveFields.hasCooldown: hasCooldown,
      MoveFields.cooldownValue: this.cooldownValue,
      MoveFields.hasSideEffect: hasSideEffect,
      MoveFields.sideEffectType: this.sideEffectType,
      MoveFields.hasCrashDamage: hasCrashDamage,
      MoveFields.crashDamageMin: this.crashDamageMin,
      MoveFields.crashDamageMax: this.crashDamageMax,
    };
  }

  Map<String, Object?> get map => {..._map};

  Move copy({
    int? id,
    bool nullifyID = false,
    int? moveNum,
    String? name,
    String? description,
  }) {
    return Move(
      id: nullifyID ? null : id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      moveNum: moveNum ?? this.moveNum,
      element: element,
      moveType: moveType,
      energyCost: energyCost,
      hasPower: hasPower,
      powerMin: powerMin,
      powerMax: powerMax,
      rangeMin: rangeMin,
      rangeMax: rangeMax,
      accuracy: accuracy,
      hasKnockback: hasKnockback,
      knockbackValue: knockbackValue,
      isKnockbackAirborne: isKnockbackAirborne,
      knockbackType: knockbackType,
      hasLunge: hasLunge,
      lungeValue: lungeValue,
      isLungeAirborne: isLungeAirborne,
      hasLOSModifier: hasLOSModifier,
      hasLOS: hasLOS,
      hasRangeBoostableModifier: hasRangeBoostableModifier,
      isRangeBoostable: isRangeBoostable,
      hasDirectContactModifier: hasDirectContactModifier,
      hasDirectContact: hasDirectContact,
      hasUtility: hasUtility,
      utilityType: utilityType,
      hasCompoundingPowerModifier: hasCompoundingPowerModifier,
      hasCompoundingPower: hasCompoundingPower,
      hasDeprecatingPowerModifier: hasDeprecatingPowerModifier,
      hasDeprecatingPower: hasDeprecatingPower,
      hasMultiHit: hasMultiHit,
      multiHitValue: multiHitValue,
      hasPull: hasPull,
      pullValue: pullValue,
      isPullAirborne: isPullAirborne,
      pullPriority: pullPriority,
      pullType: pullType,
      hasBattleEffect: hasBattleEffect,
      battleEffectType: battleEffectType,
      hasBounceback: hasBounceback,
      bouncebackValue: bouncebackValue,
      isBouncebackAirborne: isBouncebackAirborne,
      bouncebackPriority: bouncebackPriority,
      hasRecoil: hasRecoil,
      recoilMin: recoilMin,
      recoilMax: recoilMax,
      hasCooldown: hasCooldown,
      cooldownValue: cooldownValue,
      hasSideEffect: hasSideEffect,
      sideEffectType: sideEffectType,
      hasCrashDamage: hasCrashDamage,
      crashDamageMin: crashDamageMin,
      crashDamageMax: crashDamageMax,
    );
  }

  @override
  bool equals(KoalaDataType comp) {
    return comp is Move &&
        name == comp.name &&
        description == comp.description &&
        element == comp.element &&
        moveType == comp.moveType &&
        energyCost == comp.energyCost &&
        hasPower == comp.hasPower &&
        powerMin == comp.powerMin &&
        powerMax == comp.powerMax &&
        rangeMin == comp.rangeMin &&
        rangeMax == comp.rangeMax &&
        accuracy == comp.accuracy &&
        hasKnockback == comp.hasKnockback &&
        knockbackValue == comp.knockbackValue &&
        isKnockbackAirborne == comp.isKnockbackAirborne &&
        knockbackType == comp.knockbackType &&
        hasLunge == comp.hasLunge &&
        lungeValue == comp.lungeValue &&
        isLungeAirborne == comp.isLungeAirborne &&
        hasLOS == comp.hasLOS &&
        isRangeBoostable == comp.isRangeBoostable &&
        hasDirectContact == comp.hasDirectContact &&
        hasUtility == comp.hasUtility &&
        utilityType == comp.utilityType &&
        hasCompoundingPower == comp.hasCompoundingPower &&
        hasDeprecatingPower == comp.hasDeprecatingPower &&
        hasMultiHit == comp.hasMultiHit &&
        multiHitValue == comp.multiHitValue &&
        hasPull == comp.hasPull &&
        pullValue == comp.pullValue &&
        isPullAirborne == comp.isPullAirborne &&
        pullPriority == comp.pullPriority &&
        pullType == comp.pullType &&
        hasBattleEffect == comp.hasBattleEffect &&
        battleEffectType == comp.battleEffectType &&
        hasBounceback == comp.hasBounceback &&
        bouncebackValue == comp.bouncebackValue &&
        isBouncebackAirborne == comp.isBouncebackAirborne &&
        bouncebackPriority == comp.bouncebackPriority &&
        hasRecoil == comp.hasRecoil &&
        recoilMin == comp.recoilMin &&
        recoilMax == comp.recoilMax &&
        hasCooldown == comp.hasCooldown &&
        cooldownValue == comp.cooldownValue &&
        hasSideEffect == comp.hasSideEffect &&
        sideEffectType == comp.sideEffectType &&
        hasCrashDamage == comp.hasCrashDamage &&
        crashDamageMin == comp.crashDamageMin &&
        crashDamageMax == comp.crashDamageMax;
  }

  bool has(MoveModifier modifier) {
    if (modifier == MoveModifier.knockback) {
      return hasKnockback;
    }
    if (modifier == MoveModifier.lunge) {
      return hasLunge;
    }
    if (modifier == MoveModifier.los) {
      return hasLOSModifier;
    }
    if (modifier == MoveModifier.rangeBoostable) {
      return hasRangeBoostableModifier;
    }
    if (modifier == MoveModifier.directContact) {
      return hasDirectContactModifier;
    }
    if (modifier == MoveModifier.utility) {
      return hasUtility;
    }
    if (modifier == MoveModifier.compoundingPower) {
      return hasCompoundingPowerModifier;
    }
    if (modifier == MoveModifier.deprecatingPower) {
      return hasDeprecatingPowerModifier;
    }
    if (modifier == MoveModifier.multiHit) {
      return hasMultiHit;
    }
    if (modifier == MoveModifier.pull) {
      return hasPull;
    }
    if (modifier == MoveModifier.battleEffect) {
      return hasBattleEffect;
    }
    if (modifier == MoveModifier.bounceback) {
      return hasBounceback;
    }
    if (modifier == MoveModifier.recoil) {
      return hasRecoil;
    }
    if (modifier == MoveModifier.cooldown) {
      return hasCooldown;
    }
    if (modifier == MoveModifier.sideEffect) {
      return hasSideEffect;
    }
    if (modifier == MoveModifier.crashDamage) {
      return hasCrashDamage;
    }
    return false;
  }

  List<List<String>> info(){
    final List<List<String>> list = [
      ['Name', name],
      ['Move Number', '$moveNum'],
      ['Description', description],
      ['Element', element],
      ['Move Type', moveType],
      ['Energy Cost', '$energyCost'],
    ];

    if(hasPower) list.add(['Power', '$powerMin - $powerMax']);
    list.addAll([['Range', '$rangeMax'], ['Accuracy', '$accuracy']]);

    if(hasKnockback) {
      list.add(['Knockback', '$knockbackValue | Airborne: ${isKnockbackAirborne ? 'Yes' : 'No'} | $knockbackType']);
    }

    if(hasKnockback) {
      list.add(['Lunge', '$knockbackValue | Airborne: ${isKnockbackAirborne ? 'Yes' : 'No'}']);
    }

    if(!hasLOS){
      list.add(['Ignores Line of Sight', '']);
    }

    if(!isRangeBoostable){
      list.add(['Cannot Boost Range', '']);
    }

    if(hasDirectContact){
      list.add(['Direct Contact', '']);
    }

    if(hasUtility){
      list.add(['Utility', utilityType]);
    }

    if(hasCompoundingPower){
      list.add(['Compounding Power', '']);
    }

    if(hasDeprecatingPower){
      list.add(['Deprecating Power', '']);
    }

    if(hasMultiHit){
      list.add(['MultiHit', '$multiHitValue']);
    }

    if(hasPull) {
      list.add(['Pull', '$pullValue | Airborne: ${isPullAirborne ? 'Yes' : 'No'} | $pullType | $pullPriority']);
    }

    if(hasBattleEffect){
      list.add(['Battle Effect', battleEffectType]);
    }

    if(hasBounceback) {
      list.add(['Bounceback', '$pullValue | Airborne: ${isBouncebackAirborne ? 'Yes' : 'No'} | $bouncebackPriority']);
    }

    if(hasRecoil){
      list.add(['Recoil', '$recoilMin - $recoilMax']);
    }

    if(hasCooldown){
      list.add(['Cooldown', '$cooldownValue']);
    }

    if(hasSideEffect){
      list.add(['Side Effect', sideEffectType]);
    }

    if(hasCrashDamage){
      list.add(['Crash Damage', '$crashDamageMin - $crashDamageMax']);
    }

    return list;
  }

  @override
  String toString() {
    return name;
  }
}
