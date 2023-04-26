import 'package:flutter/material.dart';
import 'package:gaming_toolkit/quizzes_back_end/question.dart';
import 'package:gaming_toolkit/pages/question_page.dart';

import '../quizzes_back_end/answer.dart';
import 'answer_block.dart';
import '../my_constants.dart';

class QuestionCard extends StatefulWidget {
  final QuestionPageState parent;
  final Question question;
  final int questionNum;
  final Color? backgroundColor;
  final Color? textColor;

  const QuestionCard(
    this.parent,
    this.question, {
    super.key,
    this.questionNum = -1,
    this.backgroundColor = MyConstants.primaryColor,
    this.textColor = MyConstants.textColor,
  });

  @override
  State<QuestionCard> createState() => QuestionCardState();
}

class QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    List<Answer> answers = widget.question.getAnswers();
    List<AnswerBlock> answerBlocks = [];
    for (int i = 0; i < answers.length; i++) {
      answerBlocks.add(AnswerBlock(this, i, answers[i].text));
    }
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
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
                  (widget.questionNum != -1 ? "${widget.questionNum}) " : "") +
                      widget.question.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Sans Source Pro',
                      color: widget.textColor,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Divider(
                      color: widget.textColor,
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

  void checkState() {
    setState(() {});
  }
}
