import 'package:ibdaa_app/src/Models/getAnswers.dart';
import 'package:ibdaa_app/src/Models/getQuestions.dart';

class AnswersList {
  List<GetAnswers> items;
  List<GetQuestions> questionItems;

  AnswersList() {
    items = new List();
    questionItems = new List();
  }

  toJSONEncodable() {
    return items.map((item) {
      questionItems.map((ques) => ques.toJSONEncodable());
      return item.toJSONEncodable();
    }).toList();
  }
}
