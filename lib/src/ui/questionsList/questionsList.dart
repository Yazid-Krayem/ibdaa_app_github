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
    return Container(
        child: Center(
            child: Card(
                elevation: 8,
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Linearprogress(
                          progress: progress,
                        )),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Question ${currentIndex + 1} of 3',
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${item.question_data}',
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ))
                  ],
                ))));
  }
}
