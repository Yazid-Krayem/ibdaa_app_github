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
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(

          // elevation: 8,
          shape: buttonStyle,
          textColor: Colors.black,
          color: Colors.grey[400],
          onPressed: () async {
            answersCallBack(item);
          },
          child: Text(
            "${item.answersText}",
            style: TextStyle(fontSize: 30, color: Colors.black),
          )),
    );
  }
}
