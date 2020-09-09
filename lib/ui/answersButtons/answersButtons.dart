import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../style.dart';

class AnswersButtons extends StatefulWidget {
  final List answersList;
  final Function answersCallBack;
  final Function clickFunctionWithoutAddToLocalStorage;
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
      @required this.pressedButton,
      @required this.clickFunctionWithoutAddToLocalStorage})
      : super(key: key);

  @override
  _AnswersButtonsState createState() => _AnswersButtonsState();
}

class _AnswersButtonsState extends State<AnswersButtons> {
  Color changeColor = Colors.lightBlue;

  Color hoverColor = Colors.lightBlue;

  @override
  Widget build(BuildContext context) {
    print(changeColor);
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
          hoverColor: Colors.lightBlue,
          shape: buttonStyle,
          textColor: changeColor,
          color: widget.item.id == widget.pressedButton
              ? Colors.lightBlue
              : Colors.white,
          onPressed: () async {
            widget.answersCallBack(widget.item);
          },
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text("${widget.item.answersText}",
                style: TextStyle(
                  fontSize: 24,
                  color: widget.item.id == widget.pressedButton
                      ? Colors.white
                      : Colors.lightBlue,
                )),
          )),
    );
  }
}
