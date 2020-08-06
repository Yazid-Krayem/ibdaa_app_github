import 'package:flutter/material.dart';

class AnswerList extends StatelessWidget {
  final Function answersCallBack;
  final item;

  const AnswerList({
    Key key,
    this.item,
    this.answersCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.1,
      padding: const EdgeInsets.only(right: 20.0),
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
          color: Colors.white,
          onPressed: () => {answersCallBack(item)},
          child: Text("${item.answersText}")),
    );
  }
}
