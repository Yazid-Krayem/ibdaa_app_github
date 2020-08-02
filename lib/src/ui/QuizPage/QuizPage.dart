import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibdaa_app/src/Models/Api.dart';
import 'package:ibdaa_app/src/Models/answersList.dart';
import 'package:ibdaa_app/src/Models/getAnswers.dart';
import 'package:ibdaa_app/src/Models/getQuestions.dart';
import 'package:ibdaa_app/src/ui/SubmitPage/SubmitPage.dart';
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
  AnimationController controller;

  Animation animation;

  _QuizPageState(this.deviceId, this.cookieName);

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

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

  @override
  void initState() {
    super.initState();
    this._getQuestions();
    this._getAnswers();
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animation = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset.zero,
    ).animate(controller)
      ..addListener(() {
        setState(() {
          // Change here any Animation object value.
        });
      });
    // controller = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // );
    // _offsetAnimation = Tween<Offset>(
    //   end: Offset.zero,
    //   begin: const Offset(1.5, 0.0),
    // ).animate(CurvedAnimation(
    //   parent: controller,
    //   curve: Curves.elasticIn,
    // ));
  }

  double _progress = 0.33;

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

  Widget linearProgressIndicator() {
    return Positioned(
        child: Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.79,
        child: LinearProgressIndicator(
          backgroundColor: Colors.cyanAccent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
          value: _progress,
        ),
      ),
    ));
  }

  Widget returnButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topRight,
          child: RaisedButton.icon(
            hoverColor: Colors.black,
            onPressed: () => {_returnButtonFunction},
            icon: Icon(Icons.undo),
            textColor: Colors.white,
            color: Colors.lightBlue,
            label: Text('return to The Prevouis question'),
          )),
    );
  }

  Widget animateSwitcher() {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 3),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: IndexedStack(
        key: ValueKey<int>(_currentIndex),
        index: _currentIndex,
        children: <Widget>[
          for (var item in listQuestions) Center(child: questionsList(item))
        ],
      ),
    );
  }

  Widget questionsList(item) {
    return Center(
        child: Card(
            elevation: 8,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: linearProgressIndicator(),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Question ${_currentIndex + 1} of 3',
                            style: TextStyle(color: Colors.purple),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${item.question_data}',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            )))
                  ],
                ))

                //     ListTile(
                //   title: Text('Question ${_currentIndex + 1} of 3'),
                //   subtitle: Text("${item.question_data}"),
                // ))

                )));
  }

  Widget answersList(item) {
    return Padding(
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
