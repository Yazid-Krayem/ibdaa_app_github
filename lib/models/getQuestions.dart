class GetQuestions {
  final int id;
  final String questionData;

  GetQuestions({
    this.id,
    this.questionData,
  });

  factory GetQuestions.fromJson(Map<String, dynamic> json) {
    return GetQuestions(
      id: json['id'],
      questionData: json['question_data'],
    );
  }
  Map toJson() {
    return {
      'id': id,
      'question_data': questionData,
    };
  }
}
