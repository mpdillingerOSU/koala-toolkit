import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/data/unit_palette.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/filters/unit_field_filter.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';

import '../../../components/checklist.dart';
import '../../../components/general/nav_bar.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/range.dart';
import '../../../koala_toolkit_back_end/filters/unit_filter.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';

class UnitFiltersPage extends KoalaPage {
  late final UnitFilter _initialFilter;
  late final UnitFilter _filter;

  UnitFiltersPage(
    UnitFilter filter, {
    super.key,
  }) {
    _initialFilter = filter;
    _filter = UnitFilter(UnitPalette(fields: []));
    _filter.setEqualTo(filter);
  }

  @override
  KoalaPageState<UnitFiltersPage> createState() => UnitFiltersPageState();
}

class UnitFiltersPageState extends KoalaPageState<UnitFiltersPage> {
  @override
  Future<void> subRefresh() async {}

  @override
  Widget build(BuildContext context) {
    List<ChecklistItem> items = [];
    for (UnitFieldFilter filter in widget._filter.getAll()) {
      List<ChecklistSubItem> subItems = [];
      if (filter is UnitFieldIntFilter) {
        subItems.add(_buildChecklistRange(filter));
      } else if (filter is UnitFieldStringFilter) {
        //TODO: Not implemented yet
      } else if (filter is UnitFieldEnumFilter) {
        subItems.add(_buildEnumSublist(filter));
      }

      bool isBoolFilter = filter is UnitFieldBoolFilter;

      items.add(
        ChecklistItem(
          text: filter.name,
          isSelected: filter.isApplied,
          onSelection: () {
            setState(() {
              widget._filter.get(filter.name)?.apply();
            });
          },
          onDeselection: () {
            setState(() {
              widget._filter.get(filter.name)?.clear();
            });
          },
          subItems: subItems,
          hasBlockToggle: isBoolFilter,
          blockToggleStart: isBoolFilter ? filter.val : true,
          onToggled: (value) {
            setState(() {
              if (isBoolFilter) {
                filter.val = value;
              }
            });
          },
        ),
      );
    }

    return AdvancedScaffold(
      pageTitle: 'Filter Units',
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
        children: items,
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

  Future<bool> _onWillPop() async =>
      widget._filter.equals(widget._initialFilter) ||
      (await showDialog(
            context: context,
            builder: (context) => const KoalaAlert(
              title: 'Discard Changes',
              text: 'Do you wish to discard all changes made to the filters?',
            ),
          ) ??
          false);

  ChecklistSublist _buildEnumSublist(UnitFieldEnumFilter filter) {
    List<ChecklistSubCheckbox> items = [];
    for (String value in filter.values) {
      items.add(
        ChecklistSubCheckbox(
          text: value,
          isSelected: filter.filters.contains(value),
          onSelection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            filter.addFilter(value);
          },
          onDeselection: () {
            //No setState, as it is not necessary, and it actually closes the
            // expanded sublists...
            filter.removeFilter(value);
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

  ChecklistRange _buildChecklistRange(UnitFieldIntFilter filter) {
    return ChecklistRange(
      text: filter.name,
      range: Range(filter.minVal, filter.maxVal),
      lowerVal: filter.valRange.lowerBound,
      upperVal: filter.valRange.upperBound,
      onChange: (range) {
        //No setState, as it is not necessary, and it actually closes the
        // expanded sublists...
        filter.valRange = range;
      },
    );
  }
}
