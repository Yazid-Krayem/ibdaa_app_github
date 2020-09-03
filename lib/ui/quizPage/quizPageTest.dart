import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ibdaa_app/models/getAnswers.dart';
import 'package:ibdaa_app/models/getQuestions.dart';
import 'package:http/http.dart' as http;

class QuizPageTest extends StatefulWidget {
  @override
  _QuizPageTestState createState() => _QuizPageTestState();
}

class _QuizPageTestState extends State<QuizPageTest> {
  Future<GetQuestions> futureQuestion;
  Future<GetAnswers> futureAnswers;

  bool _load = true;
  final url = 'https://ibdaa.herokuapp.com';

  Future<GetQuestions> fetchQuestion() async {
    final response = await http.get('$url/questions/list');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      setState(() {
        _load = !_load;
      });
      return GetQuestions.fromJson(json.decode(response.body)['result']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load triple');
    }
  }

  Future<GetAnswers> fetchAnswer() async {
    final response = await http.get('$url/answers/list');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GetAnswers.fromJson(json.decode(response.body)['result']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load triple');
    }
  }

  @override
  void initState() {
    super.initState();
    futureQuestion = fetchQuestion();
    futureAnswers = fetchAnswer();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: FutureBuilder<GetQuestions>(
        future: futureQuestion,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (orientation == Orientation.portrait ||
                    constraints.maxWidth < 800) {
                  return Container(
                    child: Text(snapshot.data.questionData),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
