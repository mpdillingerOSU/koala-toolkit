import 'package:gaming_toolkit/quizzes_back_end/question_generator.dart';
import 'dart:math';

class QuizConstructor{
  late final int questionCount;
  late final List<QuestionType> _questionTypes;
  
  QuizConstructor(questionCount, List<QuestionType> questionTypes){
    this.questionCount = max(1, questionCount);
    _questionTypes = [...questionTypes];
  }

  List<QuestionType> getQuestionTypes(){
    return [..._questionTypes];
  }

  QuestionType randomQuestionType(){
    return _questionTypes[Random().nextInt(_questionTypes.length)];
  }
}