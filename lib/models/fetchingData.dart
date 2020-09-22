import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ibdaa_app/models/getQuestions.dart';
import 'package:ibdaa_app/models/triple.dart';
import 'package:ibdaa_app/ui/resultPage/alertResultPage.dart';

// final url = 'https://ibdaa.herokuapp.com';
final url = 'http://ibdaa.sy/';

Future<GetTriple> fetchAlbum(result, context) async {
  final response = await http.get('$url/triple/get/$result');

  if (response.statusCode == 200) {
    return GetTriple.fromJson(json.decode(response.body)['result']);
  } else {
    showDialogResultPage(context);

    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load triple');
  }
}

Future<GetQuestions> fetchQuestion() async {
  final response = await http.get('$url/questions/list');

  if (response.statusCode == 200) {
    return GetQuestions.fromJson(json.decode(response.body)['result']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load triple');
  }
}

Future<List<dynamic>> fetchPost() async {
  final response = await http.get('$url/questions/list');

  if (response.statusCode == 200) {
    List<dynamic> post = jsonDecode(response.body)['result'];
    print(post.runtimeType);
    return post;
  } else {
    throw Exception('Failed to load post');
  }
}
