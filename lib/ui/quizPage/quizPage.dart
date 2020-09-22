import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class QuizPage extends StatefulWidget {
  final deviceId;
  final String cookieName;
  final List oldData;
  final List questionsListTest;
  final List answersList;

  QuizPage(this.deviceId, this.cookieName, this.oldData, this.questionsListTest,
      this.answersList)
      : super();
  @override
  _QuizPageState createState() => _QuizPageState(
      deviceId, cookieName, oldData, questionsListTest, answersList);

  static of(BuildContext context) {}
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final deviceId;
  final String cookieName;
  final List oldData;
  final List questionsListTest;
  final List answersList;
  _QuizPageState(this.deviceId, this.cookieName, this.oldData,
      this.questionsListTest, this.answersList)
      : super();

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

  __getQuestionList() async {
    setState(() {
      questionsList = questionsListTest;
    });
  }

  @override
  void initState() {
    this.__getQuestionList();
    this._onLoadCurrentIndex();
    this._getItemsFromLocalStorage();
    this._checkOldData();
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
    if (dataListWithCookieName.isEmpty) {
      setState(() {
        final item = new GetAnswers(
            id: id, answersText: answersText, answerValue: answerValue);
        list1.items.add(item);
        dataListWithCookieName.add(item);

        storage.setItem("$cookieName", dataListWithCookieName);
      });
    } else if (currentIndex < dataListWithCookieName.length) {
      dataListWithCookieName.asMap().forEach((key, value) {
        if (questionsList[currentIndex]['id'] == key) {
          setState(() {
            setState(() {
              final item = new GetAnswers(
                  id: id, answersText: answersText, answerValue: answerValue);
              dataListWithCookieName[currentIndex] = item;

              storage.clear();

              storage.setItem("$cookieName", dataListWithCookieName);
            });
          });
        }
      });
    } else {
      setState(() {
        final item = new GetAnswers(
            id: id, answersText: answersText, answerValue: answerValue);
        list1.items.add(item);
        dataListWithCookieName.add(item);

        storage.setItem("$cookieName", dataListWithCookieName);
      });
    }
  }

  //// Get the existing data
  ///
  ///
  int currentIndex = 0;

  // Get questions From the server

  List questionsList = [];

  final url = 'https://ibdaa.herokuapp.com';

  // final url = 'http://localhost:8000';

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

  int lengthOflocalStorageItems;
  int pressedButton;

  _pressedButton(getData) async {
    setState(() {
      pressedButton = getData[currentIndex - 1]['id'];
    });
  }

  returnButtonFunction() async {
    await storage.ready;

    var getData = storage.getItem(deviceId);

    setState(() {
      lengthOflocalStorageItems = getData.length - 1;
    });
    await _pressedButton(getData);
    _decrementCurrentIndex();

    if (getData == []) {
      return false;
    }
  }

  // seState functions
  _incrementCurrentIndex() {
    if (currentIndex < questionsList.length) {
      setState(() {
        currentIndex++;
      });
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
      setState(() {
        _imagesIndex++;
      });
    }
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
      // var getData = storage.getItem(deviceId);
      setState(() {
        pressedButton = 0;
        currentIndex++;
      });
    }

    startProgress();
    _incrementCurrentIndex();
    var getData = storage.getItem(deviceId);

    if (getData.length == questionsList.length) {
      Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SubmitPage(
              deviceId: deviceId,
              questionsList: questionsList,
              dataListWithCookieName: dataListWithCookieName,
              cookieName: cookieName,
              oldData: oldData,
              progress: _progress,
            ),
          ));
    }
    setState(() {
      _progress = (_progress + 0.333);
    });

    progressStorage.setItem("progress", _progress);
  }

  _onLoadCurrentIndex() async {
    await storage.ready;
    var getData = storage.getItem(deviceId);
    if (currentIndex != 0) {
      setState(() {
        pressedButton = 0;
        currentIndex = getData.length;
      });
      // print('getDta $currentIndex');
      // print('getDta ${getData.length}');
    }
  }

  /////////
  //Answers function

  _questionLengthCheck() async {
    if (currentIndex > 120) {
      return Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SubmitPage(
              deviceId: deviceId,
              questionsList: questionsList,
              dataListWithCookieName: dataListWithCookieName,
              cookieName: cookieName,
              oldData: oldData,
              progress: _progress,
            ),
          ));
    }
  }

  answersCallBack(item) async {
    await _questionLengthCheck();
    setState(() {
      pressedButton = 0;
    });
    await _addItem(item.id, item.answersText, item.answerValue);
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

  bool _load = false;

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(child: ResponsiveWIdget(builder: (context, constraints) {
      if (questionsList.length == oldData.length)
        return _load
            ? Center(child: CircularProgressIndicator())
            : SubmitPage(
                deviceId: deviceId,
                questionsList: questionsList,
                dataListWithCookieName: dataListWithCookieName,
                cookieName: cookieName,
                oldData: oldData,
                progress: _progress,
              );
      else {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width:
                      orientation == Orientation.landscape ? width / 2 : width,
                  child: _mobileScreen()),
              orientation == Orientation.landscape && height > 500
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: theImage[_imagesIndex], fit: BoxFit.cover),
                        ),
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height,
                        child: null,
                      ))
                  : Container()
            ],
          ),
        );
      }
    }));
  }

  Widget _mobileScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // return button
        Container(
          alignment: Alignment.bottomLeft,
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
          ),
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
              pressedButton: pressedButton)
      ],
    );
  }
}
