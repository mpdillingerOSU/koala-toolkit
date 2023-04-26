import 'dart:math';

import 'package:gaming_toolkit/quizzes_back_end/question.dart';

class QuestionGenerator {
  static RawQuestion generate(QuestionType type, int numOfIncorrects){
    var random = Random();
    int num1;
    int num2;
    int answer;
    String symbol;

    if(type == QuestionType.addition){
      num1 = 1 + random.nextInt(100);
      num2 = 1 + random.nextInt(100);
      answer = num1 + num2;
      symbol = '+';
    } else if(type == QuestionType.subtraction){
      num1 = 1 + random.nextInt(100);
      num2 = 1 + random.nextInt(100);
      answer = num1 - num2;
      symbol = '-';
    } else if(type == QuestionType.multiplication){
      num1 = 1 + random.nextInt(100);
      num2 = 1 + random.nextInt(100);
      answer = num1 * num2;
      symbol = 'x';
    } else {
      answer = 1 + random.nextInt(100);
      num2 = 1 + random.nextInt(100);
      num1 = answer * num2;
      symbol = '/';
    }

    List<String> incorrects = [];
    numOfIncorrects = max(1, numOfIncorrects);
    int spread = (numOfIncorrects ~/ 10 + 1) * 10;
    for(int i = 0; i < numOfIncorrects; i++){
      int incorrect;
      do{
        incorrect = answer - (spread ~/ 2) + random.nextInt(spread + 1);
      } while (incorrect == answer  || incorrects.contains("$incorrect"));
      incorrects.add("$incorrect");
    }

    return RawQuestion("What is $num1 $symbol $num2?", "$answer", incorrects, true);
  }
}

enum QuestionType {
  addition, subtraction, multiplication, division;

  static QuestionType random(){
    return values[Random().nextInt(values.length)];
  }
}