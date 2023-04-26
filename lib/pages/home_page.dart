import 'package:flutter/material.dart';

import '../components/action_button.dart';
import '../components/general/flex_box.dart';
import '../components/margined_column.dart';
import '../components/general/advanced_scaffold.dart';
import '../my_constants.dart';
import '../components/my_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final String name;

  @override
  Widget build(BuildContext context) {
    return AdvancedScaffold(
      pageTitle: 'Home',
      body: Center(
        child: MarginedColumn(
          children: [
            const FlexBox(10),
            Expanded(
              flex: 40,
              child: Center(
                child: ActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/quiz');
                    },
                    text: 'Quiz'),
              ),
            ),
            const FlexBox(5),
            Expanded(
              flex: 40,
              child: Center(
                child: ActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    text: 'Profile'),
              ),
            ),
            const FlexBox(5),
            Expanded(
              flex: 40,
              child: Center(
                child: ActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/projects');
                    },
                    text: 'Moves'),
              ),
            ),
            const FlexBox(10),
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(
        context,
        selection: 'Home',
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
