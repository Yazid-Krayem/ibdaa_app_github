class GetQuestions {
  final int id;
  final String question_data;

  GetQuestions({
    this.id,
    this.question_data,
  });

  factory GetQuestions.fromJson(Map<String, dynamic> json) {
    return GetQuestions(
      id: json['id'],
      question_data: json['question_data'],
    );
  }
  Map toJson() {
    return {
      'id': id,
      'question_data': question_data,
    };
  }
}
