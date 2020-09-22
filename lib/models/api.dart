import 'dart:async';
import 'package:http/http.dart' as http;

//
// const baseUrl = "https://ibdaa.herokuapp.com";
final baseUrl = 'http://ibdaa.sy/';

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

    var query = {
      "device_id": '$device_id',
      "user_answers": '$user_answers',
      "user_result": result
    };

    return http.post(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: query,
    );
  }

  static Future getTriple(
    result,
  ) {
    var url = baseUrl + "/triple/get/:$result";
    return http.get(
      url,
    );
  }

  static Future createLog(
    deviceId,
  ) {
    var url = baseUrl + "/log/add/";
    return http.post(url, body: {"deviceId": deviceId});
  }

  static Future updateLog(
    id,
  ) {
    var url = baseUrl + "/log/update/$id";
    return http.get(
      url,
    );
  }

  static Future feedBackAdd(deviceId, name, phoneNumber, message) {
    var url = baseUrl + "/feedback/add/";

    var query = {
      "deviceId": '$deviceId',
      "name": '$name',
      "phone_number": phoneNumber,
      "message": message
    };
    return http.post(url, body: query);
  }
}
