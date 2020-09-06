import 'package:flutter/material.dart';

import '../style.dart';

class QuestionsList extends StatelessWidget {
  final double progress;
  final int currentIndex;
  final question;

  const QuestionsList(
      {Key key,
      @required this.progress,
      @required this.currentIndex,
      this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    String mainQuestions = ' :هل تحب أو ترغب في ';

    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(8),
      child: Center(
          child: Stack(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.topRight,
            child: Text(
              "$mainQuestions \n",
              style: width < 500 ? mainQuestionWeb : mainQuestionWeb,
              textAlign: TextAlign.right,
            ),
          ),
          Center(
            child: Text(
              "\n${question['question_data']}",
              style: width < 500 ? mobileQuestionsFont : webQuestionsFont,
              textAlign: TextAlign.center,
            ),
          )
        ],
      )),
    );
  }
}
