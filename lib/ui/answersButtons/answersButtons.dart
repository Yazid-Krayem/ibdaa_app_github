import 'package:flutter/material.dart';

import '../style.dart';

class AnswersButtons extends StatelessWidget {
  final List answersList;
  final Function answersCallBack;
  final item;
  final int currentIndex;

  const AnswersButtons(
      {Key key,
      @required this.answersList,
      @required this.answersCallBack,
      @required this.item,
      @required this.currentIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
          elevation: 8,
          shape: buttonStyle,
          textColor: Colors.black,
          color: Colors.blue,
          onPressed: () async {
            answersCallBack(item);
          },
          child: Text("${item.answersText}")),
    );
  }
}
