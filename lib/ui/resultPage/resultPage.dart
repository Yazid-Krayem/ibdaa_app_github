import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String result;
  final List questionWithAnswer;
  const ResultPage(
      {Key key, @required this.result, @required this.questionWithAnswer})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(questionWithAnswer.map((e) => e));
    return Scaffold(
      appBar: AppBar(
        title: Text(result),
      ),
      body: Container(
        child: Text('here'),
      ),
    );
  }
}
