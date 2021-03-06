import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ibdaa_app/models/api.dart';
import 'package:ibdaa_app/ui/editPage/editPage.dart';
import 'package:ibdaa_app/ui/introPage/introPage.dart';
import 'package:ibdaa_app/ui/resultPage/resultPage.dart';
import 'package:ibdaa_app/ui/style.dart';
import 'package:localstorage/localstorage.dart';
import 'package:cooky/cooky.dart' as cookie;

class SubmitPage extends StatefulWidget {
  final deviceId;
  final List questionsList;
  final List oldData;
  final List dataListWithCookieName;
  final String cookieName;

  SubmitPage({
    Key key,
    @required this.deviceId,
    @required this.questionsList,
    @required this.dataListWithCookieName,
    @required this.cookieName,
    @required this.oldData,
  }) : super(key: key);

  @override
  _SubmitPageState createState() => _SubmitPageState(
        deviceId,
        questionsList,
        this.dataListWithCookieName,
        cookieName,
        oldData,
      );
}

class _SubmitPageState extends State<SubmitPage> {
  final List oldData;
  final cookieName;
  final deviceId;
  final List questionsList;
  List dataListWithCookieName;
  _SubmitPageState(
    this.deviceId,
    this.questionsList,
    this.dataListWithCookieName,
    this.cookieName,
    this.oldData,
  );
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  final LocalStorage storage = new LocalStorage('ibdaa');

  final LocalStorage progressStorage = new LocalStorage('progress');
  final LocalStorage tripleName = new LocalStorage('tripleName');

  double newProgress;

  List answersData = [];
  _getLocalStorageData() async {
    var items = storage.getItem(deviceId);
    setState(() {
      answersData = items;
    });
  }

  _getAnswersResult() async {
    var resultVar =
        answersData.map((m) => m['answer_value']).reduce((a, b) => a + b);
    setState(() {
      result = double.parse(resultVar.toStringAsFixed(2));
    });
  }

  List dataResult = [];

  String resultString = '';

  _addResult(deviceId, stringResult, user_answers) async {
    final stringResult = '2';

    await tripleName.ready;
    String getTripleName = tripleName.getItem('tripleName');

    if (getTripleName != null) {
      await API.getTriple(getTripleName);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ResultPage(
                result: getTripleName,
              )));
    } else {
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
          _showDialog();
        }
      });
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('لقد قمت بإجراء الاختبار من قبل ',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.lightBlue,
              )),
          content: Text(' هل ترغب بعرض النتيجة أو الإعادة من جديد ؟ ',
              strutStyle: StrutStyle(
                fontSize: 14.0,
                height: 1,
              ),
              locale: Locale('ar'),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.lightBlue,
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            // ignore: deprecated_member_use
            new FlatButton(
              color: Colors.lightBlue,
              child: new Text(
                "الإعادة من جديد",
                strutStyle: StrutStyle(
                  fontSize: 14.0,
                  height: 1,
                ),
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await storage.ready;
                await progressStorage.ready;
                await tripleName.clear();

                storage.clear();
                progressStorage.clear();
                cookie.remove('id');
                tripleName.clear();

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => IntroPage()));
              },
            ),
            // ignore: deprecated_member_use
            new FlatButton(
              color: Colors.white,
              child: new Text(
                "عرض النتيجة",
                strutStyle: StrutStyle(
                  fontSize: 14.0,
                  height: 1,
                ),
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () async {
                await tripleName.ready;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ResultPage(
                          result: tripleName.getItem('tripleName'),
                        )));
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> itemsData = [];

  List questionsAnswers = [];

  List<Widget> listItems = [];
  double result;
  int newCurrentIndex;
  void getPostsData() {
    List<Widget> listItems = [];

    answersData.asMap().forEach((index, post) {
      listItems.add(InkWell(
        hoverColor: Colors.white,
        onTap: () {
          setState(() {
            newCurrentIndex = questionsList[index]['id'];
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  EditPage(deviceId, questionsList, oldData, newCurrentIndex)));
        },
        child: Container(
            height: 150,
            // width: 400,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.lightBlue, blurRadius: 10.0),
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " ${questionsList[index]['question_data']}",
                          strutStyle: StrutStyle(
                            fontSize: 20.0,
                            height: 1,
                          ),
                          style: questionStyleWeb,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_turned_in,
                              color: Colors.lightBlue,
                            ),
                            Text(
                              "  ${post["answers_text"]}",
                              style: answerStyleWeb,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    this._getLocalStorageData();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
    this._getAnswersResult();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
    this._questionWithAnswer();
    super.initState();
  }

  List questionWithAnswer = [];
  _questionWithAnswer() async {
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

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  ScrollController scrollController;
  bool dialVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Expanded(
        child: Scrollbar(
          isAlwaysShown: true,
          controller: controller,
          child: ListView.builder(
              controller: controller,
              itemCount: itemsData.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                double scale = 1.0;
                if (topContainer > 0.5) {
                  scale = index + 0.5 - topContainer;
                  if (scale < 0) {
                    scale = 0;
                  } else if (scale > 1) {
                    scale = 1;
                  }
                }
                return Opacity(
                  opacity: scale,
                  child: Transform(
                    transform: Matrix4.identity()..scale(scale, scale),
                    alignment: Alignment.bottomCenter,
                    child: Align(
                        heightFactor: 0.7,
                        alignment: Alignment.topCenter,
                        child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: itemsData[index])),
                  ),
                );
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            // ignore: deprecated_member_use
            child: RaisedButton.icon(
              textColor: Colors.white,
              color: Colors.lightBlue,
              shape: buttonStyle,
              onPressed: () async {
                final device_id = "$deviceId";
                final user_answers = '$questionWithAnswer';

                await _addResult(device_id, result, user_answers);
              },
              label: Text('إرسال'),
              icon: Icon(Icons.send),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            // ignore: deprecated_member_use
            child: RaisedButton.icon(
              shape: buttonStyle,
              textColor: Colors.lightBlue,
              color: Colors.white,
              onPressed: () async {
                newCurrentIndex = 1;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditPage(
                          deviceId,
                          questionsList,
                          oldData,
                          newCurrentIndex,
                        )));
              },
              icon: Icon(Icons.keyboard_return),
              label: Text('مراجعة الاجابات'),
            ),
          ),
        ],
      )
    ])));
  }
}
