import 'package:gaming_toolkit/quizzes_back_end/question_result.dart';

class ResultsPacket {
  late final List<QuestionResult> _results;
  late final int correct;
  late final int total;
  late final int percentage;
  late final String comment;

  ResultsPacket(List<QuestionResult> results) {
    _results = [...results];
    int temp = 0;
    for (QuestionResult result in results) {
      if (result.answeredCorrectly) {
        temp++;
      }
    }
    correct = temp;
    total = results.length;
    percentage = (100 * correct / total).round();
    comment = percentage == 100
        ? 'Perfect'
        : percentage > 89
            ? 'Amazing'
            : percentage > 79
                ? 'Great'
                : percentage > 69
                    ? 'Well Done'
                    : 'Good Try';
  }

  List<bool> boolList() {
    List<bool> returnList = [];
    for (QuestionResult result in _results) {
      returnList.add(result.answeredCorrectly);
    }
    return returnList;
  }
}
