import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://localhost:3000";

class API {
  static Future getQuestions() {
    var url = baseUrl + "/questions/list";
    return http.get(url);
  }

  static Future getAnswers() {
    var url = baseUrl + "/answers/list";
    return http.get(url);
  }

  // static Future insertUserAnswers(
  //     user_question_question, user_question_answer, user_question_user) {
  //   var url = baseUrl + "/answers/list";
  //   return http.post(url, body: {
  //     'user_question_question': user_question_question,
  //     'user_question_answer': user_question_answer,
  //     'user_question_user': user_question_user
  //   });
  // }

  static Future userAnswersFromLocalStorage(data) {
    var url = baseUrl + "/users/add";
    return http.post(url, body: {'name': data});
  }
}
