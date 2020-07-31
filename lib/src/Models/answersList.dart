import 'package:ibdaa_app/src/Models/getAnswers.dart';

class AnswersList {
  List<GetAnswers> items;

  AnswersList() {
    items = new List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
