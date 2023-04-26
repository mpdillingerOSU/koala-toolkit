import 'package:flutter/material.dart';

import '../my_constants.dart';

class CheckableAnswerBlock extends StatelessWidget {
  final int answerChoice;
  final String text;
  final Color textColor;
  final bool isSelected;
  final bool isCorrect;

  const CheckableAnswerBlock(this.answerChoice, this.text, this.isSelected, this.isCorrect, {super.key, this.textColor = MyConstants.textColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: TextButton(
        onPressed: () {
        },
        style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        child: Icon(isSelected || isCorrect ? Icons.circle : Icons.circle_outlined, color: isSelected ? (isCorrect ? Colors.green :  Colors.red) : MyConstants.borderColor),
      ),
      title: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Sans Source Pro',
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}