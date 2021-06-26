import './getAnswers.dart';

class AnswersList {
  List<GetAnswers> items;

  AnswersList() {
    // ignore: deprecated_member_use
    items = new List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
