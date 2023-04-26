import 'package:gaming_toolkit/quizzes_back_end/question.dart';
import 'package:gaming_toolkit/quizzes_back_end/question_generator.dart';
import 'package:gaming_toolkit/quizzes_back_end/question_result.dart';
import 'package:gaming_toolkit/quizzes_back_end/quiz_constructor.dart';
import 'package:gaming_toolkit/quizzes_back_end/results_packet.dart';

class RawQuiz{
  final List<RawQuestion> _questions = [];
  bool hasQuestionsShuffled;

  RawQuiz(QuizConstructor constructor, int answersPerQuestion, this.hasQuestionsShuffled){
    for(int i = 0; i < constructor.questionCount; i++){
      _questions.add(QuestionGenerator.generate(constructor.randomQuestionType(), answersPerQuestion - 1));
    }
  }

  List<RawQuestion> getQuestions(){
    return [..._questions];
  }
}

class Quiz{
  late final List<Question> _questions = [];
  late int _currentIndex;

  Quiz(RawQuiz rawQuiz){
    for(RawQuestion rawQuestion in rawQuiz.getQuestions()){
      _questions.add(Question(rawQuestion));
    }
    if(rawQuiz.hasQuestionsShuffled){
      _questions.shuffle();
    }
    _currentIndex = 0;
  }

  bool hasPreviousQuestion(){
    return _currentIndex > 0;
  }

  bool hasNextQuestion(){
    return _currentIndex < _questions.length - 1;
  }

  bool onLastQuestion(){
    return _currentIndex == _questions.length - 1;
  }

  Question currentQuestion(){
    return _questions[_currentIndex];
  }

  Question previousQuestion(){
    if(hasPreviousQuestion()){
      _currentIndex--;
    }
    return currentQuestion();
  }

  Question nextQuestion(){
    if(hasNextQuestion()){
      _currentIndex++;
    }
    return currentQuestion();
  }

  void selectAnswer(int selection){
    currentQuestion().selectAnswer(selection);
  }

  int currentQuestionIndex(){
    return _currentIndex;
  }

  ResultsPacket results(){
    List<QuestionResult> results = [];
    for(Question question in _questions){
      results.add(QuestionResult(question));
    }
    return ResultsPacket(results);
  }
}

class CheckableQuiz{
  late final List<CheckableQuestion> _questions = [];
  final int secondsElapsed;
  late int _currentIndex;

  CheckableQuiz(Quiz quiz, this.secondsElapsed, List<int> secondsPerQuestion){
    for(int i = 0; i < quiz._questions.length; i++){
      _questions.add(CheckableQuestion(quiz._questions[i], secondsPerQuestion[i]));
    }
    _currentIndex = 0;
  }

  bool hasPreviousQuestion(){
    return _currentIndex > 0;
  }

  bool hasNextQuestion(){
    return _currentIndex < _questions.length - 1;
  }

  bool onLastQuestion(){
    return _currentIndex == _questions.length - 1;
  }

  CheckableQuestion currentQuestion(){
    return _questions[_currentIndex];
  }

  CheckableQuestion previousQuestion(){
    if(hasPreviousQuestion()){
      _currentIndex--;
    }
    return currentQuestion();
  }

  CheckableQuestion nextQuestion(){
    if(hasNextQuestion()){
      _currentIndex++;
    }
    return currentQuestion();
  }

  int currentQuestionIndex(){
    return _currentIndex;
  }
}