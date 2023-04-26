import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/margined_column.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';

import '../components/general/flex_box.dart';
import '../my_constants.dart';
import '../components/my_navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  final String name;

  const ProfilePage(
    this.name, {
    super.key,
  });

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late final String name;

  @override
  Widget build(BuildContext context) {
    return AdvancedScaffold(
      pageTitle: 'Profile',
      body: Center(
        child: MarginedColumn(
          children: [
            const FlexBox(4),
            Expanded(
              flex: 20,
              child: penguinImage(),
            ),
            const FlexBox(1),
            Expanded(
              flex: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: MyConstants.primaryColor,
                  borderRadius: BorderRadius.circular(12.5),
                  border: Border.all(
                    color: MyConstants.borderColor,
                    width: 3,
                  ),
                ),
              ),
            ),
            const FlexBox(10),
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(
        context,
        selection: 'Profile',
      ),
    );
  }

  Widget penguinImage() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: MyConstants.borderColor,
            width: 2,
          )),
      child: const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage("images/dabbingPenguin.png"),
      ),
    );
  }
}
