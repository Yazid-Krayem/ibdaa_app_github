import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;
import 'package:ibdaa_app/models/answersList.dart';
import 'package:ibdaa_app/models/api.dart';
import 'package:ibdaa_app/models/getAnswers.dart';
import 'package:ibdaa_app/models/getQuestions.dart';
import 'package:ibdaa_app/ui/answersButtons/answersButtons.dart';
import 'package:ibdaa_app/ui/questionsList/questionsList.dart';
import 'package:ibdaa_app/ui/responsiveWIdget.dart';
import 'package:ibdaa_app/ui/submitPage/submitPage.dart';

import 'package:js_shims/js_shims.dart';
import 'package:localstorage/localstorage.dart';

import '../../main.dart';
import '../style.dart';

class QuizPage extends StatefulWidget {
  final deviceId;
  final cookieName;
  final List oldData;

  QuizPage(this.deviceId, this.cookieName, this.oldData) : super();
  @override
  _QuizPageState createState() => _QuizPageState(deviceId, cookieName, oldData);

  static of(BuildContext context) {}
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final deviceId;
  final cookieName;
  final List oldData;
  _QuizPageState(this.deviceId, this.cookieName, this.oldData) : super();

//LinearProgressIndicator methods

  double _progress = 0.33;

// to aviod meomory leak
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

//animation fucntions
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

  reserveProgress() {
    controller.reverse();
  }

  @override
  void initState() {
    this._getItemsFromLocalStorage();
    this._checkOldData();
    this._getQuestions();
    this._getAnswers();
    this.fetchQuestions();
    this.fetchAnswers();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween(begin: beginAnim, end: endAnim).animate(controller)
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

// Save and Delete data from Local Storage
  final LocalStorage storage = new LocalStorage(v1);
  final LocalStorage progressStorage = new LocalStorage('progress');
  bool initialized = false;

  List dataListWithCookieName;

  _checkOldData() {
    setState(() {
      dataListWithCookieName = oldData;
    });
    var findEmpty = dataListWithCookieName.contains('empty');

    switch (findEmpty) {
      case true:
        setState(() {
          dataListWithCookieName = null;
        });
        break;
      case false:
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

  //// Get the existing data
  ///
  ///
  int currentIndex = 0;

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

  List questionsListTest = [];

  final url = 'https://ibdaa.herokuapp.com';
  final url1 = 'http://localhost:8000';

  Future<List<dynamic>> fetchQuestions() async {
    var result = await http.get(
      '$url/questions/list',
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
    );

    setState(() {
      questionsListTest = json.decode(result.body)['result'];
    });
    return json.decode(result.body)['result'];
  }

//Get answers From the serve
  var listAnswers = new List<GetAnswers>();
  List answersList = [];

  Future<List<dynamic>> fetchAnswers() async {
    var result = await http.get(
      '$url/answers/list',
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
    );

    setState(() {
      answersList = json.decode(result.body)['result'];
    });
    return json.decode(result.body)['result'];
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

  // get Items from localStorageand
  // This function for checking  and count the items inside the local storage and it  return the NEW currentIndex

  _getItemsFromLocalStorage() async {
    await storage.ready;
    await progressStorage.ready;
    // final decoding = storage.getItem(deviceId);

    final progressLocalStorage = progressStorage.getItem('progress');

    setState(() {
      dataListWithCookieName = oldData;
    });
    var findEmpty = dataListWithCookieName.contains('empty');

    if (findEmpty || progressLocalStorage == null) {
      setState(() {
        currentIndex = 0;
        _progress = 0.33;
      });
    } else {
      setState(() {
        currentIndex = dataListWithCookieName.length;
        _progress = progressLocalStorage;
      });
    }
    return currentIndex;
  }

  returnButtonFunction() async {
    await storage.ready;

    List removeItemFromLocalStorageList = [];
    var getData = storage.getItem(deviceId);

    setState(() {
      removeItemFromLocalStorageList = getData;
      removeItemFromLocalStorageList = dataListWithCookieName;
    });

    // int deleteCurrentIndex = currentIndex - 1;
    await pop(removeItemFromLocalStorageList);

    await storage.deleteItem('ibdaa');
    storage.setItem("$cookieName", removeItemFromLocalStorageList);

    _decrementCurrentIndex();

    if (getData == []) {
      return false;
    }
  }

  // seState functions
  _incrementCurrentIndex() {
    setState(() {
      if (currentIndex < 3) {
        currentIndex++;
      }
    });
  }

  _decrementCurrentIndex() {
    if (currentIndex != 0) {
      setState(() {
        currentIndex--;
        _progress = _progress - 0.33;
      });
      progressStorage.setItem("progress", _progress);
    }
  }

  /////////
  //Answers function

  answersCallBack(item) async {
    await storage.ready;
    if (currentIndex != 0) {
      var getData = storage.getItem(deviceId);
      // final decoding = json.decode(items);
      // var getData = decoding['$deviceId'];
      setState(() {
        currentIndex = getData.length;
      });
    }
    _addItem(
      item.id,
      item.answersText,
      item.answerValue,
    );
    startProgress();
    _incrementCurrentIndex();
    if (currentIndex == 3) {
      Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SubmitPage(
                deviceId: deviceId,
                questionsListTest: questionsListTest,
                dataListWithCookieName: dataListWithCookieName,
                cookieName: cookieName,
                oldData: oldData,
                progress: _progress),
          ));
    }
    setState(() {
      _progress = (_progress + 0.333);
    });

    progressStorage.setItem("progress", _progress);
  }

  /// new design for stack
  /// //
  ///
  ///
  ///
  ///
  ///

  Widget indexStacked() {
    var orientation = MediaQuery.of(context).orientation;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        alignment: Alignment.center,
        width: orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width * 0.8
            : MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
          ),
        ),
        child: IndexedStack(
            index: currentIndex,
            children: questionsListTest.map((question) {
              if (questionsListTest.indexOf(question) <= 3) {
                return QuestionsList(
                    currentIndex: currentIndex,
                    progress: _progress,
                    question: question);
              } else {
                return Container();
              }
            }).toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return ResponsiveWIdget(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Quiz"),
        ),
        builder: (context, constraints) {
          if (oldData.length == 3)
            return _outOfQuestions();
          else
            return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.deepPurpleAccent, Colors.tealAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (orientation == Orientation.portrait) {
                      return _mobileScreen();
                    } else {
                      return _webScreen();
                    }
                  },
                ));
        });
  }

  //constraints.maxHeight < 650 ||
  // constraints.maxWidth < 600 ||
  Widget _mobileScreen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // return button
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                  shape: buttonStyle,
                  textColor: Colors.black,
                  color: Colors.blue,
                  onPressed: () => {
                    if (currentIndex == 0)
                      null
                    else
                      {
                        returnButtonFunction(),
                      }
                  },
                  child: Text("return", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),

          Column(
            children: [
              indexStacked(),

              Container(
                height: 300,
                child: _answersButtonMobileScreen(),
              )
              // _answersButtonMobileScreen()
            ],
          )

          //answers widget
        ],
      ),
    );
  }

  Widget _webScreen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                  shape: buttonStyle,
                  textColor: Colors.black,
                  color: Colors.blue,
                  onPressed: () => {
                    if (currentIndex == 0)
                      null
                    else
                      {
                        returnButtonFunction(),
                      }
                  },
                  child: Text("return", style: TextStyle(fontSize: 20)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // overflow: Overflow.clip,
              children: [
                indexStacked(),
                _answersButtonWebScreen(),
              ]),
          // return button
        ],

        //answers widget
      ),
    );
  }

  _answersButtonWebScreen() {
    return Column(
      children: [
        for (var item in listAnswers)
          Container(
            // padding: const EdgeInsets.only(bottom: 150.0),
            alignment: Alignment.bottomCenter,
            child: AnswersButtons(
                answersList: answersList,
                answersCallBack: answersCallBack,
                item: item,
                currentIndex: currentIndex),
          )
      ],
    );
  }

  _answersButtonMobileScreen() {
    return Wrap(
      children: [
        for (var item in listAnswers)
          AnswersButtons(
              answersList: answersList,
              answersCallBack: answersCallBack,
              item: item,
              currentIndex: currentIndex)
      ],
    );
  }

  Widget _outOfQuestions() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.tealAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                'You already answered the questions',
                style: outOfQuestionsTextStyle,
              )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new RaisedButton(
                    child: new Text("See the result "),
                    shape: buttonStyle,
                    onPressed: () async {
                      await Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => SubmitPage(
                                deviceId: deviceId,
                                questionsListTest: questionsListTest,
                                dataListWithCookieName: dataListWithCookieName,
                                cookieName: cookieName,
                                oldData: oldData,
                                progress: _progress),
                          ),
                          (Route<dynamic> route) => true);
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  RaisedButton(
                    child: new Text("Start over "),
                    shape: buttonStyle,
                    onPressed: () {
                      storage.clear();
                      progressStorage.clear();
                      setState(() {
                        dataListWithCookieName = [];
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ],
              )
            ]));
  }
}
