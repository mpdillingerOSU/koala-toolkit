import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/drag_drop_column.dart';
import 'package:gaming_toolkit/components/general/scaffold_console.dart';
import 'package:gaming_toolkit/components/general/tap_detector.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';
import 'package:gaming_toolkit/user_preferences.dart';

import '../../components/tickers/block_ticker.dart';
import '../../my_constants.dart';
import 'koala_page.dart';

class SettingsPage extends KoalaPage {
  const SettingsPage({super.key});

  @override
  KoalaPageState<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends KoalaPageState<SettingsPage> {
  @override
  Future<void> subRefresh() async {}

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double saveButtonHeight = screenHeight * .085;
    return AdvancedScaffold(
      pageTitle: 'Settings',
      onWillPop: () async {
        if (!haveBeenChanges) return true;

        return await showDialog(
              context: context,
              builder: (context) => const KoalaAlert(
                title: 'Discard Changes',
                text:
                    'Do you wish to discard all changes made to your settings?',
              ),
            ) ??
            false;
      },
      body: Center(
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
              SizedBox(
                height: screenHeight * .025,
              ),
              /*
              BlockTickerSelect(
                title: 'Lighting Theme',
                lightingTheme: lightingTheme,
                width: screenWidth * .75,
                onChange: (val) {
                  lightingTheme = val == 'Light'
                      ? TickerLightingTheme.lightTheme
                      : TickerLightingTheme.darkTheme;
                },
                selections: const ['Light', 'Dark'],
                currentSelection:
                    lightingTheme == TickerLightingTheme.lightTheme
                        ? 'Light'
                        : 'Dark',
                clickableTitle: 'Lighting Theme',
                clickableText:
                    'Changes the desired lighting theme of the application.',
              ),
              _Buffer(),
               */
              BlockTickerRow(
                title: 'Max Undos',
                lightingTheme: lightingTheme,
                width: screenWidth * .75,
                onChange: (val) {
                  maxUndos = val;
                },
                startingValue: maxUndos,
                lowerBound: 20,
                upperBound: 250,
                clickableTitle: 'Max Undos',
                clickableText:
                    'Changes the maximum number of undos that can be stored by the application when editing.',
              ),
              _Buffer(),
              BlockTickerRow(
                title: 'Drag Scroll Speed',
                lightingTheme: lightingTheme,
                width: screenWidth * .75,
                onChange: (val) {
                  dragScrollSpeed = val;
                },
                startingValue: dragScrollSpeed,
                lowerBound: kDragScrollSpeedMin,
                upperBound: kDragScrollSpeedMax,
                clickableTitle: 'Drag Scroll Speed',
                clickableText:
                    'Changes the speed at which scrolling occurs when dragging a given element of a draggable list.',
              ),
              TapDetector(
                onTap: () async {
                  if (haveBeenChanges) {
                    await UserPreferences.setMaxUndos(maxUndos);
                    await UserPreferences.setDragScrollSpeed(dragScrollSpeed);
                    await UserPreferences.setLightingTheme(lightingTheme);
                    setState(() {});
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * .075,
                    horizontal: screenWidth * .1,
                  ),
                  child: Container(
                    height: saveButtonHeight,
                    decoration: BoxDecoration(
                      color: haveBeenChanges
                          ? const Color(0xFF42D2FF)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(25 * .8),
                      border: Border.all(
                        color: haveBeenChanges
                            ? MyConstants.borderColor
                            : Colors.black26,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: lightingTheme.shadowColor,
                          spreadRadius: saveButtonHeight * .05,
                          blurRadius: saveButtonHeight * .05,
                          offset: Offset(
                            0,
                            saveButtonHeight * .05,
                          ),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'SAVE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: saveButtonHeight * .425,
                          fontWeight: FontWeight.bold,
                          color:
                              haveBeenChanges ? Colors.white : Colors.black26,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Buffer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .035,
    );
  }
}
