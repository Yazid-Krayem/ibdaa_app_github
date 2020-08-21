import 'package:flutter/material.dart';
import '../style.dart';

class AnswersButtons extends StatelessWidget {
  final List answersList;
  final Function answersCallBack;
  final item;
  final int currentIndex;
  final int lengthOflocalStorageItems;
  final int pressedButton;

  const AnswersButtons(
      {Key key,
      @required this.answersList,
      @required this.answersCallBack,
      @required this.item,
      @required this.currentIndex,
      @required this.lengthOflocalStorageItems,
      @required this.pressedButton})
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
          // color: Colors.grey[400],
          color:
              pressedButton == item.id ? Colors.orangeAccent : Colors.grey[400],
          onPressed: () async {
            answersCallBack(item);
          },
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "${item.answersText}",
              style: webAnswersFont,
            ),
          )),
    );
  }
}
