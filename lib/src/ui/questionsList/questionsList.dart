import 'package:flutter/material.dart';
import 'package:ibdaa_app/src/ui/linearProgressIndicator/linearProgressIndicator.dart';

class QuestionsList extends StatelessWidget {
  final double progress;
  final int currentIndex;
  final item;

  const QuestionsList({Key key, this.progress, this.currentIndex, this.item})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue],
            ),
          ),
          child: Center(
              child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Linearprogress(
                    progress: progress,
                  )),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20.0),
                child: Text("السؤال ${currentIndex + 1} من 3",
                    style: TextStyle(color: Colors.purple),
                    textDirection: TextDirection.rtl),
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${item.questionData}',
                    key: ValueKey<int>(currentIndex),
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ))
            ],
          ))),
    );
  }
}
