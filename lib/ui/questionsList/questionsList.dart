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
    var orientation = MediaQuery.of(context).orientation;

    return Container(
      padding: EdgeInsets.all(8),
      child: Center(
          child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text("${question['question_data']}",
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: webQuestionsFont),
      )),
    );
  }
}
