import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/question_card.dart';

import '../my_constants.dart';

class AnswerBlock extends StatefulWidget {
  final QuestionCardState parent;
  final int answerChoice;
  final String text;
  final Color textColor;
  late bool _isSelected;

  AnswerBlock(
    this.parent,
    this.answerChoice,
    this.text, {
    super.key,
    this.textColor = MyConstants.textColor,
  }) {
    _isSelected = parent.widget.question.selectedAnswerIndex() == answerChoice;
  }

  void checkIsSelected() {
    _isSelected = parent.widget.question.selectedAnswerIndex() == answerChoice;
    createState();
  }

  @override
  State<AnswerBlock> createState() => AnswerBlockState();
}

class AnswerBlockState extends State<AnswerBlock> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: TextButton(
        onPressed: () {
          setState(() {
            widget.parent.widget.parent.selectAnswer(widget.answerChoice);
            widget.parent.checkState();
          });
        },
        style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        child: Icon(widget._isSelected ? Icons.circle : Icons.circle_outlined,
            color: MyConstants.borderColor),
      ),
      title: Text(
        widget.text,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Sans Source Pro',
            color: widget.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
