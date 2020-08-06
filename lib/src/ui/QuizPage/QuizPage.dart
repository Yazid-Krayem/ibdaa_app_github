import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibdaa_app/src/Models/Api.dart';
import 'package:ibdaa_app/src/Models/answersList.dart';
import 'package:ibdaa_app/src/Models/answersListFromCookieName.dart';
import 'package:ibdaa_app/src/Models/getAnswers.dart';
import 'package:ibdaa_app/src/Models/getQuestions.dart';
import 'package:ibdaa_app/src/ui/SubmitPage/SubmitPage.dart';
import 'package:ibdaa_app/src/ui/answersList/answersList.dart';
import 'package:ibdaa_app/src/ui/questionsList/questionsList.dart';
import 'package:ibdaa_app/src/ui/returnButton/returnButton.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:html';
import 'package:js_shims/js_shims.dart';

class QuizPage extends StatefulWidget {
  final deviceId;
  final cookieName;
  final List oldData;
  QuizPage(this.deviceId, this.cookieName, this.oldData);

  @override
  _QuizPageState createState() => _QuizPageState(deviceId, cookieName, oldData);
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  final deviceId;
  final cookieName;
  final List oldData;
  _QuizPageState(this.deviceId, this.cookieName, this.oldData);

//LinearProgressIndicator methods

  double _progress = 0.33;

// to aviod meomory leak
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

//animation fucntions
  Animation<Offset> animation;
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

  reserveProgress() {
    print(_currentIndex);

    controller.reverse();
  }

  @override
  void initState() {
    this._checkOldData();
    this._getQuestions();
    this._getAnswers();
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animation = Tween<Offset>(begin: Offset(0, 1), end: Offset(1, 0))
        .animate(controller)
          ..addListener(() {
            setState(() {
              // Change here any Animation object value.
            });
          });
    super.initState();
  }

  //localStorage functions

  static final v1 = 'ibdaa';

// get questions and answers from localStorage
  final AnswersList list1 = new AnswersList();
  final AnswersListFromCookieName listDataFromCookieName =
      new AnswersListFromCookieName();

// Save and Delete data from Local Storage
  final LocalStorage storage = new LocalStorage(v1);
  bool initialized = false;

  List dataListWithCookieName = [];

  _checkOldData() {
    setState(() {
      dataListWithCookieName = oldData;
    });
    var findEmpty = dataListWithCookieName.contains('empty');
    if (findEmpty) {
      setState(() {
        dataListWithCookieName = [];
      });
    } else {
      setState(() {
        dataListWithCookieName = oldData;
      });
    }
  }

  _addItem(int id, String answersText, double answerValue) async {
    //save the old items in the new list

    setState(() {
      final item = new GetAnswers(
          id: id, answersText: answersText, answerValue: answerValue);
      list1.items.add(item);
      dataListWithCookieName.add(item);

      storage.setItem("$cookieName", dataListWithCookieName);
    });
  }

  // _saveToStorage() {
  //   storage.setItem("$deviceId", list1.toJSONEncodable());
  // }

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

// Get questions From the server

  var listQuestions = new List<GetQuestions>();

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

//Get answers From the serve
  var listAnswers = new List<GetAnswers>();
  _getAnswers() async {
    new Future.delayed(const Duration(seconds: 3));

    await API.getAnswers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body)['result'];
        listAnswers = list.map((model) => GetAnswers.fromJson(model)).toList();
      });
    });
  }

  // get Items from localStorageand
  // This function for checking  and count the items inside the local storage and it  return the NEW currentIndex

  _getItemsFromLocalStorage() async {
    setState(() {
      dataListWithCookieName = oldData;
    });
    var findEmpty = dataListWithCookieName.contains('empty');
    if (findEmpty) {
      setState(() {
        _currentIndex = 0;
      });
    } else {
      setState(() {
        _currentIndex = dataListWithCookieName.length;
      });
    }
    print(_currentIndex);
    return _currentIndex;
  }

  returnButtonFunction() async {
    final Storage _localStorage = window.localStorage;

    List removeItemFromLocalStorageList = [];
    var items = _localStorage['ibdaa'];

    final decoding = json.decode(items);
    var getData = decoding['$deviceId'];

    setState(() {
      removeItemFromLocalStorageList = getData;
    });

    int deleteCurrentIndex = _currentIndex - 1;
    await pop(removeItemFromLocalStorageList);

    // setState(() {
    //   removeItemFromLocalStorageList = test;
    // });
    await storage.deleteItem('ibdaa');
    storage.setItem("$cookieName", removeItemFromLocalStorageList);

    print(
        "deleted array $removeItemFromLocalStorageList +++ currentIndex $deleteCurrentIndex  ");

    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = _currentIndex - 1;
      });
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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                  RaisedButton.icon(
                    hoverColor: Colors.black,
                    onPressed: () => {returnButtonFunction()},
                    icon: Icon(Icons.arrow_back),
                    textColor: Colors.white,
                    color: Colors.lightBlue,
                    label: Text('عودة'),
                  ),
                  animateSwitcher(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var item in listAnswers)
                  AnswerList(item: item, answersCallBack: answersCallBack),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget returnButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topRight,
          child: RaisedButton(
              onPressed: () => {
                    if (_currentIndex != 0)
                      {
                        setState(() {
                          _currentIndex = (_currentIndex - 1);
                        }),
                      }
                  },
              child: Text('return'))),
    );
  }

  Widget animateSwitcher() {
    return new AnimatedSwitcher(
      duration: const Duration(seconds: 2),
      transitionBuilder: (Widget child, Animation animation) {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(begin: Offset(1.0, 0), end: Offset.zero)
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

  //Answers function

  answersCallBack(item) {
    _addItem(
      item.id,
      item.answersText,
      item.answerValue,
    );
    startProgress();
    setState(() {
      _currentIndex = (_currentIndex + 1);
    });
    if (_currentIndex == 3) {
      Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SubmitPage(deviceId),
          ));
    }
    setState(() {
      _progress = (_progress + 0.333);
    });
  }
}

// This class for checking the items inside the localStorage
class User {
  int id;
  String answersText;
  double answerValue;

  User(this.id, this.answersText, this.answerValue);

  factory User.fromJson(dynamic json) {
    return User(json['id'] as int, json['answers_text'] as String,
        json['answer_value'] as double);
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.answersText}, ${this.answerValue} }';
  }
}
