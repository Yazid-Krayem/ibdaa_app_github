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
//
  // _toggleItem(AnswersItem item) {
  //   setState(() {
  //     item.done = !item.done;
  //     _saveToStorage();
  //   });
  // }

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
  _checkStorage() async {
    var existing = await storage.getItem(deviceId);
  }

// // If no existing data, create an array
// // Otherwise, convert the localStorage string to an array
// existing = existing ? json.parse(existing) : {};

// // Add new data to localStorage Array
// existing['drink'] = 'soda';

// // Save back to localStorage
// storage.setItem('myLunch', JSON.stringify(existing));

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
    animation = Tween(begin: beginAnim, end: endAnim).animate(controller)
      ..addListener(() {
        setState(() {
          // Change here any Animation object value.
        });
      });
    this._getItemsFromLocalStorage();
  }

  double _progress = 0;
  _getItemsFromLocalStorage() async {
    Future.delayed(Duration(seconds: 2));

    var existing = await storage.getItem(deviceId);

    if (existing == null) {
      print('nill');
    }
    if (existing != null) {
      print(existing['id']);
    }
    // setState(() {
    //   _currentIndex = jsonString.length;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // for (var title in list) print(title['id'].toString());

    // map the the storage and get the index of it

    // setState(() {
    //   _currentIndex = jsonString.length;
    // });

    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Quiz"),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          returnButton(),
          linearProgressIndicator(),
          animateSwitcher(),
          for (var item in listAnswers) answersList(item)
        ]),
      ),
    );
  }

  Widget linearProgressIndicator() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: LinearProgressIndicator(
          backgroundColor: Colors.cyanAccent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
          value: _progress,
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
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
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
            child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Center(
                    child: ListTile(
                  title: Text('Question ${_currentIndex + 1} of 3'),
                  subtitle: Text("${item.question_data}"),
                )))));
  }

  Widget answersList(item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RaisedButton(
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
                    _progress = (_progress + 0.3);
                  })
                },
            child: Text("${item.answers_text}")),
        // _getLocalItems()
        // LinearProgressIndicator()
      ],
    );
  }
}
