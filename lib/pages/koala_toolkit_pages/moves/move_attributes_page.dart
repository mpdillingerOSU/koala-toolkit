import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/general/scaffold_console.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_color_theme.dart';
import 'package:gaming_toolkit/components/tickers/components/switch_toggle.dart';
import 'package:gaming_toolkit/components/tickers/ticker_select.dart';
import 'package:gaming_toolkit/components/tickers/ticker_toggleable_row.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/battle_effect.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/forced_movement_type.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/move_modifier.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/utility.dart';

import '../../../components/general/nav_bar.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/margined_column.dart';
import '../../../components/tickers/components/block_toggle.dart';
import '../../../components/tickers/ticker_box.dart';
import '../../../components/tickers/ticker_fat_row.dart';
import '../../../components/tickers/ticker_min_max.dart';
import '../../../components/tickers/ticker_switch.dart';
import '../../../koala_toolkit_back_end/data/moves/move.dart';
import '../../../koala_toolkit_back_end/data/moves/move_list.dart';
import '../../../koala_toolkit_back_end/modifier_move_timing.dart';
import '../../../koala_toolkit_back_end/move_element.dart';
import '../../../koala_toolkit_back_end/move_modifier_restrictor.dart';
import '../../../koala_toolkit_back_end/move_type.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../koala_toolkit_back_end/undo_redo_list.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';
import '../popups/koala_alert.dart';
import 'select_modifier_page.dart';

class MoveAttributesPage extends KoalaPage {
  final ProjectPacket project;
  final Move initialMove;
  final MoveList moveList;

  const MoveAttributesPage(
    this.project,
    this.initialMove,
    this.moveList, {
    super.key,
  });

  @override
  KoalaPageState<MoveAttributesPage> createState() => MoveAttributesPageState();
}

class MoveAttributesPageState extends KoalaPageState<MoveAttributesPage> {
  late TickerColorTheme _colorTheme;

  late TickerSelect _elementTicker;
  late TickerSelect _moveTypeTicker;
  late TickerFatRow _energyTicker;
  TickerMinMax? _powerTicker;
  late TickerBox _rangeTicker;
  late TickerBox _accuracyTicker;
  TickerToggleableRow? _knockbackTicker;
  TickerToggleableRow? _lungeTicker;
  TickerSwitch? _losTicker;
  TickerSwitch? _rangeBoostableTicker;
  TickerSwitch? _directContactTicker;
  TickerSelect? _utilityTicker;
  TickerSwitch? _compoundingPowerTicker;
  TickerSwitch? _deprecatingPowerTicker;
  TickerBox? _multiHitTicker;
  TickerToggleableRow? _pullTicker;
  TickerSelect? _battleEffectTicker;
  TickerToggleableRow? _bouncebackTicker;
  TickerMinMax? _recoilTicker;
  TickerBox? _cooldownTicker;
  TickerSelect? _sideEffectTicker;
  TickerMinMax? _crashDamageTicker;

  late final UndoRedoList<Move> _undoRedoList;

  updateUndoRedo(void Function() func) {
    setState(() {
      func();
      _undoRedoList.add(_generateMove());
    });
  }

  @override
  Future<void> subRefresh() async {}

  @override
  initState() {
    super.initState();
    refreshPage(() async {
      _restoreAll();
      _undoRedoList = UndoRedoList(_generateMove());
    });
  }

  TickerColorTheme _getColorTheme(String element) {
    return TickerColorTheme.silverSmooth;
    /*
    return element == MoveElement.fire.toString()
        ? TickerColorTheme.orangeSmooth
        : element == MoveElement.earth.toString()
            ? TickerColorTheme.brownSmooth
            : element == MoveElement.water.toString()
                ? TickerColorTheme.blueSmooth
                : element == MoveElement.wind.toString()
                    ? TickerColorTheme.tealSmooth
                    : element == MoveElement.flora.toString()
                        ? TickerColorTheme.greenSmooth
                        : element == MoveElement.electric.toString()
                            ? TickerColorTheme.yellowSmooth
                            : element == MoveElement.ice.toString()
                                ? TickerColorTheme.powderBlueSmooth
                                : element == MoveElement.steel.toString()
                                    ? TickerColorTheme.silverSmooth
                                    : TickerColorTheme.blueSmooth;
     */
  }

  void _restoreAll() {
    _colorTheme = _getColorTheme(widget.initialMove.element);
    _initialElement();
    _initialMoveType();
    _initialEnergyCost();
    _initialPower();
    _initialRange();
    _initialAccuracy();
    _initialKnockback();
    _initialLunge();
    _initialLOS();
    _initialRangeBoostable();
    _initialDirectContact();
    _initialUtility();
    _initialCompoundingPower();
    _initialDeprecatingPower();
    _initialMultiHit();
    _initialPull();
    _initialBattleEffect();
    _initialBounceback();
    _initialRecoil();
    _initialCooldown();
    _initialSideEffect();
    _initialCrashDamage();
  }

  void _setTo(Move? move) {
    if (move == null) return;

    _colorTheme = _getColorTheme(move.element);
    _addElement(currentSelection: move.element);
    _addMoveType(currentSelection: move.moveType);
    _addEnergyCost(value: move.energyCost);
    move.hasPower
        ? _addPower(minVal: move.powerMin, maxVal: move.powerMax)
        : _powerTicker = null;
    _addRange(value: move.rangeMax);
    _addAccuracy(value: move.accuracy);
    move.hasKnockback
        ? _addKnockback(
            value: move.knockbackValue,
            isAirborne: move.isKnockbackAirborne,
            type: move.knockbackType,
          )
        : _knockbackTicker = null;
    move.hasLunge
        ? _addLunge(
            value: move.lungeValue,
            isAirborne: move.isLungeAirborne,
          )
        : _lungeTicker = null;
    !move.hasLOS ? _addLOS() : _losTicker = null;
    !move.isRangeBoostable
        ? _addRangeBoostable()
        : _rangeBoostableTicker = null;
    move.hasDirectContact ? _addDirectContact() : _directContactTicker = null;
    move.hasUtility
        ? _addUtility(
            selection: move.utilityType,
          )
        : _utilityTicker = null;
    move.hasCompoundingPower
        ? _addCompoundingPower()
        : _compoundingPowerTicker = null;
    move.hasDeprecatingPower
        ? _addDeprecatingPower()
        : _deprecatingPowerTicker = null;
    move.hasMultiHit
        ? _addMultiHit(
            value: move.multiHitValue,
          )
        : _multiHitTicker = null;
    move.hasPull
        ? _addPull(
            value: move.pullValue,
            isAirborne: move.isPullAirborne,
            priority: move.pullPriority,
            type: move.pullType,
          )
        : _pullTicker = null;
    move.hasBattleEffect
        ? _addBattleEffect(
            selection: move.battleEffectType,
          )
        : _battleEffectTicker = null;
    move.hasBounceback
        ? _addBounceback(
            value: move.bouncebackValue,
            isAirborne: move.isBouncebackAirborne,
            priority: move.bouncebackPriority,
          )
        : _bouncebackTicker = null;
    move.hasRecoil
        ? _addRecoil(
            minVal: move.recoilMin,
            maxVal: move.recoilMax,
          )
        : _recoilTicker = null;
    move.hasCooldown
        ? _addCooldown(
            value: move.cooldownValue,
          )
        : _cooldownTicker = null;
    move.hasSideEffect
        ? _addSideEffect(
            selection: move.sideEffectType,
          )
        : _sideEffectTicker = null;
    move.hasCrashDamage
        ? _addCrashDamage(
            minVal: move.crashDamageMin,
            maxVal: move.crashDamageMax,
          )
        : _crashDamageTicker = null;
  }

  void _restoreCrashDamage() => _initialCrashDamage();

  void _initialCrashDamage() => widget.initialMove.hasCrashDamage
      ? _addCrashDamage(
          minVal: widget.initialMove.crashDamageMin,
          maxVal: widget.initialMove.crashDamageMax,
        )
      : _crashDamageTicker = null;

  void _restoreSideEffect() => _initialSideEffect();

  void _initialSideEffect() => widget.initialMove.hasSideEffect
      ? _addSideEffect(
          selection: widget.initialMove.sideEffectType,
        )
      : _sideEffectTicker = null;

  void _restoreCooldown() => _initialCooldown();

  void _initialCooldown() => widget.initialMove.hasCooldown
      ? _addCooldown(
          value: widget.initialMove.cooldownValue,
        )
      : _cooldownTicker = null;

  void _restoreRecoil() => _initialRecoil();

  void _initialRecoil() => widget.initialMove.hasRecoil
      ? _addRecoil(
          minVal: widget.initialMove.recoilMin,
          maxVal: widget.initialMove.recoilMax,
        )
      : _recoilTicker = null;

  void _restoreBounceback() => _initialBounceback();

  void _initialBounceback() => widget.initialMove.hasBounceback
      ? _addBounceback(
          value: widget.initialMove.bouncebackValue,
          isAirborne: widget.initialMove.isBouncebackAirborne,
          priority: widget.initialMove.bouncebackPriority,
        )
      : _bouncebackTicker = null;

  void _restoreBattleEffect() => _initialBattleEffect();

  void _initialBattleEffect() => widget.initialMove.hasBattleEffect
      ? _addBattleEffect(
          selection: widget.initialMove.battleEffectType,
        )
      : _battleEffectTicker = null;

  void _restorePull() => _initialPull();

  void _initialPull() => widget.initialMove.hasPull
      ? _addPull(
          value: widget.initialMove.pullValue,
          isAirborne: widget.initialMove.isPullAirborne,
          priority: widget.initialMove.pullPriority,
          type: widget.initialMove.pullType,
        )
      : _pullTicker = null;

  void _restoreMultiHit() => _initialMultiHit();

  void _initialMultiHit() => widget.initialMove.hasMultiHit
      ? _addMultiHit(
          value: widget.initialMove.multiHitValue,
        )
      : _multiHitTicker = null;

  void _restoreDeprecatingPower() => _initialDeprecatingPower();

  void _initialDeprecatingPower() =>
      widget.initialMove.hasDeprecatingPowerModifier
          ? _addDeprecatingPower(value: widget.initialMove.hasDeprecatingPower)
          : _deprecatingPowerTicker = null;

  void _restoreCompoundingPower() => _initialCompoundingPower();

  void _initialCompoundingPower() =>
      widget.initialMove.hasCompoundingPowerModifier
          ? _addCompoundingPower(value: widget.initialMove.hasCompoundingPower)
          : _compoundingPowerTicker = null;

  void _restoreUtility() => _initialUtility();

  void _initialUtility() => widget.initialMove.hasUtility
      ? _addUtility(
          selection: widget.initialMove.utilityType,
        )
      : _utilityTicker = null;

  void _restoreDirectContact() => _initialDirectContact();

  void _initialDirectContact() => widget.initialMove.hasDirectContactModifier
      ? _addDirectContact(value: widget.initialMove.hasDirectContact)
      : _directContactTicker = null;

  void _restoreRangeBoostable() => _initialRangeBoostable();

  void _initialRangeBoostable() => widget.initialMove.hasRangeBoostableModifier
      ? _addRangeBoostable(value: widget.initialMove.isRangeBoostable)
      : _rangeBoostableTicker = null;

  void _restoreLOS() => _initialLOS();

  void _initialLOS() => widget.initialMove.hasLOSModifier
      ? _addLOS(value: widget.initialMove.hasLOS)
      : _losTicker = null;

  void _restoreLunge() => _initialLunge();

  void _initialLunge() => widget.initialMove.hasLunge
      ? _addLunge(
          value: widget.initialMove.lungeValue,
          isAirborne: widget.initialMove.isLungeAirborne,
        )
      : _lungeTicker = null;

  void _restoreKnockback() => _initialKnockback();

  void _initialKnockback() => widget.initialMove.hasKnockback
      ? _addKnockback(
          value: widget.initialMove.knockbackValue,
          isAirborne: widget.initialMove.isKnockbackAirborne,
          type: widget.initialMove.knockbackType,
        )
      : _knockbackTicker = null;

  void _restoreAccuracy() => _initialAccuracy();

  void _initialAccuracy() => _addAccuracy(value: widget.initialMove.accuracy);

  void _restoreRange() => _initialRange();

  void _initialRange() => _addRange(value: widget.initialMove.rangeMax);

  void _restorePower() => _initialPower();

  void _initialPower() => widget.initialMove.hasPower
      ? _addPower(
          minVal: widget.initialMove.powerMin,
          maxVal: widget.initialMove.powerMax)
      : _powerTicker = null;

  void _restoreEnergyCost() => _initialEnergyCost();

  void _initialEnergyCost() =>
      _addEnergyCost(value: widget.initialMove.energyCost);

  void _restoreMoveType() => _initialMoveType();

  void _initialMoveType() =>
      _addMoveType(currentSelection: widget.initialMove.moveType);

  void _restoreElement() => _initialElement();

  void _initialElement() =>
      _addElement(currentSelection: widget.initialMove.element);

  @override
  Widget build(BuildContext context) {
    return AdvancedScaffold(
      pageTitle: 'Attributes',
      barColor: lightingTheme.deepBackgroundColor,
      barTextColor: _colorTheme.barTextColor,
      backgroundGradient: _colorTheme.backgroundGradient,
      backgroundIcons: [
        MoveElement.map[_elementTicker.getCurrentSelection()] ??
            MoveElement.fire.icon,
        MoveType.map[_moveTypeTicker.getCurrentSelection()] ??
            MoveType.physical.icon,
      ],
      actionMargin: 16,
      actions: [
        TapDetector(
          onTap: () async {
            if (_undoRedoList.canUndo) {
              setState(() {
                _setTo(_undoRedoList.undo());
              });
            }
          },
          child: Center(
            child: Icon(
              Icons.undo_rounded,
              color: _undoRedoList.canUndo
                  ? _colorTheme.barTextColor
                  : Colors.grey.shade300,
              size: 32,
            ),
          ),
        ),
        TapDetector(
          onTap: () async {
            if (_undoRedoList.canRedo) {
              setState(() {
                _setTo(_undoRedoList.redo());
              });
            }
          },
          child: Center(
            child: Icon(
              Icons.redo_rounded,
              color: _undoRedoList.canRedo
                  ? _colorTheme.barTextColor
                  : Colors.grey.shade300,
              size: 32,
            ),
          ),
        ),
        TapDetector(
          onTap: () async {
            if (_undoRedoList.canUndo && await _restoreAllPopup()) {
              updateUndoRedo(() {
                _restoreAll();
              });
            }
          },
          child: Center(
            child: Icon(
              Icons.restore_rounded,
              color: _undoRedoList.canUndo
                  ? _colorTheme.barTextColor
                  : Colors.grey.shade300,
              size: 32,
            ),
          ),
        ),
        TapDetector(
          onTap: () async {
            await pushNamedPage('/settings');
          },
          child: const Center(
            child: Icon(
              Icons.settings_sharp,
              color: Colors.lightBlue,
              size: 32,
            ),
          ),
        ),
      ],
      body: Stack(
        children: [
          Visibility(
            visible: !isLoading,
            child: ScaffoldConsole(
              decoration: BoxDecoration(
                color: lightingTheme.deepBackgroundColor,
                borderRadius: BorderRadius.circular(25 * .8),
                border: Border.all(
                  color: MyConstants.borderColor,
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  _verticalSpacer(),
                  MarginedColumn(
                    margin: 2,
                    children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _elementTicker,
                              _horizontalSpacer(),
                              _moveTypeTicker,
                            ],
                          ),
                          _verticalSpacer(),
                          _energyTicker,
                        ] +
                        (_powerTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _powerTicker!,
                              ]) +
                        [
                          _verticalSpacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _rangeTicker,
                              _horizontalSpacer(),
                              _accuracyTicker,
                            ],
                          ),
                        ] +
                        (_knockbackTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _knockbackTicker!,
                              ]) +
                        (_lungeTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _lungeTicker!,
                              ]) +
                        (_losTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _losTicker!,
                              ]) +
                        (_rangeBoostableTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _rangeBoostableTicker!,
                              ]) +
                        (_directContactTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _directContactTicker!,
                              ]) +
                        (_utilityTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _utilityTicker!,
                              ]) +
                        (_compoundingPowerTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _compoundingPowerTicker!,
                              ]) +
                        (_deprecatingPowerTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _deprecatingPowerTicker!,
                              ]) +
                        (_multiHitTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _multiHitTicker!,
                              ]) +
                        (_pullTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _pullTicker!,
                              ]) +
                        (_battleEffectTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _battleEffectTicker!,
                              ]) +
                        (_bouncebackTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _bouncebackTicker!,
                              ]) +
                        (_recoilTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _recoilTicker!,
                              ]) +
                        (_cooldownTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _cooldownTicker!,
                              ]) +
                        (_sideEffectTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _sideEffectTicker!,
                              ]) +
                        (_crashDamageTicker == null
                            ? []
                            : [
                                _verticalSpacer(),
                                _crashDamageTicker!,
                              ]),
                  ),
                  _verticalSpacer(),
                ],
              ),
            ),
          ),
          loadingScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3415C0),
        onPressed: () => _addModifier(context),
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Modifier',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: TextNavBar(
        context,
        onPressed: () async {
          Navigator.pop(
            context,
            _undoRedoList.isEdited
                ? await widget.project.updateMove(
                    _generateMove(),
                    widget.moveList,
                  )
                : null,
          );
        },
        text: 'SAVE',
        textColor: lightingTheme.complementaryColor,
        barColor: lightingTheme.deepBackgroundColor,
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    if (!_undoRedoList.isEdited) return true;

    return await showDialog(
          context: context,
          builder: (context) => const KoalaAlert(
            title: 'Discard Changes',
            text: 'Do you wish to discard all changes made to the move?',
          ),
        ) ??
        false;
  }

  Move _generateMove() {
    return Move(
      id: widget.initialMove.id,
      name: widget.initialMove.name,
      description: widget.initialMove.description,
      moveNum: widget.initialMove.moveNum,
      element: _elementTicker.getCurrentSelection(),
      moveType: _moveTypeTicker.getCurrentSelection(),
      energyCost: _energyTicker.getValue(),
      hasPower: _powerTicker != null,
      powerMin: _powerTicker?.getMinValue() ?? Move.defaultPowerMin,
      powerMax: _powerTicker?.getMaxValue() ?? Move.defaultPowerMax,
      rangeMin: Move.defaultRangeMin,
      rangeMax: _rangeTicker.getValue(),
      accuracy: _accuracyTicker.getValue(),
      hasKnockback: _knockbackTicker != null,
      knockbackValue:
          _knockbackTicker?.getValue() ?? Move.defaultKnockbackValue,
      isKnockbackAirborne:
          (_knockbackTicker?.getToggleValue('Airborne') as bool?) ??
              Move.defaultIsKnockbackAirborne,
      knockbackType: (_knockbackTicker?.getToggleValue('Type') as String?) ??
          Move.defaultKnockbackType,
      hasLunge: _lungeTicker != null,
      lungeValue: _lungeTicker?.getValue() ?? Move.defaultLungeValue,
      isLungeAirborne: (_lungeTicker?.getToggleValue('Airborne') as bool?) ??
          Move.defaultIsLungeAirborne,
      hasLOSModifier: _losTicker != null,
      hasLOS: _losTicker?.isActive() ?? Move.defaultHasLOS,
      hasRangeBoostableModifier: _rangeBoostableTicker != null,
      isRangeBoostable:
          _rangeBoostableTicker?.isActive() ?? Move.defaultIsRangeBoostable,
      hasDirectContactModifier: _directContactTicker != null,
      hasDirectContact:
          _directContactTicker?.isActive() ?? Move.defaultHasDirectContact,
      hasUtility: _utilityTicker != null,
      utilityType:
          _utilityTicker?.getCurrentSelection() ?? Move.defaultUtilityType,
      hasCompoundingPowerModifier: _compoundingPowerTicker != null,
      hasCompoundingPower: _compoundingPowerTicker?.isActive() ??
          Move.defaultHasCompoundingPower,
      hasDeprecatingPowerModifier: _deprecatingPowerTicker != null,
      hasDeprecatingPower: _deprecatingPowerTicker?.isActive() ??
          Move.defaultHasDeprecatingPower,
      hasMultiHit: _multiHitTicker != null,
      multiHitValue: _multiHitTicker?.getValue() ?? Move.defaultMultiHitValue,
      hasPull: _pullTicker != null,
      pullValue: _pullTicker?.getValue() ?? Move.defaultPullValue,
      isPullAirborne: (_pullTicker?.getToggleValue('Airborne') as bool?) ??
          Move.defaultIsPullAirborne,
      pullPriority: (_pullTicker?.getToggleValue('Priority') as String?) ??
          Move.defaultPullPriority,
      pullType: (_pullTicker?.getToggleValue('Type') as String?) ??
          Move.defaultPullType,
      hasBattleEffect: _battleEffectTicker != null,
      battleEffectType: _battleEffectTicker?.getCurrentSelection() ??
          Move.defaultBattleEffectType,
      hasBounceback: _bouncebackTicker != null,
      bouncebackValue:
          _bouncebackTicker?.getValue() ?? Move.defaultBouncebackValue,
      isBouncebackAirborne:
          (_bouncebackTicker?.getToggleValue('Airborne') as bool?) ??
              Move.defaultIsBouncebackAirborne,
      bouncebackPriority:
          (_bouncebackTicker?.getToggleValue('Priority') as String?) ??
              Move.defaultBouncebackPriority,
      hasRecoil: _recoilTicker != null,
      recoilMin: _recoilTicker?.getMinValue() ?? Move.defaultRecoilMin,
      recoilMax: _recoilTicker?.getMaxValue() ?? Move.defaultRecoilMax,
      hasCooldown: _cooldownTicker != null,
      cooldownValue: _cooldownTicker?.getValue() ?? Move.defaultCooldownValue,
      hasSideEffect: _sideEffectTicker != null,
      sideEffectType: _sideEffectTicker?.getCurrentSelection() ??
          Move.defaultSideEffectType,
      hasCrashDamage: _crashDamageTicker != null,
      crashDamageMin:
          _crashDamageTicker?.getMinValue() ?? Move.defaultCrashDamageMin,
      crashDamageMax:
          _crashDamageTicker?.getMaxValue() ?? Move.defaultCrashDamageMax,
    );
  }

  Future<void> _addModifier(BuildContext context) async {
    final MoveModifier? result = await pushPage(
      ModifierSelectionPage(
        MoveModifierRestrictor(
          _undoRedoList.current,
        ),
      ),
    );

    if (result != null) {
      updateUndoRedo(() {
        if (result == MoveModifier.knockback) {
          _addKnockback();
        } else if (result == MoveModifier.lunge) {
          _addLunge();
        } else if (result == MoveModifier.los) {
          _addLOS();
        } else if (result == MoveModifier.rangeBoostable) {
          _addRangeBoostable();
        } else if (result == MoveModifier.directContact) {
          _addDirectContact();
        } else if (result == MoveModifier.utility) {
          _addUtility();
        } else if (result == MoveModifier.compoundingPower) {
          _addCompoundingPower();
        } else if (result == MoveModifier.deprecatingPower) {
          _addDeprecatingPower();
        } else if (result == MoveModifier.multiHit) {
          _addMultiHit();
        } else if (result == MoveModifier.pull) {
          _addPull();
        } else if (result == MoveModifier.battleEffect) {
          _addBattleEffect();
        } else if (result == MoveModifier.bounceback) {
          _addBounceback();
        } else if (result == MoveModifier.recoil) {
          _addRecoil();
        } else if (result == MoveModifier.cooldown) {
          _addCooldown();
        } else if (result == MoveModifier.sideEffect) {
          _addSideEffect();
        } else if (result == MoveModifier.crashDamage) {
          _addCrashDamage();
        }
      });

      displaySnackBar('Added Modifier: $result');
    }
  }

  void _addElement({String? currentSelection}) {
    _elementTicker = TickerSelect(
      title: 'Element',
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      selections: MoveElement.map,
      currentSelection: currentSelection ?? Move.defaultElement,
      width: 144,
      hasMenu: true,
      onChanged: (value) {
        updateUndoRedo(() {
          _setTo(_generateMove());
        });
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup('Element')) {
          updateUndoRedo(() {
            _addElement();
            _setTo(_generateMove());
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup('Element')) {
          updateUndoRedo(() {
            _restoreElement();
            _setTo(_generateMove());
          });
        }
      },
    );
  }

  void _addMoveType({String? currentSelection}) {
    _moveTypeTicker = TickerSelect(
      title: 'Move Type',
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      selections: MoveType.map,
      currentSelection: currentSelection ?? Move.defaultMoveType,
      width: 144,
      hasMenu: true,
      onChanged: (value) {
        final bool hasPower = MoveType.nameMap[value]?.hasPower ?? true;
        final bool addsPower = _powerTicker == null && hasPower;
        final bool removesPower = _powerTicker != null && !hasPower;
        updateUndoRedo(() {
          if (addsPower) {
            _addPower();
          } else if (removesPower) {
            _powerTicker = null;
            _compoundingPowerTicker = null;
            _deprecatingPowerTicker = null;
          }
        });
      },
      onValidate: (value) async {
        final bool hasPower = MoveType.nameMap[value]?.hasPower ?? true;
        final bool addsPower = _powerTicker == null && hasPower;
        final bool removesPower = _powerTicker != null && !hasPower;
        final bool removesCompoundingPower =
            removesPower && _compoundingPowerTicker != null;
        final bool removesDeprecatingPower =
            removesPower && _deprecatingPowerTicker != null;

        final bool hasAdditionalChanges = addsPower || removesPower;
        bool confirm = false;

        if (hasAdditionalChanges) {
          String subtext =
              'Due to the shift of the Move Type to $value, the following additional changes will occur:\n';

          if (addsPower) {
            subtext +=
                '\n\t - Adds Power, due to the new Move Type of $value needing Power.';
          }
          if (removesPower) {
            subtext +=
                '\n\t - Removes Power, due to the new Move Type of $value not having Power.';
            if (removesCompoundingPower) {
              subtext +=
                  '\n\t - Removes the Compounding Power modifier, due to the new Move Type of $value not having Power.';
            }
            if (removesDeprecatingPower) {
              subtext +=
                  '\n\t - Removes the Deprecating Power modifier, due to the new Move Type of $value not having Power.';
            }
          }

          confirm = await showDialog(
            context: context,
            builder: (context) => KoalaAlert(
              title: 'Additional Changes to Occur',
              text: subtext,
            ),
          );
        }

        return !hasAdditionalChanges || confirm;
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup('Move Type')) {
          updateUndoRedo(() {
            _addMoveType();
          });
        }
      },
      onRestore: () async {
        bool removesPower =
            !widget.initialMove.hasPower && _powerTicker != null;
        bool restoresPower =
            widget.initialMove.hasPower && _powerTicker == null;
        bool removesCompoundingPower = false;
        bool removesDeprecatingPower = false;
        List<String> subtexts = [];
        if (restoresPower) {
          subtexts.add(
              'Restores Power, due to the restored Move Type of ${widget.initialMove.moveType} having Power.');
        }
        if (removesPower) {
          subtexts.add(
              'Removes Power, due to the restored Move Type of ${widget.initialMove.moveType} not having Power.');
          if (_compoundingPowerTicker != null) {
            removesCompoundingPower = true;
            subtexts.add(
                'Removes the Compounding Power modifier, due to the restored Move Type of ${widget.initialMove.moveType} not having Power.');
          }
          if (_deprecatingPowerTicker != null) {
            removesDeprecatingPower = true;
            subtexts.add(
                'Removes the Deprecating Power modifier, due to the restored Move Type of ${widget.initialMove.moveType} not having Power.');
          }
        }

        if (await _restorePopup('Move Type', extraSubtexts: subtexts)) {
          updateUndoRedo(() {
            _restoreMoveType();
            if (restoresPower) {
              _restorePower();
            }
            if (removesPower) {
              _powerTicker = null;
            }
            if (removesCompoundingPower) {
              _compoundingPowerTicker = null;
            }
            if (removesDeprecatingPower) {
              _deprecatingPowerTicker = null;
            }
          });
        }
      },
    );
  }

  void _addEnergyCost({int? value}) {
    _energyTicker = TickerFatRow(
      title: 'Energy Cost',
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerFatRow.defaultWidth * .8,
      startingValue: value ?? Move.defaultEnergyCost,
      lowerBound: Move.energyCostLowerBound,
      upperBound: Move.energyCostUpperBound,
      hasMenu: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup('Energy Cost')) {
          updateUndoRedo(() {
            _addEnergyCost();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup('Energy Cost')) {
          updateUndoRedo(() {
            _restoreEnergyCost();
          });
        }
      },
    );
  }

  void _addPower({int? minVal, int? maxVal}) {
    _powerTicker = TickerMinMax(
      title: 'Power',
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerMinMax.defaultWidth * .8,
      lowerBound: Move.powerLowerBound,
      upperBound: Move.powerUpperBound,
      minStartingValue: minVal ?? Move.standardPowerMin,
      maxStartingValue: maxVal ?? Move.standardPowerMax,
      hasMenu: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup('Power')) {
          updateUndoRedo(() {
            _addPower();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup('Power')) {
          updateUndoRedo(() {
            _restorePower();
          });
        }
      },
    );
  }

  void _addRange({int? value}) {
    _rangeTicker = TickerBox(
      title: 'Range',
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerBox.defaultWidth * .8,
      startingValue: value ?? Move.defaultRangeMax,
      lowerBound: Move.rangeLowerBound,
      upperBound: Move.rangeUpperBound,
      hasMenu: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup('Range')) {
          updateUndoRedo(() {
            _addRange();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup('Range')) {
          updateUndoRedo(() {
            _restoreRange();
          });
        }
      },
    );
  }

  void _addAccuracy({int? value}) {
    _accuracyTicker = TickerBox(
      title: 'Accuracy',
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerBox.defaultWidth * .8,
      startingValue: value ?? Move.defaultAccuracy,
      lowerBound: Move.accuracyLowerBound,
      upperBound: Move.accuracyUpperBound,
      hasMenu: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup('Accuracy')) {
          updateUndoRedo(() {
            _addAccuracy();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup('Accuracy')) {
          updateUndoRedo(() {
            _restoreAccuracy();
          });
        }
      },
    );
  }

  void _addKnockback({int? value, bool? isAirborne, String? type}) {
    _knockbackTicker = TickerToggleableRow(
      title: MoveModifier.knockback.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerToggleableRow.defaultWidth * .8,
      startingValue: value ?? Move.standardKnockbackValue,
      lowerBound: Move.knockbackLowerBound,
      upperBound: Move.knockbackUpperBound,
      hasMenu: true,
      canDelete: true,
      onChanged: () {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.knockback.name)) {
          updateUndoRedo(() {
            _addKnockback();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.knockback.name)) {
          updateUndoRedo(() {
            _restoreKnockback();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.knockback.name)) {
          updateUndoRedo(() {
            _knockbackTicker = null;
          });
        }
      },
      toggles: [
        SwitchToggle(
          title: 'Airborne',
          startsActive: isAirborne ?? Move.standardIsKnockbackAirborne,
          parentProportionality: .8,
          colorTheme: _colorTheme,
          lightingTheme: lightingTheme,
          onChanged: (value) {
            updateUndoRedo(() {});
          },
        ),
        BlockToggle(
          title: 'Type',
          width: BlockToggle.defaultWidth * .8,
          firstOption: ForcedMovementType.origin.name,
          secondOption: ForcedMovementType.direction.name,
          positionedLeft: (type ?? Move.standardKnockbackType) ==
              ForcedMovementType.origin.name,
          colorTheme: _colorTheme,
          lightingTheme: lightingTheme,
          onChanged: (value) {
            updateUndoRedo(() {});
          },
        ),
      ],
    );
  }

  void _addLunge({int? value, bool? isAirborne}) {
    _lungeTicker = TickerToggleableRow(
      title: MoveModifier.lunge.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: 304,
      startingValue: value ?? Move.standardLungeValue,
      lowerBound: Move.lungeLowerBound,
      upperBound: Move.lungeUpperBound,
      hasMenu: true,
      canDelete: true,
      onChanged: () {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.lunge.name)) {
          updateUndoRedo(() {
            _addLunge();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.lunge.name)) {
          updateUndoRedo(() {
            _restoreLunge();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.lunge.name)) {
          updateUndoRedo(() {
            _lungeTicker = null;
          });
        }
      },
      toggles: [
        SwitchToggle(
          title: 'Airborne',
          startsActive: isAirborne ?? Move.standardIsLungeAirborne,
          parentProportionality: .8,
          colorTheme: _colorTheme,
          lightingTheme: lightingTheme,
          onChanged: (value) {
            updateUndoRedo(() {});
          },
        ),
      ],
    );
  }

  void _addLOS({bool? value}) {
    _losTicker = TickerSwitch(
      title: MoveModifier.los.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      icon: Icons.circle,
      width: TickerSwitch.defaultWidth * .8,
      isSelected: value ?? !Move.defaultHasLOS,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.los.name)) {
          updateUndoRedo(() {
            _addLOS();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.los.name)) {
          updateUndoRedo(() {
            _restoreLOS();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.los.name)) {
          updateUndoRedo(() {
            _losTicker = null;
          });
        }
      },
    );
  }

  void _addRangeBoostable({bool? value}) {
    _rangeBoostableTicker = TickerSwitch(
      title: MoveModifier.rangeBoostable.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      icon: Icons.circle,
      width: TickerSwitch.defaultWidth * .8,
      isSelected: value ?? !Move.defaultIsRangeBoostable,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.rangeBoostable.name)) {
          updateUndoRedo(() {
            _addRangeBoostable();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.rangeBoostable.name)) {
          updateUndoRedo(() {
            _restoreRangeBoostable();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.rangeBoostable.name)) {
          updateUndoRedo(() {
            _rangeBoostableTicker = null;
          });
        }
      },
    );
  }

  void _addDirectContact({bool? value}) {
    _directContactTicker = TickerSwitch(
      title: MoveModifier.directContact.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      icon: Icons.circle,
      width: TickerSwitch.defaultWidth * .8,
      isSelected: value ?? !Move.defaultHasDirectContact,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.directContact.name)) {
          updateUndoRedo(() {
            _addDirectContact();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.directContact.name)) {
          updateUndoRedo(() {
            _restoreDirectContact();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.directContact.name)) {
          updateUndoRedo(() {
            _directContactTicker = null;
          });
        }
      },
    );
  }

  void _addUtility({String? selection}) {
    _utilityTicker = TickerSelect(
      title: MoveModifier.utility.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      selections: Utility.map,
      currentSelection: selection ?? Move.standardUtilityType,
      width: TickerSelect.defaultWidth * .8,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.utility.name)) {
          updateUndoRedo(() {
            _addUtility();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.utility.name)) {
          updateUndoRedo(() {
            _restoreUtility();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.utility.name)) {
          updateUndoRedo(() {
            _utilityTicker = null;
          });
        }
      },
    );
  }

  void _addCompoundingPower({bool? value}) {
    _compoundingPowerTicker = TickerSwitch(
      title: MoveModifier.compoundingPower.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      icon: Icons.circle,
      width: TickerSwitch.defaultWidth * .8,
      isSelected: value ?? !Move.defaultHasCompoundingPower,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.compoundingPower.name)) {
          updateUndoRedo(() {
            _addCompoundingPower();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.compoundingPower.name)) {
          updateUndoRedo(() {
            _restoreCompoundingPower();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.compoundingPower.name)) {
          updateUndoRedo(() {
            _compoundingPowerTicker = null;
          });
        }
      },
    );
  }

  void _addDeprecatingPower({bool? value}) {
    _deprecatingPowerTicker = TickerSwitch(
      title: MoveModifier.deprecatingPower.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      icon: Icons.circle,
      width: TickerSwitch.defaultWidth * .8,
      isSelected: value ?? !Move.defaultHasDeprecatingPower,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.deprecatingPower.name)) {
          updateUndoRedo(() {
            _addDeprecatingPower();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.deprecatingPower.name)) {
          updateUndoRedo(() {
            _restoreDeprecatingPower();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.deprecatingPower.name)) {
          updateUndoRedo(() {
            _deprecatingPowerTicker = null;
          });
        }
      },
    );
  }

  void _addMultiHit({int? value}) {
    _multiHitTicker = TickerBox(
      title: MoveModifier.multiHit.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerBox.defaultWidth * .8,
      startingValue: value ?? Move.standardMultiHitValue,
      lowerBound: Move.standardMultiHitLowerBound,
      upperBound: Move.standardMultiHitUpperBound,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.multiHit.name)) {
          updateUndoRedo(() {
            _addMultiHit();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.multiHit.name)) {
          updateUndoRedo(() {
            _restoreMultiHit();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.multiHit.name)) {
          updateUndoRedo(() {
            _multiHitTicker = null;
          });
        }
      },
    );
  }

  void _addPull(
      {int? value, bool? isAirborne, String? priority, String? type}) {
    _pullTicker = TickerToggleableRow(
      title: MoveModifier.pull.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerToggleableRow.defaultWidth * .8,
      startingValue: value ?? Move.standardPullValue,
      lowerBound: Move.pullLowerBound,
      upperBound: Move.pullUpperBound,
      hasMenu: true,
      canDelete: true,
      onChanged: () {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.pull.name)) {
          updateUndoRedo(() {
            _addPull();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.pull.name)) {
          updateUndoRedo(() {
            _restorePull();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.pull.name)) {
          updateUndoRedo(() {
            _pullTicker = null;
          });
        }
      },
      toggles: [
        SwitchToggle(
          title: 'Airborne',
          startsActive: isAirborne ?? Move.defaultIsPullAirborne,
          parentProportionality: .8,
          colorTheme: _colorTheme,
          lightingTheme: lightingTheme,
          onChanged: (value) {
            updateUndoRedo(() {});
          },
        ),
        BlockToggle(
          title: 'Priority',
          width: BlockToggle.defaultWidth * .8,
          firstOption: Priority.pre.name,
          secondOption: Priority.post.name,
          positionedLeft:
              (priority ?? Move.standardPullPriority) == Priority.pre.name,
          colorTheme: _colorTheme,
          lightingTheme: lightingTheme,
          onChanged: (value) {
            updateUndoRedo(() {});
          },
        ),
        BlockToggle(
          title: 'Type',
          width: BlockToggle.defaultWidth * .8,
          firstOption: ForcedMovementType.origin.name,
          secondOption: ForcedMovementType.direction.name,
          positionedLeft: (type ?? Move.standardPullType) !=
              ForcedMovementType.direction.name,
          colorTheme: _colorTheme,
          lightingTheme: lightingTheme,
          onChanged: (value) {
            updateUndoRedo(() {});
          },
        ),
      ],
    );
  }

  void _addBattleEffect({String? selection}) {
    _battleEffectTicker = TickerSelect(
      title: MoveModifier.battleEffect.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      selections: BattleEffect.map,
      currentSelection: selection ?? Move.standardBattleEffectType,
      width: TickerSelect.defaultWidth * .8,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.battleEffect.name)) {
          updateUndoRedo(() {
            _addBattleEffect();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.battleEffect.name)) {
          updateUndoRedo(() {
            _restoreBattleEffect();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.battleEffect.name)) {
          updateUndoRedo(() {
            _battleEffectTicker = null;
          });
        }
      },
    );
  }

  void _addBounceback({int? value, bool? isAirborne, String? priority}) {
    _bouncebackTicker = TickerToggleableRow(
      title: MoveModifier.bounceback.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerToggleableRow.defaultWidth * .8,
      startingValue: value ?? Move.standardBouncebackValue,
      lowerBound: Move.bouncebackLowerBound,
      upperBound: Move.bouncebackUpperBound,
      hasMenu: true,
      canDelete: true,
      onChanged: () {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.bounceback.name)) {
          updateUndoRedo(() {
            _addBounceback();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.bounceback.name)) {
          updateUndoRedo(() {
            _restoreBounceback();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.bounceback.name)) {
          updateUndoRedo(() {
            _bouncebackTicker = null;
          });
        }
      },
      toggles: [
        SwitchToggle(
          title: 'Airborne',
          startsActive: isAirborne ?? Move.standardIsBouncebackAirborne,
          parentProportionality: .8,
          colorTheme: _colorTheme,
          lightingTheme: lightingTheme,
          onChanged: (value) {
            updateUndoRedo(() {});
          },
        ),
        BlockToggle(
          title: 'Priority',
          width: BlockToggle.defaultWidth * .8,
          firstOption: Priority.pre.name,
          secondOption: Priority.post.name,
          positionedLeft: (priority ?? Move.standardBouncebackPriority) ==
              Priority.pre.name,
          colorTheme: _colorTheme,
          lightingTheme: lightingTheme,
          onChanged: (value) {
            updateUndoRedo(() {});
          },
        ),
      ],
    );
  }

  void _addRecoil({int? minVal, int? maxVal}) {
    _recoilTicker = TickerMinMax(
      title: MoveModifier.recoil.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerMinMax.defaultWidth * .8,
      lowerBound: Move.recoilLowerBound,
      upperBound: Move.recoilUpperBound,
      minStartingValue: minVal ?? Move.standardRecoilMin,
      maxStartingValue: maxVal ?? Move.standardRecoilMax,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.recoil.name)) {
          updateUndoRedo(() {
            _addRecoil();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.recoil.name)) {
          updateUndoRedo(() {
            _restoreRecoil();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.recoil.name)) {
          updateUndoRedo(() {
            _recoilTicker = null;
          });
        }
      },
    );
  }

  void _addCooldown({int? value}) {
    _cooldownTicker = TickerBox(
      title: MoveModifier.cooldown.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerBox.defaultWidth * .8,
      startingValue: value ?? Move.standardCooldownValue,
      lowerBound: Move.cooldownLowerBound,
      upperBound: Move.cooldownUpperBound,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.cooldown.name)) {
          updateUndoRedo(() {
            _addCooldown();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.cooldown.name)) {
          updateUndoRedo(() {
            _restoreCooldown();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.cooldown.name)) {
          updateUndoRedo(() {
            _cooldownTicker = null;
          });
        }
      },
    );
  }

  void _addSideEffect({String? selection}) {
    _sideEffectTicker = TickerSelect(
      title: MoveModifier.sideEffect.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      selections: BattleEffect.map,
      currentSelection: selection ?? Move.standardSideEffectType,
      width: TickerSelect.defaultWidth * .8,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.sideEffect.name)) {
          updateUndoRedo(() {
            _addSideEffect();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.sideEffect.name)) {
          updateUndoRedo(() {
            _restoreSideEffect();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.sideEffect.name)) {
          updateUndoRedo(() {
            _sideEffectTicker = null;
          });
        }
      },
    );
  }

  void _addCrashDamage({int? minVal, int? maxVal}) {
    _crashDamageTicker = TickerMinMax(
      title: MoveModifier.crashDamage.name,
      colorTheme: _colorTheme,
      lightingTheme: lightingTheme,
      width: TickerMinMax.defaultWidth * .8,
      lowerBound: Move.crashDamageLowerBound,
      upperBound: Move.crashDamageUpperBound,
      minStartingValue: minVal ?? Move.standardCrashDamageMin,
      maxStartingValue: maxVal ?? Move.standardCrashDamageMax,
      hasMenu: true,
      canDelete: true,
      onChanged: (value) {
        updateUndoRedo(() {});
      },
      onSetToDefault: () async {
        if (await _setToDefaultPopup(MoveModifier.crashDamage.name)) {
          updateUndoRedo(() {
            _addCrashDamage();
          });
        }
      },
      onRestore: () async {
        if (await _restorePopup(MoveModifier.crashDamage.name)) {
          updateUndoRedo(() {
            _restoreCrashDamage();
          });
        }
      },
      onDelete: () async {
        if (await _deletionPopup(MoveModifier.crashDamage.name)) {
          updateUndoRedo(() {
            _crashDamageTicker = null;
          });
        }
      },
    );
  }

  Widget _verticalSpacer() {
    return const SizedBox(
      height: 14 * .8,
    );
  }

  Widget _horizontalSpacer() {
    return const SizedBox(
      width: 14 * .8,
    );
  }

  Future<bool> _restoreAllPopup() async => await _confirmPopup(
        'Restore All',
        'Do you wish to restore all modifiers to their values from when the move was last saved?',
      );

  Future<bool> _setToDefaultPopup(String modifierName) async =>
      await _confirmPopup(
        'Set Modifier to Default',
        'Do you wish to set the $modifierName modifier to its default values?',
      );

  Future<bool> _restorePopup(
    String modifierName, {
    List<String> extraSubtexts = const [],
  }) async {
    String extraSubtext;
    if (extraSubtexts.isEmpty) {
      extraSubtext = '';
    } else {
      extraSubtext = '\n\nAdditional Changes:';
      for (String subtext in extraSubtexts) {
        extraSubtext += '\n\t - $subtext';
      }
    }
    return await _confirmPopup(
      'Restore Modifier',
      'Do you wish to restore the $modifierName modifier to its values from when it was last saved?$extraSubtext',
    );
  }

  Future<bool> _deletionPopup(String modifierName) async => await _confirmPopup(
        'Delete Modifier',
        'Do you wish to delete the $modifierName modifier?',
      );

  Future<bool> _confirmPopup(String title, String text) async =>
      await showDialog(
        context: context,
        builder: (context) => KoalaAlert(
          title: title,
          text: text,
        ),
      ) ??
      false;
}
