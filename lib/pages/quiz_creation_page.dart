import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/tickers/ticker_row.dart';
import 'package:gaming_toolkit/pages/question_page.dart';
import 'package:gaming_toolkit/user_preferences.dart';

import '../components/action_button.dart';
import '../components/tickers/ticker_box.dart';
import '../components/general/flex_box.dart';
import '../components/margined_column.dart';
import '../components/tickers/ticker_fat_row.dart';
import '../my_constants.dart';
import '../components/my_navigation_bar.dart';

class QuizCreationPage extends StatefulWidget {
  const QuizCreationPage({
    super.key,
  });

  @override
  State<QuizCreationPage> createState() => QuizCreationPageState();
}

class QuizCreationPageState extends State<QuizCreationPage> {
  final TickerBox questionTicker = TickerBox(
    title: 'Questions',
    width: TickerBox.defaultWidth * .75,
    startingValue: 10,
    lowerBound: 1,
    upperBound: 50,
    lightingTheme: UserPreferences.getLightingTheme(),
  );
  final TickerBox timeTicker = TickerBox(
    title: 'Minutes',
    width: TickerBox.defaultWidth * .75,
    startingValue: 10,
    lowerBound: 1,
    upperBound: 50,
    lightingTheme: UserPreferences.getLightingTheme(),
  );
  final TickerFatRow randomTicker = TickerFatRow(
    title: 'Difficulty',
    width: TickerRow.defaultWidth * .75,
    startingValue: 10,
    lowerBound: 1,
    upperBound: 50,
    lightingTheme: UserPreferences.getLightingTheme(),
  );

  @override
  Widget build(BuildContext context) {
    return AdvancedScaffold(
      pageTitle: 'Create Quiz',
      body: Center(
        child: MarginedColumn(
          margin: 10,
          children: [
            const FlexBox(10),
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
                child: MarginedColumn(
                  margin: 2,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        questionTicker,
                        SizedBox(
                          width: questionTicker.width * 20 / 180,
                        ),
                        timeTicker,
                      ],
                    ),
                    SizedBox(
                      height: questionTicker.width * 20 / 180,
                    ),
                    randomTicker,
                    SizedBox(
                      height: questionTicker.width * 20 / 180,
                    ),
                    Row(
                      children: [
                        const FlexBox(1),
                        Expanded(
                          flex: 8,
                          child: ActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionPage(
                                    questionTicker.getValue(),
                                    timeTicker.getValue(),
                                  ),
                                ),
                              );
                            },
                            text: 'Start',
                            textColor: Colors.blue,
                          ),
                        ),
                        const FlexBox(1),
                      ],
                    ),
                  ],
                ),
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
}
