import 'package:flutter/material.dart';

import '../my_constants.dart';
import 'general/nav_bar.dart';

class MyNavigationBar extends IconNavBar {
  MyNavigationBar(
    super.context, {
    super.key,
    String? selection,
  }) : super(
          barColor: MyConstants.primaryColor,
          children: [
            IconNavButton(
              context,
              label: 'Stats',
              onPressed: () {},
              icon: Icons.bar_chart_rounded,
              activeColor: Colors.lightBlue,
              inactiveColor: Colors.grey.shade600,
              isActive: selection == 'Stats',
            ),
            IconNavButton(
              context,
              label: 'Home',
              onPressed: () {
                ///Check for ['/'] is because the app's initial route is always
                /// set to ['/']
                if (ModalRoute.of(context)?.settings.name != '/home' &&
                    ModalRoute.of(context)?.settings.name != '/') {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (Route<dynamic> route) => false);
                }
              },
              icon: Icons.home_rounded,
              activeColor: Colors.lightBlue,
              inactiveColor: Colors.grey.shade600,
              isActive: selection == 'Home',
            ),
            IconNavButton(
              context,
              label: 'Profile',
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/profile') {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/profile', (Route<dynamic> route) => false);
                }
              },
              icon: Icons.person,
              activeColor: Colors.lightBlue,
              inactiveColor: Colors.grey.shade600,
              isActive: selection == 'Profile',
            ),
          ],
        );
}
