import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/margined_column.dart';
import 'package:gaming_toolkit/quizzes_back_end/results_packet.dart';

import '../components/action_button.dart';
import '../components/general/flex_box.dart';
import '../components/general/advanced_scaffold.dart';
import '../components/general/nav_bar.dart';
import '../my_constants.dart';
import '../quizzes_back_end/quiz.dart';
import '../time.dart';
import 'check_answers_page.dart';
import 'koala_toolkit_pages/popups/koala_alert.dart';

class ResultsPage extends StatefulWidget {
  final ResultsPacket packet;
  final Quiz quiz;
  final int startingSeconds;
  final int secondsElapsed;
  late final List<int> _secondsPerQuestion;

  ResultsPage({
    super.key,
    required this.packet,
    required this.quiz,
    required this.startingSeconds,
    required this.secondsElapsed,
    required secondsPerQuestion,
  }) {
    _secondsPerQuestion = [...secondsPerQuestion];
  }

  @override
  State<ResultsPage> createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  late final String name;

  @override
  Widget build(BuildContext context) {
    return AdvancedScaffold(
      pageTitle: 'Results',
      body: Center(
        child: MarginedColumn(
          children: [
            const FlexBox(4),
            Expanded(
              flex: 20,
              child: penguinImage(),
            ),
            const FlexBox(1),
            Expanded(
              flex: 50,
              child: Container(
                  decoration: BoxDecoration(
                    color: MyConstants.primaryColor,
                    borderRadius: BorderRadius.circular(12.5),
                    border: Border.all(
                      color: MyConstants.borderColor,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.packet.comment,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: widget.packet.percentage > 79
                                ? Colors.green
                                : widget.packet.percentage > 69
                                    ? Colors.yellow.shade600
                                    : Colors.orange.shade600,
                          ),
                        ),
                        Text(
                          '${widget.packet.percentage}%   |   ${Time.asClock(widget.secondsElapsed)}/${Time.asClock(widget.startingSeconds)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.packet.correct}/${widget.packet.total}',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            const FlexBox(2),
            ActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckAnswersPage(
                      widget.quiz,
                      widget.secondsElapsed,
                      widget._secondsPerQuestion,
                    ),
                  ),
                );
              },
              text: 'Check Answers',
            ),
            const FlexBox(10),
          ],
        ),
      ),
      bottomNavigationBar: TextNavBar(
        context,
        onPressed: () async {
          final bool confirm = await showDialog(
                context: context,
                builder: (context) => const KoalaAlert(
                  title: 'Leave Results Page',
                  text: 'Do you wish to leave the results page?',
                ),
              ) ??
              false;

          if (confirm && mounted) {
            Navigator.pushNamed(context, '/quiz');
          }
        },
        text: 'FINISH',
      ),
    );
  }

  Widget penguinImage() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: MyConstants.borderColor,
            width: 2,
          )),
      child: const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage("images/dabbingPenguin.png"),
      ),
    );
  }

  List<Widget> _firstHalfNums() {
    List<Widget> returnList = [];
    for (int i = 0; i < widget.packet.total / 2; i++) {
      returnList.add(
        Text(
          '${(i + 1)}) ${Time.asClock(widget._secondsPerQuestion[i])}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }
    return returnList;
  }

  List<Widget> _firstHalfIcons() {
    List<Widget> returnList = [];
    List<bool> boolList = widget.packet.boolList();
    for (int i = 0; i < boolList.length / 2; i++) {
      returnList.add(
        boolList[i]
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : const Icon(
                Icons.close,
                color: Colors.red,
              ),
      );
    }
    return returnList;
  }

  List<Widget> _secondHalfNums() {
    List<Widget> returnList = [];
    for (int i = (widget.packet.total + 1) ~/ 2; i < widget.packet.total; i++) {
      returnList.add(
        Text(
          '${(i + 1)}) ${Time.asClock(widget._secondsPerQuestion[i])}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }
    return returnList;
  }

  List<Widget> _secondHalfIcons() {
    List<Widget> returnList = [];
    List<bool> boolList = widget.packet.boolList();
    for (int i = (widget.packet.total + 1) ~/ 2; i < widget.packet.total; i++) {
      returnList.add(
        boolList[i]
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : const Icon(
                Icons.close,
                color: Colors.red,
              ),
      );
    }
    return returnList;
  }

  Table generateTable() {
    List<TableRow> rows = [];
    List<Widget> firstHalfNums = _firstHalfNums();
    List<Widget> firstHalfIcons = _firstHalfIcons();
    List<Widget> secondHalfNums = _secondHalfNums();
    List<Widget> secondHalfIcons = _secondHalfIcons();
    for (int i = 0; i < widget.packet.total / 2; i++) {
      rows.add(
        TableRow(children: [
          firstHalfNums[i],
          firstHalfIcons[i],
          i != secondHalfNums.length ? secondHalfNums[i] : const SizedBox(),
          i != secondHalfIcons.length ? secondHalfIcons[i] : const SizedBox(),
        ]),
      );
    }
    return Table(
      children: rows,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      defaultColumnWidth: const FlexColumnWidth(1),
    );
  }
}
