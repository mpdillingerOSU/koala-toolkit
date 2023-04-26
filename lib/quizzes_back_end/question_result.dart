import 'package:gaming_toolkit/quizzes_back_end/question.dart';

class QuestionResult{
  late final bool answeredCorrectly;

  QuestionResult(Question question){
    answeredCorrectly = question.isCorrectlyAnswered();
  }
}