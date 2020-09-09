import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;
import 'package:ibdaa_app/models/answersList.dart';
import 'package:ibdaa_app/models/api.dart';
import 'package:ibdaa_app/models/getAnswers.dart';
import 'package:ibdaa_app/ui/answersButtons/answersButtons.dart';
import 'package:ibdaa_app/ui/linearProgressIndicator/linearProgressIndicator.dart';
import 'package:ibdaa_app/ui/questionsList/questionsList.dart';
import 'package:ibdaa_app/ui/responsiveWIdget.dart';
import 'package:ibdaa_app/ui/submitPage/submitPage.dart';
import 'package:localstorage/localstorage.dart';
import '../style.dart';

class EditPage extends StatefulWidget {
  final deviceId;
  final List questionsList;
  final List oldData;

  EditPage(this.deviceId, this.questionsList, this.oldData) : super();
  @override
  _QuizPageState createState() =>
      _QuizPageState(deviceId, questionsList, oldData);
}

class _QuizPageState extends State<EditPage> with TickerProviderStateMixin {
  final deviceId;
  final List questionsList;
  final List oldData;
  _QuizPageState(this.deviceId, this.questionsList, this.oldData) : super();

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
    this._editLocalStorageList();
    this.fetchAnswers();
    this._getAnswers();
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

  _editLocalStorageList() {
    setState(() {
      dataListWithCookieName = oldData;
    });
  }

  _addItem(int id, String answersText, double answerValue) async {
    dataListWithCookieName.asMap().forEach((key, value) {
      if (questionsList[currentIndex]['id'] == key) {
        // print(dataListWithCookieName[currentIndex - 1]);
        setState(() {
          final item = new GetAnswers(
              id: id, answersText: answersText, answerValue: answerValue);
          print(item);

          dataListWithCookieName[currentIndex] = item;

          storage.clear();

          storage.setItem("$deviceId", dataListWithCookieName);
        });
      }
    });
  }

  //// Get the existing data
  ///
  ///
  int currentIndex = 0;

  // Get questions From the server

  // final url = 'https://ibdaa.herokuapp.com';
  final url = '';

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

  int lengthOflocalStorageItems;
  int pressedButton;

  _pressedButton() async {
    await storage.ready;

    var getData = storage.getItem(deviceId);
    setState(() {
      pressedButton = getData[currentIndex]['id'];
    });
  }

  returnButtonFunction() async {
    await storage.ready;

    var getData = storage.getItem(deviceId);

    setState(() {
      lengthOflocalStorageItems = getData.length - 1;
    });
    await _pressedButton();

    _decrementCurrentIndex();

    if (getData == []) {
      return false;
    }
  }

  // seState functions
  _incrementCurrentIndex() {
    setState(() {
      if (currentIndex < questionsList.length) {
        currentIndex++;
      }
      if (_imagesIndex == 5) {
        setState(() {
          _imagesIndex = 0;
        });
      }
      if (currentIndex == 20 ||
          currentIndex == 40 ||
          currentIndex == 60 ||
          currentIndex == 80 ||
          currentIndex == 100 ||
          currentIndex == 120) {
        _imagesIndex++;
      }
    });
  }

  _decrementCurrentIndex() {
    if (currentIndex != 0) {
      setState(() {
        currentIndex--;
        _progress = _progress - 0.33;
      });
      if (_imagesIndex == 5) {
        setState(() {
          _imagesIndex = 0;
        });
      }
      if (currentIndex == 20 ||
          currentIndex == 40 ||
          currentIndex == 60 ||
          currentIndex == 80 ||
          currentIndex == 100 ||
          currentIndex == 120) {
        _imagesIndex++;
      }
      progressStorage.setItem("progress", _progress);
    }
  }

  List _quizPageImages = [
    '/images/1.png',
    '/images/2.jpg',
    '/images/3.jpg',
    '/images/4.jpg',
    '/images/5.jpg',
    '/images/6.jpg',
  ];

  int _imagesIndex = 0;

  clickFunctionWithoutAddToLocalStorage(item) async {
    await storage.ready;
    if (currentIndex != 0) {
      setState(() {
        pressedButton = 0;
        currentIndex++;
      });
    }

    startProgress();
    _incrementCurrentIndex();

    setState(() {
      _progress = (_progress + 0.333);
    });

    progressStorage.setItem("progress", _progress);
  }

  /////////
  //Answers function

  answersCallBack(item) async {
    _addItem(item.id, item.answersText, item.answerValue);
    startProgress();
    _incrementCurrentIndex();

    // if (getData.length == questionsList.length) {

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

    return Container(
      alignment: Alignment.center,
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.6
          : MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.lightBlue, width: 2),
        color: Colors.lightBlue,
      ),
      child: IndexedStack(
          key: ValueKey<int>(currentIndex),
          index: currentIndex,
          children: questionsList.map((question) {
            if (questionsList.indexOf(question) <= questionsList.length) {
              return QuestionsList(
                  currentIndex: currentIndex,
                  progress: _progress,
                  question: question);
            } else {
              return Container();
            }
          }).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(child: ResponsiveWIdget(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orientation == Orientation.landscape
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  '${_quizPageImages[_imagesIndex]}'),
                              fit: BoxFit.cover),
                        ),
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height,
                        child: null),
                  )
                : Container(),
            Container(
                width: orientation == Orientation.landscape ? width / 2 : width,
                child: _mobileScreen())
          ],
        ),
      );
    }));
  }

  Widget _mobileScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // return button

        Row(
          children: [
            // return button
            Container(
              // alignment: Alignment.topRight,
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton.icon(
                label: Text("السؤال السابق", style: TextStyle(fontSize: 16)),
                icon: Icon(Icons.keyboard_return),
                shape: buttonStyle,
                textColor: Colors.lightBlue,
                color: Colors.white,
                onPressed: () => {
                  if (currentIndex == 0)
                    null
                  else
                    {
                      returnButtonFunction(),
                    }
                },
                //   child: FittedBox(
                //       fit: BoxFit.fitWidth,
                //       child: Text("السؤال السابق", style: TextStyle(fontSize: 16))),
                // ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton.icon(
                shape: buttonStyle,
                textColor: Colors.white,
                color: Colors.lightBlue,
                onPressed: () async {
                  Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SubmitPage(
                          deviceId: deviceId,
                          questionsList: questionsList,
                          dataListWithCookieName: dataListWithCookieName,
                          cookieName: deviceId,
                          oldData: oldData,
                          progress: _progress,
                        ),
                      ));
                },
                label: Text('إرسال'),
                icon: Icon(Icons.send),
              ),
            ),
          ],
        ),

        SizedBox(
          height: 8.0,
        ),

        Column(
          children: [
            indexStacked(),
            Container(
              height: 300,
              child: _answersButtonMobileScreen(),
            ),
            Linearprogress(
              currentIndex: currentIndex + 1,
              totalNumberOfQuestions: questionsList.length,
            ),
            Container(
                // height: outlineContainerHeight,
                // width: outlineContainerWidth,
                child: Center(
              child: Text(
                '${currentIndex + 1} /${questionsList.length}',
                style: TextStyle(
                    color: currentIndex >= 100
                        ? Colors.lightBlue
                        : Colors.lightBlue),
              ),
            ))
          ],
        )
      ],
    );
  }

  _answersButtonMobileScreen() {
    this._pressedButton();

    return Column(
      children: [
        for (var item in listAnswers)
          new AnswersButtons(
            clickFunctionWithoutAddToLocalStorage:
                clickFunctionWithoutAddToLocalStorage,
            answersList: answersList,
            answersCallBack: answersCallBack,
            item: item,
            currentIndex: currentIndex,
            lengthOflocalStorageItems: lengthOflocalStorageItems,
            pressedButton: pressedButton,
          )
      ],
    );
  }
}
