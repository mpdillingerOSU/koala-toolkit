import 'package:flutter/material.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/moves/move_rolodex_page.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/units/unit_rolodex_page.dart';

import '../koala_toolkit_back_end/move_icons.dart';
import '../koala_toolkit_back_end/project_packet.dart';
import '../pages/koala_toolkit_pages/home/project_home_page.dart';
import 'general/nav_bar.dart';
import '../my_constants.dart';

class UniversalNavBar extends IconNavBar {
  final ProjectPacket project;
  final Future<bool> Function() onWillPush;

  UniversalNavBar(
    super.context, {
    super.key,
    required this.project,
    String? selection,
    required this.onWillPush,
  }) : super(
          barColor: MyConstants.primaryColor,
          children: [
            IconNavButton(
              context,
              label: 'Units',
              onPressed: () async {
                if (ModalRoute.of(context)?.settings.name != 'Units' &&
                    await onWillPush()) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'Units'),
                        builder: (context) => UnitRolodexPage(project),
                      ),
                      (Route<dynamic> route) => false);
                }
              },
              icon: Icons.person_rounded,
              activeColor: Colors.lightBlue,
              inactiveColor: Colors.grey.shade600,
              isActive: selection == 'Units',
            ),
            IconNavButton(
              context,
              label: 'Home',
              onPressed: () async {
                ///Check for ['/'] is because the app's initial route is always
                /// initially set to ['/']
                if (ModalRoute.of(context)?.settings.name != 'Home' &&
                    await onWillPush()) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'Home'),
                        builder: (context) => ProjectHomePage(project),
                      ),
                      (Route<dynamic> route) => false);
                }
              },
              icon: Icons.home_rounded,
              activeColor: Colors.lightBlue,
              inactiveColor: Colors.grey.shade600,
              isActive: selection == 'Home',
            ),
            IconNavButton(
              context,
              label: 'Moves',
              onPressed: () async {
                ///Check for ['/'] is because the app's initial route is always
                /// initially set to ['/']
                if (ModalRoute.of(context)?.settings.name != 'Moves' &&
                    await onWillPush()) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'Moves'),
                        builder: (context) => MoveRolodexPage(project),
                      ),
                      (Route<dynamic> route) => false);
                }
              },
              icon: MoveIcons.physical,
              activeColor: Colors.lightBlue,
              inactiveColor: Colors.grey.shade600,
              isActive: selection == 'Moves',
            ),
          ],
        );
}
