import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:ibdaa_app/src/ui/questionsList/questionsList.dart';

class QuestionsAnimation extends AnimatedWidget {
  final currentIndex;
  final progress;
  final item;
  final listQuestions;

  QuestionsAnimation(
    this.progress,
    this.currentIndex,
    this.item,
    this.listQuestions, {
    Key key,
    Animation<Offset> animation,
  }) : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    print(animation);
    return new AnimatedSwitcher(
      duration: const Duration(seconds: 2),
      transitionBuilder: (Widget child, Animation animation) {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
              .animate(animation),
        );
      },
      child: IndexedStack(
        key: ValueKey<int>(currentIndex),
        index: currentIndex,
        children: <Widget>[
          for (var item in listQuestions)
            QuestionsList(
              progress: progress,
              currentIndex: currentIndex,
              item: item,
            )
        ],
      ),
    );
  }
}
