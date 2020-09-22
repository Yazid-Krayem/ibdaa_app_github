import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;
import 'package:ibdaa_app/common/imageClass.dart';
import 'package:ibdaa_app/models/answersList.dart';

import 'package:ibdaa_app/models/api.dart';
import 'package:ibdaa_app/models/getAnswers.dart';
import 'package:ibdaa_app/ui/answersButtons/answersButtons.dart';
import 'package:ibdaa_app/ui/editPage/alertEditPage.dart';
import 'package:ibdaa_app/ui/linearProgressIndicator/linearProgressIndicator.dart';
import 'package:ibdaa_app/ui/questionsList/questionsList.dart';
import 'package:ibdaa_app/ui/responsiveWIdget.dart';
import 'package:ibdaa_app/ui/resultPage/resultPage.dart';
import 'package:ibdaa_app/ui/submitPage/submitPage.dart';
import 'package:localstorage/localstorage.dart';
import '../style.dart';

class EditPage extends StatefulWidget {
  final deviceId;
  final List questionsList;
  final List oldData;
  final int newCurrentIndex;

  EditPage(
      this.deviceId, this.questionsList, this.oldData, this.newCurrentIndex)
      : super();
  @override
  _QuizPageState createState() =>
      _QuizPageState(deviceId, questionsList, oldData, newCurrentIndex);
}

class _QuizPageState extends State<EditPage> with TickerProviderStateMixin {
  final deviceId;
  final List questionsList;
  final List oldData;
  final int newCurrentIndex;

  _QuizPageState(
      this.deviceId, this.questionsList, this.oldData, this.newCurrentIndex)
      : super();

//LinearProgressIndicator methods

  _changeCurrentIndex() async {
    setState(() {
      currentIndex = newCurrentIndex - 1;
    });
  }

  final LocalStorage tripleName = new LocalStorage('tripleName');
  List answersData = [];
  _getLocalStorageData() async {
    var items = storage.getItem(deviceId);
    setState(() {
      answersData = items;
    });
  }

  List questionWithAnswer = [];
  _questionWithAnswer() async {
    await _getLocalStorageData();
    List _insideList = [];

    List answers = [];

    setState(() {
      answers = answersData;
    });

    questionsList.asMap().forEach((key, value) {
      _insideList.insert(key, {
        '"question_id"': '${value['id']}',
        '"answers_text"': '"${(answers[key]['answers_text'])}"',
        '"answer_value"': '${(answers[key]['answer_value'])}'
      });
    });
    return setState(() {
      questionWithAnswer = _insideList;
    });
  }

  String resultString;
  _addResult(deviceId, stringResult, user_answers) async {
    await API
        .usersAnswers(deviceId, stringResult, user_answers)
        .then((response) {
      var result = jsonDecode(response.body);

      if (result['success']) {
        setState(() {
          resultString = result['result'];
        });
        tripleName.setItem('tripleName', resultString);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ResultPage(
                  result: resultString,
                )));
      } else {
        alertEditPage(context);
      }
    });
  }

  @override
  void initState() {
    this._changeCurrentIndex();
    this._editLocalStorageList();
    this.fetchAnswers();
    this._getAnswers();
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

  final url = 'https://ibdaa.herokuapp.com';
  // final url = 'http://localhost:8000';
//
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
    if (currentIndex > 119) {
      setState(() {
        currentIndex = 0;
      });
    }
    setState(() {
      if (currentIndex < questionsList.length - 1) {
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
    }
  }

  //image
  final List theImage = [
    AssetImage(
      '/images/1.png',
    ),
    AssetImage(
      '/images/2.jpg',
    ),
    AssetImage(
      '/images/3.jpg',
    ),
    AssetImage(
      '/images/4.jpg',
    ),
    AssetImage(
      '/images/5.jpg',
    ),
    AssetImage(
      '/images/6.jpg',
    )
  ];

  /// Did Change Dependencies
  @override
  void didChangeDependencies() {
    precacheImage(theImage[_imagesIndex], context);
    super.didChangeDependencies();
  }

  int _imagesIndex = 0;

  clickFunctionWithoutAddToLocalStorage(item) async {
    await storage.ready;
    if (currentIndex != 0) {
      setState(() {
        pressedButton = 0;
        currentIndex++;
      });
    }
    _incrementCurrentIndex();
  }

  /////////
  //Answers function
  _questionLengthCheck() async {
    if (currentIndex > 118) {
      return Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SubmitPage(
              deviceId: deviceId,
              questionsList: questionsList,
              dataListWithCookieName: dataListWithCookieName,
              cookieName: deviceId,
              oldData: oldData,
            ),
          ));
    }
  }

  answersCallBack(item) async {
    await _questionLengthCheck();

    await _addItem(item.id, item.answersText, item.answerValue);
    _incrementCurrentIndex();

    // if (getData.length == questionsList.length) {
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
    var height = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.center,
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.6
          : MediaQuery.of(context).size.width * 0.4,
      height: orientation == Orientation.landscape && height < 500
          ? MediaQuery.of(context).size.height * 0.4
          : MediaQuery.of(context).size.height * 0.2,
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
                  currentIndex: currentIndex, question: question);
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
    var height = MediaQuery.of(context).size.height;

    return SafeArea(child: ResponsiveWIdget(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: orientation == Orientation.landscape ? width / 2 : width,
                child: _mobileScreen()),
            orientation == Orientation.landscape && height > 500
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: Container(
                      width: width / 2,
                      height: height,
                      child: ImageWidgetPlaceholder(
                        image: theImage[_imagesIndex],
                        height: height,
                      ),
                    ),
                  )
                : Container()
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          // shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // return button
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton.icon(
                shape: buttonStyle,
                textColor: Colors.lightBlue,
                color: Colors.white,
                onPressed: () async {
                  setState(() {
                    currentIndex++;
                  });
                },
                label: Text('السؤال التالي'),
                icon: Icon(Icons.navigate_next),
              ),
            ),
            currentIndex == 0
                ? SizedBox()
                : Container(
                    // alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton.icon(
                      label:
                          Text("السؤال السابق", style: TextStyle(fontSize: 16)),
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
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton.icon(
            shape: buttonStyle,
            textColor: Colors.white,
            color: Colors.lightBlue,
            onPressed: () async {
              await _questionWithAnswer();
              await _addResult(deviceId, '3', questionWithAnswer);
            },
            label: Text('عرض النتيجة'),
            icon: Icon(Icons.send),
          ),
        ),
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
