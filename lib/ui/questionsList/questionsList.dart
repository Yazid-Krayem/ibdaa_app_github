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
    String mainQuestions = ' :هل تحب أو ترغب في ';

    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(8),
      child: Center(
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(children: [
                    TextSpan(
                      text: " $mainQuestions \n\n",
                      style: mainQuestion,
                    ),
                    TextSpan(
                      text: "${question['question_data']}",
                      style: webQuestionsFont,
                    )
                  ])))),
    );
  }
}
