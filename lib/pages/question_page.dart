import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/action_button.dart';
import 'package:gaming_toolkit/components/general/flex_box.dart';
import 'package:gaming_toolkit/components/question_card.dart';
import 'package:gaming_toolkit/pages/draw_tool_page.dart';
import 'package:gaming_toolkit/quizzes_back_end/question_generator.dart';
import 'package:gaming_toolkit/quizzes_back_end/quiz.dart';
import 'package:gaming_toolkit/quizzes_back_end/quiz_constructor.dart';
import 'package:gaming_toolkit/pages/results_page.dart';

import '../components/general/nav_bar.dart';
import '../components/general/tap_detector.dart';
import '../components/margined_column.dart';
import '../components/general/advanced_scaffold.dart';
import '../my_constants.dart';
import '../time.dart';
import 'koala_toolkit_pages/popups/koala_alert.dart';

class QuestionPage extends StatefulWidget {
  final int questionCount;
  final int startingMinutes;

  const QuestionPage(
    this.questionCount,
    this.startingMinutes, {
    super.key,
  });

  @override
  State<QuestionPage> createState() =>
      QuestionPageState(questionCount, startingMinutes);
}

class QuestionPageState extends State<QuestionPage> {
  late final Quiz quiz;
  late QuestionCard _questionCard;
  late final ActionButton _previousButton;
  late final ActionButton _inactivePreviousButton;
  late final ActionButton _nextButton;
  late final ActionButton _inactiveNextButton;

  late final int _startingSeconds;
  late int _secondsRemaining;
  late final List<int> _secondsPerQuestion;
  late Timer _timer;

  QuestionPageState(int questionCount, int startingMinutes) {
    quiz = Quiz(
      RawQuiz(
          QuizConstructor(
            questionCount,
            [
              QuestionType.addition,
              QuestionType.subtraction,
              QuestionType.multiplication,
              QuestionType.division
            ],
          ),
          4,
          true),
    );
    _questionCard = QuestionCard(this, quiz.currentQuestion(),
        questionNum: quiz.currentQuestionIndex() + 1);
    _previousButton = ActionButton(
      onPressed: () {
        _toPreviousQuestion();
      },
      text: 'Previous',
    );
    _inactivePreviousButton = ActionButton(
      onPressed: () {},
      text: 'Previous',
      textColor: MyConstants.borderColor,
      borderColor: Colors.black38,
    );
    _nextButton = ActionButton(
        onPressed: () {
          _toNextQuestion();
        },
        text: 'Next');
    _inactiveNextButton = ActionButton(
      onPressed: () {},
      text: 'Next',
      textColor: MyConstants.borderColor,
      borderColor: Colors.black38,
    );
    _secondsRemaining = _startingSeconds = startingMinutes * 60;
    _secondsPerQuestion = List.filled(questionCount, 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _secondsPerQuestion[quiz.currentQuestionIndex()]++;
        } else {
          _toResultsPage();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedScaffold(
      pageTitle: 'Quiz',
      actions: [
        const Icon(
          Icons.alarm_rounded,
        ),
        Center(
          child: Text(
            Time.asClock(_secondsRemaining),
            style: const TextStyle(
              color: Colors.lightBlue,
              fontSize: 20,
            ),
          ),
        ),
      ],
      body: Center(
        child: MarginedColumn(
          margin: 6,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 17,
                  child: _questionCard,
                ),
                const FlexBox(1),
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyConstants.primaryColor,
                      borderRadius: BorderRadius.circular(12.5),
                      border: Border.all(
                        color: MyConstants.borderColor,
                        width: 3,
                      ),
                    ),
                    child: Column(
                      children: [
                        TapDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DrawToolPage(),
                            ),
                          ),
                          child: const Icon(
                            Icons.palette_outlined,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: quiz.hasPreviousQuestion()
                      ? _previousButton
                      : _inactivePreviousButton,
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 2,
                  child: quiz.hasNextQuestion()
                      ? _nextButton
                      : _inactiveNextButton,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: TextNavBar(
        context,
        onPressed: () async {
          final bool confirm = await showDialog(
                context: context,
                builder: (context) => const KoalaAlert(
                  title: 'Submit Quiz',
                  text: 'Do you wish to submit your quiz?',
                ),
              ) ??
              false;

          if (confirm) {
            _toResultsPage();
          }
        },
        text: 'SUBMIT',
      ),
    );
  }

  void selectAnswer(int selection) {
    setState(() {
      quiz.selectAnswer(selection);
    });
  }

  void _toPreviousQuestion() {
    setState(() {
      if (quiz.hasPreviousQuestion()) {
        _questionCard = QuestionCard(this, quiz.previousQuestion(),
            questionNum: quiz.currentQuestionIndex() + 1);
      }
    });
  }

  void _toNextQuestion() {
    setState(() {
      if (quiz.hasNextQuestion()) {
        _questionCard = QuestionCard(this, quiz.nextQuestion(),
            questionNum: quiz.currentQuestionIndex() + 1);
      }
    });
  }

  void _toResultsPage() {
    _timer.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
          packet: quiz.results(),
          quiz: quiz,
          startingSeconds: _startingSeconds,
          secondsElapsed: _startingSeconds - _secondsRemaining,
          secondsPerQuestion: _secondsPerQuestion,
        ),
      ),
    );
  }
}
