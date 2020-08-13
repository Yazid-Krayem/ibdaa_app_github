class GetAnswers {
  final int id;
  final String answersText;
  final double answerValue;

  GetAnswers({this.id, this.answersText, this.answerValue});

  factory GetAnswers.fromJson(Map<String, dynamic> json) {
    return GetAnswers(
      id: json['id'],
      answersText: json['answers_text'],
      answerValue: json['answer_value'],
    );
  }
  Map toJson() {
    return {
      'id': id,
      'answers_text': answersText,
      'answer_value': answerValue,
    };
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['id'] = id;
    m['answers_text'] = answersText;
    m['answer_value'] = answerValue;

    return m;
  }
}
