import 'package:flutter/material.dart';
import 'package:gaming_toolkit/quizzes_back_end/question.dart';

import '../quizzes_back_end/answer.dart';
import '../my_constants.dart';
import 'checkable_answer_block.dart';

class CheckableQuestionCard extends StatelessWidget {
  final CheckableQuestion question;
  final int questionNum;
  final Color? backgroundColor;
  final Color? textColor;

  const CheckableQuestionCard(
    this.question, {
    super.key,
    this.questionNum = -1,
    this.backgroundColor = MyConstants.primaryColor,
    this.textColor = MyConstants.textColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Answer> answers = question.getAnswers();
    List<CheckableAnswerBlock> answerBlocks = [];
    for (int i = 0; i < answers.length; i++) {
      answerBlocks.add(CheckableAnswerBlock(i, answers[i].text,
          i == question.selectedAnswer, answers[i].isCorrect));
    }
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.5),
        border: Border.all(
          color: MyConstants.borderColor,
          width: 3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                Text(
                  (questionNum != -1 ? '$questionNum) ' : '') + question.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Sans Source Pro',
                      color: textColor,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Divider(
                      color: textColor,
                      thickness: 2,
                    ),
                  ),
                ),
              ] +
              answerBlocks,
        ),
      ),
    );
  }
}
