import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/filters/move_filter.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/battle_effect.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/modifier_move_timing.dart';

import '../../../components/checklist.dart';
import '../../../components/general/nav_bar.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/range.dart';
import '../../../koala_toolkit_back_end/move_element.dart';
import '../../../koala_toolkit_back_end/forced_movement_type.dart';
import '../../../koala_toolkit_back_end/data/moves/move.dart';
import '../../../koala_toolkit_back_end/move_modifier.dart';
import '../../../koala_toolkit_back_end/move_type.dart';
import '../../../koala_toolkit_back_end/utility.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';
import '../popups/koala_alert.dart';

class MoveFiltersPage extends KoalaPage {
  late final MoveFilter _initialFilter;
  late final MoveFilter _filter;

  MoveFiltersPage(
    MoveFilter filter, {
    super.key,
  }) {
    _initialFilter = filter;
    _filter = MoveFilter();
    _filter.setEqualTo(filter);
  }

  @override
  KoalaPageState<MoveFiltersPage> createState() => MoveFiltersPageState();
}

class MoveFiltersPageState extends KoalaPageState<MoveFiltersPage> {
  @override
  Future<void> subRefresh() async {}

  @override
  Widget build(BuildContext context) {
    return AdvancedScaffold(
      pageTitle: 'Filter Moves',
      barColor: Colors.blue,
      barTextColor: MyConstants.primaryColor,
      actions: [
        TapDetector(
          onTap: () async {
            final bool confirm = await showDialog(
                  context: context,
                  builder: (context) => const KoalaAlert(
                    title: 'Clear All Filters',
                    text: 'Do you wish to clear all filters?',
                  ),
                ) ??
                false;

            if (confirm) {
              setState(() {
                widget._filter.clearAll();
              });
            }
          },
          child: const Center(
            child: Icon(
              Icons.delete_sweep_outlined,
              color: Colors.white,
              size: 30,
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
              color: MyConstants.primaryColor,
              size: 32,
            ),
          ),
        ),
      ],
      body: Checklist(
        childrenHeight: MediaQuery.of(context).size.height * .1,
        lightingTheme: lightingTheme,
        children: [
          _buildElementFilter(),
          _buildMoveTypeFilter(),
          _buildEnergyCostFilter(),
          _buildPowerFilter(),
          _buildRangeFilter(),
          _buildAccuracyFilter(),
          _buildKnockbackFilter(),
          _buildLungeFilter(),
          _buildLOSFilter(),
          _buildRangeBoostableFilter(),
          _buildDirectContactFilter(),
          _buildUtilityFilter(),
          _buildCompoundingPowerFilter(),
          _buildDeprecatingPowerFilter(),
          _buildMultiHitFilter(),
          _buildPullFilter(),
          _buildBattleEffectFilter(),
          _buildBouncebackFilter(),
          _buildRecoilFilter(),
          _buildCooldownFilter(),
          _buildSideEffectFilter(),
          _buildCrashDamageFilter(),
        ],
      ),
      bottomNavigationBar: TextNavBar(
        context,
        onPressed: () {
          Navigator.pop(context, widget._filter);
        },
        text: 'CONFIRM',
        textColor: Colors.white,
        barColor: Colors.blue,
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    if (widget._filter.equals(widget._initialFilter)) return true;

    return await showDialog(
          context: context,
          builder: (context) => const KoalaAlert(
            title: 'Discard Changes',
            text: 'Do you wish to discard all changes made to the filters?',
          ),
        ) ??
        false;
  }

  ChecklistItem _buildElementFilter() {
    return ChecklistItem(
      text: 'Element',
      isSelected: widget._filter.elementFilters != null,
      onSelection: () {
        setState(() {
          widget._filter.applyAllElementFilters();
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearElementFilters();
        });
      },
      subItems: [
        _buildElementTypeSublist(),
      ],
    );
  }

  ChecklistSublist _buildElementTypeSublist() {
    List<ChecklistSubCheckbox> items = [];
    for (MoveElement element in MoveElement.values) {
      items.add(
        ChecklistSubCheckbox(
          text: element.toString(),
          isSelected:
              widget._filter.elementFilters?.contains(element.toString()) ??
                  false,
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.addElementFilter(element.toString());
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.removeElementFilter(element.toString());
          },
        ),
      );
    }
    return ChecklistSublist(
      text: 'Types',
      hasAnyCheckbox: true,
      fillOnEmpty: true,
      checkboxes: items,
    );
  }

  ChecklistItem _buildMoveTypeFilter() {
    return ChecklistItem(
      text: 'Move Type',
      isSelected: widget._filter.moveTypeFilters != null,
      onSelection: () {
        setState(() {
          widget._filter.applyAllMoveTypeFilters();
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearMoveTypeFilters();
        });
      },
      subItems: [
        _buildMoveTypeSublist(),
      ],
    );
  }

  ChecklistSublist _buildMoveTypeSublist() {
    List<ChecklistSubCheckbox> items = [];
    for (MoveType moveType in MoveType.values) {
      items.add(
        ChecklistSubCheckbox(
          text: moveType.toString(),
          isSelected:
              widget._filter.moveTypeFilters?.contains(moveType.toString()) ??
                  false,
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.addMoveTypeFilter(moveType.toString());
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.removeMoveTypeFilter(moveType.toString());
          },
        ),
      );
    }
    return ChecklistSublist(
      text: 'Types',
      hasAnyCheckbox: true,
      fillOnEmpty: true,
      checkboxes: items,
    );
  }

  ChecklistItem _buildEnergyCostFilter() {
    return ChecklistItem(
      text: 'Energy Cost',
      isSelected: widget._filter.energyCostFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setEnergyCostFilter(Range.unbounded);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearEnergyCostFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Value',
          range: Range(Move.energyCostLowerBound, Move.energyCostUpperBound),
          lowerVal: widget._filter.energyCostFilter?.lowerBound,
          upperVal: widget._filter.energyCostFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setEnergyCostFilter(range);
          },
        ),
      ],
    );
  }

  ChecklistItem _buildPowerFilter() {
    return ChecklistItem(
      text: 'Power',
      isSelected: widget._filter.hasPowerFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasPowerFilter(true);
          widget._filter.setPowerMinFilter(Range.unbounded);
          widget._filter.setPowerMaxFilter(Range.unbounded);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasPowerFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Minimum Value',
          range: Range(Move.powerLowerBound, Move.powerUpperBound),
          lowerVal: widget._filter.powerMinFilter?.lowerBound,
          upperVal: widget._filter.powerMinFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setPowerMinFilter(range);
          },
        ),
        ChecklistRange(
          text: 'Maximum Value',
          range: Range(Move.powerLowerBound, Move.powerUpperBound),
          lowerVal: widget._filter.powerMaxFilter?.lowerBound,
          upperVal: widget._filter.powerMaxFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setPowerMaxFilter(range);
          },
        ),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasPowerFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasPowerFilter(value);
          if (value) {
            widget._filter.setPowerMinFilter(Range.unbounded);
            widget._filter.setPowerMaxFilter(Range.unbounded);
          } else {
            widget._filter.clearPowerMinFilter();
            widget._filter.clearPowerMaxFilter();
          }
        });
      },
    );
  }

  ChecklistItem _buildRangeFilter() {
    return ChecklistItem(
      text: 'Range',
      isSelected: widget._filter.rangeFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setRangeFilter(Range.unbounded);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearRangeFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Value',
          range: Range(Move.rangeLowerBound, Move.rangeUpperBound),
          lowerVal: widget._filter.rangeFilter?.lowerBound,
          upperVal: widget._filter.rangeFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setRangeFilter(range);
          },
        ),
      ],
    );
  }

  ChecklistItem _buildAccuracyFilter() {
    return ChecklistItem(
      text: 'Accuracy',
      isSelected: widget._filter.accuracyFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setAccuracyFilter(Range.unbounded);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearAccuracyFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Value',
          range: Range(Move.accuracyLowerBound, Move.accuracyUpperBound),
          lowerVal: widget._filter.accuracyFilter?.lowerBound,
          upperVal: widget._filter.accuracyFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setAccuracyFilter(range);
          },
        ),
      ],
    );
  }

  ChecklistItem _buildKnockbackFilter() {
    return ChecklistItem(
      text: MoveModifier.knockback.name,
      isSelected: widget._filter.hasKnockbackFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasKnockbackFilter(true);
          widget._filter.setKnockbackValueFilter(Range.unbounded);
          widget._filter.applyAllKnockbackTypeFilters();
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasKnockbackFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Value',
          range: Range(Move.knockbackLowerBound, Move.knockbackUpperBound),
          lowerVal: widget._filter.knockbackValueFilter?.lowerBound,
          upperVal: widget._filter.knockbackValueFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setKnockbackValueFilter(range);
          },
        ),
        ChecklistToggle(
          text: 'Airborne',
          isToggledOn: widget._filter.knockbackAirborneFilter ?? true,
          canToggleActivation: true,
          isActive: widget._filter.knockbackAirborneFilter != null,
          onToggle: (value) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setKnockbackAirborneFilter(value);
          },
        ),
        _buildKnockbackTypeSublist(),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasKnockbackFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasKnockbackFilter(value);
          if (value) {
            widget._filter.setKnockbackValueFilter(Range.unbounded);
            widget._filter.applyAllKnockbackTypeFilters();
          } else {
            widget._filter.clearKnockbackValueFilter();
            widget._filter.clearKnockbackAirborneFilter();
            widget._filter.clearKnockbackTypeFilters();
          }
        });
      },
    );
  }

  ChecklistSublist _buildKnockbackTypeSublist() {
    List<ChecklistSubCheckbox> items = [];
    for (ForcedMovementType type in ForcedMovementType.values) {
      items.add(
        ChecklistSubCheckbox(
          text: type.toString(),
          isSelected:
              widget._filter.knockbackTypeFilters?.contains(type.toString()) ??
                  false,
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.addKnockbackTypeFilter(type.toString());
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.removeKnockbackTypeFilter(type.toString());
          },
        ),
      );
    }
    return ChecklistSublist(
      text: 'Types',
      hasAnyCheckbox: true,
      fillOnEmpty: true,
      checkboxes: items,
    );
  }

  ChecklistItem _buildLungeFilter() {
    return ChecklistItem(
      text: MoveModifier.lunge.name,
      isSelected: widget._filter.hasLungeFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasLungeFilter(true);
          widget._filter.setLungeValueFilter(Range.unbounded);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasLungeFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Value',
          range: Range(Move.lungeLowerBound, Move.lungeUpperBound),
          lowerVal: widget._filter.lungeValueFilter?.lowerBound,
          upperVal: widget._filter.lungeValueFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setLungeValueFilter(range);
          },
        ),
        ChecklistToggle(
          text: 'Airborne',
          isToggledOn: widget._filter.lungeAirborneFilter ?? true,
          canToggleActivation: true,
          isActive: widget._filter.lungeAirborneFilter != null,
          onToggle: (value) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setLungeAirborneFilter(value);
          },
        ),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasLungeFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasLungeFilter(value);
          if (value) {
            widget._filter.setLungeValueFilter(Range.unbounded);
          } else {
            widget._filter.clearLungeValueFilter();
            widget._filter.clearLungeAirborneFilter();
          }
        });
      },
    );
  }

  ChecklistItem _buildLOSFilter() {
    return ChecklistItem(
      text: MoveModifier.los.name,
      isSelected: widget._filter.hasLOSFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasLOSFilter(true);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasLOSFilter();
        });
      },
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasLOSFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasLOSFilter(value);
        });
      },
    );
  }

  ChecklistItem _buildRangeBoostableFilter() {
    return ChecklistItem(
      text: MoveModifier.rangeBoostable.name,
      isSelected: widget._filter.hasRangeBoostableFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasRangeBoostableFilter(true);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasRangeBoostableFilter();
        });
      },
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasRangeBoostableFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasRangeBoostableFilter(value);
        });
      },
    );
  }

  ChecklistItem _buildDirectContactFilter() {
    return ChecklistItem(
      text: MoveModifier.directContact.name,
      isSelected: widget._filter.hasDirectContactFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasDirectContactFilter(true);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasDirectContactFilter();
        });
      },
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasDirectContactFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasDirectContactFilter(value);
        });
      },
    );
  }

  ChecklistItem _buildUtilityFilter() {
    return ChecklistItem(
      text: MoveModifier.utility.name,
      isSelected: widget._filter.hasUtilityFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasUtilityFilter(true);
          widget._filter.applyAllUtilityFilters();
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasUtilityFilter();
        });
      },
      subItems: [
        _buildUtilityTypeSublist(),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasUtilityFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasUtilityFilter(value);
          value
              ? widget._filter.applyAllUtilityFilters()
              : widget._filter.clearUtilityFilters();
        });
      },
    );
  }

  ChecklistSublist _buildUtilityTypeSublist() {
    List<ChecklistSubCheckbox> items = [];
    for (Utility utility in Utility.values) {
      items.add(
        ChecklistSubCheckbox(
          text: utility.toString(),
          isSelected:
              widget._filter.utilityFilters?.contains(utility.toString()) ??
                  false,
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.addUtilityFilter(utility.toString());
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.removeUtilityFilter(utility.toString());
          },
        ),
      );
    }
    return ChecklistSublist(
      text: 'Types',
      hasAnyCheckbox: true,
      fillOnEmpty: true,
      checkboxes: items,
    );
  }

  ChecklistItem _buildCompoundingPowerFilter() {
    return ChecklistItem(
      text: MoveModifier.compoundingPower.name,
      isSelected: widget._filter.hasCompoundingPowerFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasCompoundingPowerFilter(true);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasCompoundingPowerFilter();
        });
      },
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasCompoundingPowerFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasCompoundingPowerFilter(value);
        });
      },
    );
  }

  ChecklistItem _buildDeprecatingPowerFilter() {
    return ChecklistItem(
      text: MoveModifier.deprecatingPower.name,
      isSelected: widget._filter.hasDeprecatingPowerFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasDeprecatingPowerFilter(true);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasDeprecatingPowerFilter();
        });
      },
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasDeprecatingPowerFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasDeprecatingPowerFilter(value);
        });
      },
    );
  }

  ChecklistItem _buildMultiHitFilter() {
    return ChecklistItem(
      text: MoveModifier.multiHit.name,
      isSelected: widget._filter.hasMultiHitFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasMultiHitFilter(true);
          widget._filter.setMultiHitValueFilter(Range.unbounded);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasMultiHitFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Value',
          range: Range(
              Move.standardMultiHitLowerBound, Move.standardMultiHitUpperBound),
          lowerVal: widget._filter.multiHitValueFilter?.lowerBound,
          upperVal: widget._filter.multiHitValueFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setMultiHitValueFilter(range);
          },
        ),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasMultiHitFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasMultiHitFilter(value);
          value
              ? widget._filter.setMultiHitValueFilter(Range.unbounded)
              : widget._filter.clearMultiHitValueFilter();
        });
      },
    );
  }

  ChecklistItem _buildPullFilter() {
    return ChecklistItem(
      text: MoveModifier.pull.name,
      isSelected: widget._filter.hasPullFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasPullFilter(true);
          widget._filter.setPullValueFilter(Range.unbounded);
          widget._filter.applyAllPullTypeFilters();
          widget._filter.applyAllPullPriorityFilters();
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasPullFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Value',
          range: Range(Move.pullLowerBound, Move.pullUpperBound),
          lowerVal: widget._filter.pullValueFilter?.lowerBound,
          upperVal: widget._filter.pullValueFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setPullValueFilter(range);
          },
        ),
        ChecklistToggle(
          text: 'Airborne',
          isToggledOn: widget._filter.pullAirborneFilter ?? true,
          canToggleActivation: true,
          isActive: widget._filter.pullAirborneFilter != null,
          onToggle: (value) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setPullAirborneFilter(value);
          },
        ),
        _buildPullTypeSublist(),
        _buildPullPrioritySublist()
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasPullFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasPullFilter(value);
          if (value) {
            widget._filter.setPullValueFilter(Range.unbounded);
            widget._filter.applyAllPullTypeFilters();
            widget._filter.applyAllPullPriorityFilters();
          } else {
            widget._filter.clearPullValueFilter();
            widget._filter.clearPullAirborneFilter();
            widget._filter.clearPullTypeFilters();
            widget._filter.clearPullPriorityFilters();
          }
        });
      },
    );
  }

  ChecklistSublist _buildPullTypeSublist() {
    List<ChecklistSubCheckbox> items = [];
    for (ForcedMovementType type in ForcedMovementType.values) {
      items.add(
        ChecklistSubCheckbox(
          text: type.toString(),
          isSelected:
              widget._filter.pullTypeFilters?.contains(type.toString()) ??
                  false,
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.addPullTypeFilter(type.toString());
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.removePullTypeFilter(type.toString());
          },
        ),
      );
    }
    return ChecklistSublist(
      text: 'Types',
      hasAnyCheckbox: true,
      fillOnEmpty: true,
      checkboxes: items,
    );
  }

  ChecklistSublist _buildPullPrioritySublist() {
    List<ChecklistSubCheckbox> items = [];
    for (Priority priority in Priority.values) {
      items.add(
        ChecklistSubCheckbox(
          text: priority.toString(),
          isSelected: widget._filter.pullPriorityFilters
                  ?.contains(priority.toString()) ??
              false,
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.addPullPriorityFilter(priority.toString());
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.removePullPriorityFilter(priority.toString());
          },
        ),
      );
    }
    return ChecklistSublist(
      text: 'Prioritys',
      hasAnyCheckbox: true,
      fillOnEmpty: true,
      checkboxes: items,
    );
  }

  ChecklistItem _buildBouncebackFilter() {
    return ChecklistItem(
      text: MoveModifier.bounceback.name,
      isSelected: widget._filter.hasBouncebackFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasBouncebackFilter(true);
          widget._filter.setBouncebackValueFilter(Range.unbounded);
          widget._filter.applyAllBouncebackPriorityFilters();
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasBouncebackFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Value',
          range: Range(Move.bouncebackLowerBound, Move.bouncebackUpperBound),
          lowerVal: widget._filter.bouncebackValueFilter?.lowerBound,
          upperVal: widget._filter.bouncebackValueFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setBouncebackValueFilter(range);
          },
        ),
        ChecklistToggle(
          text: 'Airborne',
          isToggledOn: widget._filter.bouncebackAirborneFilter ?? true,
          canToggleActivation: true,
          isActive: widget._filter.bouncebackAirborneFilter != null,
          onToggle: (value) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setBouncebackAirborneFilter(value);
          },
        ),
        _buildBouncebackPrioritySublist()
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasBouncebackFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasBouncebackFilter(value);
          if (value) {
            widget._filter.setBouncebackValueFilter(Range.unbounded);
            widget._filter.applyAllBouncebackPriorityFilters();
          } else {
            widget._filter.clearBouncebackValueFilter();
            widget._filter.clearBouncebackAirborneFilter();
            widget._filter.clearBouncebackPriorityFilters();
          }
        });
      },
    );
  }

  ChecklistSublist _buildBouncebackPrioritySublist() {
    List<ChecklistSubCheckbox> items = [];
    for (Priority priority in Priority.values) {
      items.add(
        ChecklistSubCheckbox(
          text: priority.toString(),
          isSelected: widget._filter.bouncebackPriorityFilters
                  ?.contains(priority.toString()) ??
              false,
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.addBouncebackPriorityFilter(priority.toString());
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.removeBouncebackPriorityFilter(priority.toString());
          },
        ),
      );
    }
    return ChecklistSublist(
      text: 'Prioritys',
      hasAnyCheckbox: true,
      fillOnEmpty: true,
      checkboxes: items,
    );
  }

  ChecklistItem _buildBattleEffectFilter() {
    return ChecklistItem(
      text: MoveModifier.battleEffect.name,
      isSelected: widget._filter.hasBattleEffectFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasBattleEffectFilter(true);
          widget._filter.applyAllBattleEffectFilters();
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasBattleEffectFilter();
        });
      },
      subItems: [
        _buildBattleEffectTypeSublist(),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasBattleEffectFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasBattleEffectFilter(value);
          value
              ? widget._filter.applyAllBattleEffectFilters()
              : widget._filter.clearBattleEffectFilters();
        });
      },
    );
  }

  ChecklistSublist _buildBattleEffectTypeSublist() {
    List<ChecklistSubCheckbox> items = [];
    for (BattleEffect battleEffect in BattleEffect.values) {
      items.add(
        ChecklistSubCheckbox(
          text: battleEffect.toString(),
          isSelected: widget._filter.battleEffectFilters
                  ?.contains(battleEffect.toString()) ??
              false,
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.addBattleEffectFilter(battleEffect.toString());
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.removeBattleEffectFilter(battleEffect.toString());
          },
        ),
      );
    }
    return ChecklistSublist(
      text: 'Types',
      hasAnyCheckbox: true,
      fillOnEmpty: true,
      checkboxes: items,
    );
  }

  ChecklistItem _buildRecoilFilter() {
    return ChecklistItem(
      text: MoveModifier.recoil.name,
      isSelected: widget._filter.hasRecoilFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasRecoilFilter(true);
          widget._filter.setRecoilMinFilter(Range.unbounded);
          widget._filter.setRecoilMaxFilter(Range.unbounded);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasRecoilFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Minimum Value',
          range: Range(Move.recoilLowerBound, Move.recoilUpperBound),
          lowerVal: widget._filter.recoilMinFilter?.lowerBound,
          upperVal: widget._filter.recoilMinFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setRecoilMinFilter(range);
          },
        ),
        ChecklistRange(
          text: 'Maximum Value',
          range: Range(Move.recoilLowerBound, Move.recoilUpperBound),
          lowerVal: widget._filter.recoilMaxFilter?.lowerBound,
          upperVal: widget._filter.recoilMaxFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setRecoilMaxFilter(range);
          },
        ),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasRecoilFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasRecoilFilter(value);
          if (value) {
            widget._filter.setRecoilMinFilter(Range.unbounded);
            widget._filter.setRecoilMaxFilter(Range.unbounded);
          } else {
            widget._filter.clearRecoilMinFilter();
            widget._filter.clearRecoilMaxFilter();
          }
        });
      },
    );
  }

  ChecklistItem _buildCooldownFilter() {
    return ChecklistItem(
      text: MoveModifier.cooldown.name,
      isSelected: widget._filter.hasCooldownFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasCooldownFilter(true);
          widget._filter.setCooldownValueFilter(Range.unbounded);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasCooldownFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Value',
          range: Range(Move.cooldownLowerBound, Move.cooldownUpperBound),
          lowerVal: widget._filter.cooldownValueFilter?.lowerBound,
          upperVal: widget._filter.cooldownValueFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setCooldownValueFilter(range);
          },
        ),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasCooldownFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasCooldownFilter(value);
          value
              ? widget._filter.setCooldownValueFilter(Range.unbounded)
              : widget._filter.clearCooldownValueFilter();
        });
      },
    );
  }

  ChecklistItem _buildSideEffectFilter() {
    return ChecklistItem(
      text: MoveModifier.sideEffect.name,
      isSelected: widget._filter.hasSideEffectFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasSideEffectFilter(true);
          widget._filter.applyAllSideEffectFilters();
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasSideEffectFilter();
        });
      },
      subItems: [
        _buildSideEffectTypeSublist(),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasSideEffectFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasSideEffectFilter(value);
          value
              ? widget._filter.applyAllSideEffectFilters()
              : widget._filter.clearSideEffectFilters();
        });
      },
    );
  }

  ChecklistSublist _buildSideEffectTypeSublist() {
    List<ChecklistSubCheckbox> items = [];
    for (BattleEffect sideEffect in BattleEffect.values) {
      items.add(
        ChecklistSubCheckbox(
          text: sideEffect.toString(),
          isSelected: widget._filter.sideEffectFilters
                  ?.contains(sideEffect.toString()) ??
              false,
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.addSideEffectFilter(sideEffect.toString());
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.removeSideEffectFilter(sideEffect.toString());
          },
        ),
      );
    }
    return ChecklistSublist(
      text: 'Types',
      hasAnyCheckbox: true,
      fillOnEmpty: true,
      checkboxes: items,
    );
  }

  ChecklistItem _buildCrashDamageFilter() {
    return ChecklistItem(
      text: MoveModifier.crashDamage.name,
      isSelected: widget._filter.hasCrashDamageFilter != null,
      onSelection: () {
        setState(() {
          widget._filter.setHasCrashDamageFilter(true);
          widget._filter.setCrashDamageMinFilter(Range.unbounded);
          widget._filter.setCrashDamageMaxFilter(Range.unbounded);
        });
      },
      onDeselection: () {
        setState(() {
          widget._filter.clearHasCrashDamageFilter();
        });
      },
      subItems: [
        ChecklistRange(
          text: 'Minimum Value',
          range: Range(Move.crashDamageLowerBound, Move.crashDamageUpperBound),
          lowerVal: widget._filter.crashDamageMinFilter?.lowerBound,
          upperVal: widget._filter.crashDamageMinFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setCrashDamageMinFilter(range);
          },
        ),
        ChecklistRange(
          text: 'Maximum Value',
          range: Range(Move.crashDamageLowerBound, Move.crashDamageUpperBound),
          lowerVal: widget._filter.crashDamageMaxFilter?.lowerBound,
          upperVal: widget._filter.crashDamageMaxFilter?.upperBound,
          onChange: (range) {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            widget._filter.setCrashDamageMaxFilter(range);
          },
        ),
      ],
      hasBlockToggle: true,
      blockToggleStart: widget._filter.hasCrashDamageFilter ?? true,
      onToggled: (value) {
        setState(() {
          widget._filter.setHasCrashDamageFilter(value);
          if (value) {
            widget._filter.setCrashDamageMinFilter(Range.unbounded);
            widget._filter.setCrashDamageMaxFilter(Range.unbounded);
          } else {
            widget._filter.clearCrashDamageMinFilter();
            widget._filter.clearCrashDamageMaxFilter();
          }
        });
      },
    );
  }
}
