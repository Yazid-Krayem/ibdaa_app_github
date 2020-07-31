class GetAnswers {
  final int id;
  final String answers_text;
  final double answer_value;

  GetAnswers({this.id, this.answers_text, this.answer_value});

  factory GetAnswers.fromJson(Map<String, dynamic> json) {
    return GetAnswers(
      id: json['id'],
      answers_text: json['answers_text'],
      answer_value: json['answer_value'],
    );
  }
  Map toJson() {
    return {
      'id': id,
      'answers_text': answers_text,
      'answer_value': answer_value,
    };
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['id'] = id;
    m['answers_text'] = answers_text;
    m['answer_value'] = answer_value;

    return m;
  }
}
