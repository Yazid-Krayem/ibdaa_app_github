import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibdaa_app/src/Models/Api.dart';
import 'package:ibdaa_app/src/Models/answersList.dart';
import 'package:ibdaa_app/src/Models/getAnswers.dart';
import 'package:ibdaa_app/src/Models/getQuestions.dart';
import 'package:ibdaa_app/src/ui/SubmitPage/SubmitPage.dart';
import 'package:ibdaa_app/src/ui/questionsList/questionsList.dart';
import 'package:localstorage/localstorage.dart';

class QuizPage extends StatefulWidget {
  final deviceId;
  final cookieName;
  QuizPage(this.deviceId, this.cookieName);

  @override
  _QuizPageState createState() => _QuizPageState(deviceId, cookieName);
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  final deviceId;
  final cookieName;

//LinearProgressIndicator methods

  double _progress = 0.33;

  _QuizPageState(this.deviceId, this.cookieName);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

//animation
  Animation<double> animation;
  AnimationController controller;
  double beginAnim = 0.0;
  double endAnim = 1.0;
  startProgress() {
    controller.forward();
  }

  stopProgress() {
    controller.stop();
  }

  resetProgress() {
    controller.reset();
  }

  @override
  void initState() {
    this._getQuestions();
    this._getAnswers();
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    super.initState();
  }

  static final v1 = 'ibdaa';

// get questions and answers from server
  final AnswersList list1 = new AnswersList();

// Save and Delete data from Local Storage
  final LocalStorage storage = new LocalStorage(v1);
  bool initialized = false;

  _addItem(int id, String answers_text, double answer_value) {
    setState(() {
      final item = new GetAnswers(
          id: id, answers_text: answers_text, answer_value: answer_value);
      list1.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem("$deviceId", list1.toJSONEncodable());
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list1.items = storage.getItem("$deviceId") ?? [];
    });
  }

  //// Get the existing data
  ///
  ///
  int _currentIndex = 0;

  var listQuestions = new List<GetQuestions>();
  var listAnswers = new List<GetAnswers>();

  _getQuestions() async {
    new Future.delayed(const Duration(seconds: 3));

    await API.getQuestions().then((response) {
      setState(() {
        Iterable list = json.decode(response.body)['result'];
        listQuestions =
            list.map((model) => GetQuestions.fromJson(model)).toList();
      });
    });
  }

  _getAnswers() async {
    new Future.delayed(const Duration(seconds: 3));

    await API.getAnswers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body)['result'];
        listAnswers = list.map((model) => GetAnswers.fromJson(model)).toList();
      });
    });
  }

  _getItemsFromLocalStorage() async {
    var items = storage.getItem(deviceId);
    if (items == null) {
      setState(() {
        _currentIndex = 0;
      });
    } else {
      String jsonString = jsonEncode(items); // encode map to json
      var tagObjsJson = jsonDecode(jsonString) as List;
      List<User> tagObjs =
          tagObjsJson.map((tagJson) => User.fromJson(tagJson)).toList();

      setState(() {
        _currentIndex = tagObjs.length;
      });
    }
    return _currentIndex;
  }

  get _returnButtonFunction async {
    if (_currentIndex == 0) {
      return false;
    } else {
      setState(() {
        _currentIndex = _currentIndex - 1;
      });

      // storage.deleteItem(deviceId[_currentIndex]);

      // setState(() {
      //   listForTesting = storage.getItem("$deviceId");
      // });
      // // list1.items.removeWhere((item) => item.id == '1');

      // print(listForTesting[_currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getItemsFromLocalStorage();

    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Quiz"),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.tealAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
          child: Column(children: <Widget>[
            Container(
              child: Column(
                children: [
                  returnButton(),
                  animateSwitcher(),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var item in listAnswers) answersList(item),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget returnButton() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topRight,
      child: RaisedButton.icon(
        hoverColor: Colors.black,
        onPressed: () => {_returnButtonFunction},
        icon: Icon(Icons.undo),
        textColor: Colors.white,
        color: Colors.lightBlue,
        label: Text('return to The Prevouis question'),
      ),
    );
  }

//TODO: replace IndexedStack with stack_Cards package
  Widget animateSwitcher() {
    return new AnimatedSwitcher(
      duration: const Duration(seconds: 2),
      transitionBuilder: (Widget child, Animation animation) {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
              .animate(animation),
        );
      },
      child: IndexedStack(
        key: ValueKey<int>(_currentIndex),
        index: _currentIndex,
        children: <Widget>[
          for (var item in listQuestions)
            QuestionsList(
              progress: _progress,
              currentIndex: _currentIndex,
              item: item,
            )
        ],
      ),
    );
  }

  Widget answersList(item) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        padding: const EdgeInsets.only(right: 20.0),
        child: RaisedButton(
            color: Colors.white,
            shape: StadiumBorder(),
            onPressed: () => {
                  _addItem(item.id, item.answers_text, item.answer_value),
                  startProgress(),
                  setState(() {
                    _currentIndex = (_currentIndex + 1);
                  }),
                  if (_currentIndex == 3)
                    {
                      Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SubmitPage(deviceId),
                          ))
                    },
                  setState(() {
                    _progress = (_progress + 0.333);
                  })
                },
            child: Text("${item.answers_text}")),
      ),
    );
  }
}

class User {
  int id;
  String answers_text;
  double answer_value;

  User(this.id, this.answers_text, this.answer_value);

  factory User.fromJson(dynamic json) {
    return User(json['id'] as int, json['answers_text'] as String,
        json['answer_value'] as double);
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.answers_text}, ${this.answer_value} }';
  }
}
