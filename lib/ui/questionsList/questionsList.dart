import 'package:flutter/material.dart';

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
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "${question['question_data']}",
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 25, color: Colors.black),
          )),
    );
  }
}
