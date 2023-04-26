import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/action_button.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/quizzes_back_end/quiz.dart';

import '../components/checkable_question_card.dart';
import '../components/general/nav_bar.dart';
import '../components/margined_column.dart';
import '../my_constants.dart';
import '../time.dart';
import 'koala_toolkit_pages/popups/koala_alert.dart';

class CheckAnswersPage extends StatefulWidget {
  late final Quiz _quiz;
  final int _secondsElapsed;
  late final List<int> _secondsPerQuestion;

  CheckAnswersPage(
    this._quiz,
    this._secondsElapsed,
    List<int> secondsPerQuestion, {
    super.key,
  }) {
    _secondsPerQuestion = [...secondsPerQuestion];
  }

  @override
  State<CheckAnswersPage> createState() =>
      CheckAnswersPageState(_quiz, _secondsElapsed, _secondsPerQuestion);
}

class CheckAnswersPageState extends State<CheckAnswersPage> {
  late final CheckableQuiz quiz;
  late CheckableQuestionCard _questionCard;
  late final ActionButton _previousButton;
  late final ActionButton _inactivePreviousButton;
  late final ActionButton _nextButton;
  late final ActionButton _inactiveNextButton;

  CheckAnswersPageState(
      Quiz quiz, int secondsElapsed, List<int> secondsPerQuestion) {
    this.quiz = CheckableQuiz(quiz, secondsElapsed, secondsPerQuestion);
    _questionCard = CheckableQuestionCard(this.quiz.currentQuestion(),
        questionNum: this.quiz.currentQuestionIndex() + 1);
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
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedScaffold(
      pageTitle: 'Check Answers',
      body: Center(
        child: MarginedColumn(
          children: [
            Container(
              decoration: BoxDecoration(
                color: MyConstants.primaryColor,
                borderRadius: BorderRadius.circular(12.5),
                border: Border.all(
                  color: MyConstants.borderColor,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        quiz.currentQuestion().isCorrectlyAnswered()
                            ? 'Correct'
                            : quiz.currentQuestion().selectedAnswer != -1
                                ? 'Incorrect'
                                : 'Unanswered',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Sans Source Pro',
                            color: quiz.currentQuestion().isCorrectlyAnswered()
                                ? Colors.green
                                : quiz.currentQuestion().selectedAnswer != -1
                                    ? Colors.red
                                    : Colors.yellow.shade600,
                            fontSize:
                                quiz.currentQuestion().selectedAnswer != -1
                                    ? 21
                                    : 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        '|',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Sans Source Pro',
                            color: MyConstants.textColor,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Time: ${Time.asClock(_questionCard.question.secondsOnQuestion)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Sans Source Pro',
                            color: MyConstants.textColor,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _questionCard,
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
          bool confirm = await showDialog(
                context: context,
                builder: (context) => const KoalaAlert(
                  title: 'Leave Results Page',
                  text: 'Do you wish to leave the results page?',
                ),
              ) ??
              false;

          if (confirm && mounted) {
            Navigator.pushNamed(context, '/quiz');
          }
        },
        text: 'FINISH',
      ),
    );
  }

  void _toPreviousQuestion() {
    setState(() {
      if (quiz.hasPreviousQuestion()) {
        _questionCard = CheckableQuestionCard(quiz.previousQuestion(),
            questionNum: quiz.currentQuestionIndex() + 1);
      }
    });
  }

  void _toNextQuestion() {
    setState(() {
      if (quiz.hasNextQuestion()) {
        _questionCard = CheckableQuestionCard(quiz.nextQuestion(),
            questionNum: quiz.currentQuestionIndex() + 1);
      }
    });
  }
}
