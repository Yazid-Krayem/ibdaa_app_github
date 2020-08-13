import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/linearProgressIndicator/linearProgressIndicator.dart';

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
    return Stack(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Linearprogress(
              progress: progress,
            ),
          ),
        ]),
        Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.all(20.0),
          child: Text("السؤال ${currentIndex + 1} من 3",
              style: TextStyle(color: Colors.purple),
              textDirection: TextDirection.rtl),
        ),
        Center(
            // padding: const EdgeInsets.all(8.0),
            child: Text(
          "${question['question_data']}",
          style: TextStyle(fontSize: 25, color: Colors.black),
        )),
      ],
    );
  }
}
