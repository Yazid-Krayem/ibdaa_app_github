import 'package:flutter/gestures.dart';
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
  AnswersButtonsState createState() => AnswersButtonsState();
}

class AnswersButtonsState extends State<AnswersButtons> {
  final GlobalKey<AnswersButtonsState> firstWidgetGlobalKey =
      new GlobalKey<AnswersButtonsState>();

  bool isCurrentlyTouching = false;

  Color changeColor = Colors.lightBlue;

  Color hoverColor = Colors.white;
  bool _isInside = false;
  PointerEvent _lastEvent;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 3,
        padding: const EdgeInsets.all(8.0),
        child: MouseRegion(
          onEnter: (PointerEnterEvent event) {
            setState(() {
              _isInside = true;
              _lastEvent = event;
              isCurrentlyTouching = true;
            });
          },
          onHover: (PointerHoverEvent event) {
            setState(() {
              _lastEvent = event;
              _isInside = true;
              isCurrentlyTouching = true;
            });
          },
          onExit: (PointerExitEvent event) {
            setState(() {
              _isInside = false;
              _lastEvent = event;
              isCurrentlyTouching = false;
            });
          },
          child: Listener(
            // ignore: deprecated_member_use
            onPointerHover: (event) {
              if (event is PointerScrollEvent) {
                setState(() {
                  _lastEvent = event;
                });
              }
            },

            onPointerSignal: (PointerSignalEvent event) {
              if (event is PointerScrollEvent) {
                setState(() {
                  _lastEvent = event;
                });
              }
            },
            // ignore: deprecated_member_use
            child: RaisedButton(
                hoverColor: Colors.lightBlue,
                shape: buttonStyle,
                color: widget.item.id == widget.pressedButton
                    ? Colors.lightBlue
                    : Colors.white,
                onPressed: () async {
                  await widget.answersCallBack(widget.item);
                },
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text("${widget.item.answersText}",
                      style: TextStyle(
                          fontSize: 24,
                          color: widget.item.id == widget.pressedButton ||
                                  isCurrentlyTouching
                              ? Colors.white
                              : Colors.lightBlue)),
                )),
          ),
        ));
  }
}
