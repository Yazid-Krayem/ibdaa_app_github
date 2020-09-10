import 'package:flutter/material.dart';

import '../style.dart';

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
    final width = MediaQuery.of(context).size.width;
    String mainQuestions = ' :هل تحب أو ترغب في';
    return Container(
      margin: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topRight,
            child: Text(
              "$mainQuestions",
              style: width < 500 ? mainQuestionWeb : mainQuestionWeb,
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${question['question_data']}",
            textAlign: TextAlign.center,
            style: width < 500 ? mobileQuestionsFont : webQuestionsFont,
          )
        ],
      ),
    );
  }
}
