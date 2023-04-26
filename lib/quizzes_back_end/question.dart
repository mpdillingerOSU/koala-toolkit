import 'answer.dart';

class RawQuestion {
  final String question;
  late final Answer correct;
  late final List<Answer> _incorrects;
  bool hasAnswersShuffled;

  RawQuestion(this.question, String correct, List<String> incorrects, this.hasAnswersShuffled){
    this.correct = Answer(correct, true);
    _incorrects = [];
    for(String str in incorrects){
      _incorrects.add(Answer(str, false));
    }
  }

  List<Answer> getIncorrects(){
    return [..._incorrects];
  }

  List<Answer> allAnswers(){
    return [correct] + [..._incorrects];
  }
}

class Question {
  late final String text;
  late final List<Answer> _answers;
  int _selectedAnswer = -1;

  Question(RawQuestion rawQuestion){
    text = rawQuestion.question;
    _answers = rawQuestion.allAnswers();
    if(rawQuestion.hasAnswersShuffled){
      _answers.shuffle();
    }
  }

  Answer? selectedAnswer(){
    return _selectedAnswer != -1 ? _answers[_selectedAnswer] : null;
  }

  int selectedAnswerIndex(){
    return _selectedAnswer;
  }

  List<Answer> getAnswers(){
    return [..._answers];
  }

  void selectAnswer(int selection){
    if(selection > -1 && selection < _answers.length){
      _selectedAnswer = selection;
    }
  }

  bool isCorrectlyAnswered(){
    return _selectedAnswer != -1 && _answers[_selectedAnswer].isCorrect;
  }
}

class CheckableQuestion {
  late final String text;
  late final List<Answer> _answers;
  late final int selectedAnswer;
  late final int correctAnswer;
  final int secondsOnQuestion;

  CheckableQuestion(Question question, this.secondsOnQuestion){
    text = question.text;
    _answers = question.getAnswers();
    selectedAnswer = question._selectedAnswer;
    int temp = 0;
    for(int i = 0; i < _answers.length; i++){
      if(_answers[i].isCorrect){
        temp = i;
        break;
      }
    }
    correctAnswer = temp;
  }

  List<Answer> getAnswers(){
    return [..._answers];
  }

  bool isCorrectlyAnswered(){
    return selectedAnswer != -1 && _answers[selectedAnswer].isCorrect;
  }
}