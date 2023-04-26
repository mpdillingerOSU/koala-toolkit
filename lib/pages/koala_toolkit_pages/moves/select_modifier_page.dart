import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/move_modifier_restrictor.dart';

import '../../../components/general/koala_scrollbar.dart';
import '../../../components/general/nav_bar.dart';
import '../../../components/general/tap_detector.dart';
import '../../../koala_toolkit_back_end/move_modifier.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';
import '../popups/koala_alert.dart';

class ModifierSelectionPage extends KoalaPage {
  MoveModifierRestrictor restrictor;

  ModifierSelectionPage(
    this.restrictor, {
    super.key,
  });

  @override
  KoalaPageState<ModifierSelectionPage> createState() =>
      ModifierSelectionPageState();
}

class ModifierSelectionPageState extends KoalaPageState<ModifierSelectionPage> {
  late final SelectableList list;

  @override
  Future<void> subRefresh() async {}

  @override
  initState() {
    super.initState();
    list = SelectableList(widget.restrictor);
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedScaffold(
      pageTitle: 'Add Modifier',
      barColor: Colors.blue,
      barTextColor: MyConstants.primaryColor,
      actions: [
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
      body: Scrollbar(
        child: list,
      ),
      bottomNavigationBar: TextNavBar(
        context,
        onPressed: () async {
          if (list._selection == null) {
            bool confirm = await showDialog(
              context: context,
              builder: (context) => const KoalaAlert(
                title: 'No Modifier Selected',
                text:
                    'You have not yet selected a modifier. Do you wish to leave anyways?',
              ),
            );

            if (confirm && mounted) {
              Navigator.pop(context);
            }
          } else {
            Navigator.pop(context, list._selection);
          }
        },
        text: 'CONFIRM',
        textColor: Colors.white,
        barColor: Colors.blue,
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async =>
      list._selection == null ||
      (await showDialog(
            context: context,
            builder: (context) => const KoalaAlert(
              title: 'Discard New Modifier',
              text:
                  'Do you wish to discard the addition of the selected modifier?',
            ),
          ) ??
          false);
}

class SelectableList extends StatefulWidget {
  MoveModifier? _selection;
  final MoveModifierRestrictor restrictor;

  SelectableList(
    this.restrictor, {
    super.key,
  });

  @override
  State<SelectableList> createState() => SelectableListState();
}

class SelectableListState extends State<SelectableList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: _generateList(MediaQuery.of(context).size.height * .1),
      ),
    );
  }

  List<ListSelection> _generateList(double selectionHeight) {
    List<ListSelection> returnList = [];
    List<MoveModifier> modifiers = MoveModifier.values;
    for (int i = 0; i < modifiers.length; i++) {
      returnList.add(
        ListSelection(
          parent: this,
          modifier: modifiers[i],
          selectionHeight: selectionHeight,
          ordinal: i,
          isSelected: modifiers[i] == widget._selection,
          restrictions: widget.restrictor.restrictions[modifiers[i]],
        ),
      );
    }
    return returnList;
  }

  void select(MoveModifier modifier) {
    setState(() {
      widget._selection = modifier;
    });
  }
}

class ListSelection extends StatelessWidget {
  const ListSelection({
    super.key,
    required this.parent,
    required this.modifier,
    required this.selectionHeight,
    required this.ordinal,
    required this.isSelected,
    required this.restrictions,
  });

  final SelectableListState parent;
  final MoveModifier modifier;
  final double selectionHeight;
  final int ordinal;
  final bool isSelected;
  final RestrictionPair? restrictions;

  @override
  Widget build(BuildContext context) {
    String restrictionSubtext = '';
    if (restrictions != null) {
      restrictionSubtext =
          'The $modifier cannot be selected for the following reasons:\n';
      for (String reason in restrictions!.reasons) {
        restrictionSubtext += '\n\t - $reason';
      }
    }

    return TapDetector(
      onTap: () {
        if (restrictions == null) {
          parent.select(modifier);
        }
      },
      child: Container(
        height: selectionHeight,
        width: double.infinity,
        padding: EdgeInsets.only(
          left: selectionHeight * .25,
          right: selectionHeight * .25,
        ),
        color: isSelected
            ? Colors.lightBlueAccent.shade100
            : restrictions == null
                ? Colors.white
                : Colors.grey.shade400,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  modifier.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.blue.shade700
                        : restrictions == null
                            ? Colors.blue
                            : Colors.grey.shade700,
                    fontSize: selectionHeight / 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: selectionHeight * .25,
              ),
              child: Center(
                child: TapDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => KoalaSimpleAlert(
                        title: modifier.name,
                        text: modifier.description,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: isSelected
                        ? Colors.blue.shade700
                        : restrictions == null
                            ? Colors.blue
                            : Colors.grey.shade700,
                    size: selectionHeight / 2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: selectionHeight * .25,
              ),
              child: Center(
                child: TapDetector(
                  onTap: () {
                    if (restrictions != null) {
                      showDialog(
                        context: context,
                        builder: (context) => KoalaSimpleAlert(
                          title: 'Cannot be Selected',
                          text: restrictionSubtext,
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: restrictions == null
                        ? isSelected
                            ? Colors.grey.shade600
                            : Colors.grey
                        : Colors.orange.shade400,
                    size: selectionHeight / 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
