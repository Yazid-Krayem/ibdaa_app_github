import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "https://ibdaa.herokuapp.com";
final baseUrl1 = 'http://localhost:3000';

class API {
  static Future getQuestions() {
    var url = baseUrl + "/questions/list";
    return http.get(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
    );
  }

  static Future getAnswers() {
    var url = baseUrl + "/answers/list";
    return http.get(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
    );
  }

  static Future usersAnswers(device_id, result, user_answers) {
    var url = baseUrl + "/result/add";

    print(
        "device_id $device_id ,++ questions $result ++ user_answers $user_answers");
    return http.post(url, body: {
      'device_id': device_id,
      'user_result': result,
      'user_answers': user_answers
    });
  }

  static Future userAnswersFromLocalStorage(data) {
    var url = baseUrl + "/users/add";
    return http.post(url, body: {'name': data});
  }
}
