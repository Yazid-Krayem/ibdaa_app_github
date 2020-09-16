import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibdaa_app/common/button.dart';
import 'package:ibdaa_app/models/api.dart';
import 'package:ibdaa_app/ui/introPage/introPage.dart';
import 'package:ibdaa_app/ui/quizPage/quizPage.dart';
import 'package:ibdaa_app/ui/style.dart';
import 'package:ibdaa_app/ui/submitPage/submitPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';
import 'package:cooky/cooky.dart' as cookie;
import 'package:http/http.dart' as http;

class StartQuizPage extends StatefulWidget {
  @override
  _StartQuizPageState createState() => _StartQuizPageState();
}

class _StartQuizPageState extends State<StartQuizPage> {
  String deviceid;
  String cookieName;
  // Save and Delete data from Local Storage

  List oldData = ['empty'];
  List progress = [];

  final LocalStorage storage = new LocalStorage('ibdaa');
  final progressStorage = LocalStorage('progress');
  final tripleName = LocalStorage('tripleName');
  final logId = LocalStorage('logId');

  _copyTheOldDataFromLocalStorage() async {
    await storage.ready;
    final getIbdaaData = storage.getItem(deviceid);

    if (getIbdaaData != null) {
      if (getIbdaaData == null) {
        setState(() {
          oldData = [];
        });
      } else if (getIbdaaData == []) {
        setState(() {
          oldData = [];
        });
      } else if (getIbdaaData == true) {
        setState(() {
          oldData = [];
        });
      } else {
        setState(() {
          oldData = getIbdaaData;
        });
      }
    } else {
      setState(() {
        oldData = [];
      });
    }
  }

  _getDeviceId() {
    var uuid = Uuid();
    // Generate a v1 (time-based) id
    var v1 = uuid.v1();
    setState(() {
      deviceid = v1;
    });
    return v1;
  }

  _addCookie() {
    cookie.set('id', deviceid, maxAge: Duration(days: 3));
  }

  _checkCookie() async {
    var value = cookie.get('id');

    if (value != null) {
      setState(() {
        cookieName = value;
        deviceid = value;
      });
    } else {
      await _getDeviceId();
      await _addCookie();

      setState(() {
        cookieName = deviceid;
      });
    }
  }

  final url = 'https://ibdaa.herokuapp.com';
  // final url = 'http://localhost:8000';

  List questionsListTest = [];

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
      _load = !_load;
    });
    return json.decode(result.body)['result'];
  }

  //image
  final theImage = AssetImage(
    '/images/intro.png',
  );

  /// Did Change Dependencies
  @override
  void didChangeDependencies() {
    precacheImage(theImage, context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    this.fetchQuestions();
    this.fetchAnswers();
    this._checkCookie();
    this._copyTheOldDataFromLocalStorage();
  }

  bool _load = true;

  // add log function

  int startQuizId;
  _addLog() async {
    await API.createLog(deviceid).then((response) {
      var result = jsonDecode(response.body);
      print(result);
      print(deviceid);

      if (result['success']) {
        setState(() {
          startQuizId = result['result'];
        });
      } else {
        print('error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    String webText = "اختبار تحديد الميول المهنية";
    // String mobileText = "اختبار تحديد \nالميول المهنية";
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: theImage, fit: BoxFit.fill),
            ),
            child: Container(
                width: width,
                height: height,
                child: Row(
                  children: [
                    Container(
                      width: width * 0.65,
                      height: height / 2,
                    ),
                    Container(
                        width: width * 0.35,
                        height: height / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: Text(webText,
                                  strutStyle: StrutStyle(
                                    fontSize: 18.0,
                                    height: 1,
                                  ),
                                  style: width < 700
                                      ? startQuizPageTextMobile
                                      : startQuizPageTextWeb),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text('مبادرة إبدا',
                                style: width < 700
                                    ? startQuizPageTextMobile
                                    : startQuizPageTextWeb),
                            SizedBox(
                              height: 30,
                            ),
                            _load
                                ? CircularProgressIndicator()
                                : Container(
                                    child: Button(
                                        buttonLabel: 'ابدأ الاختبار',
                                        onPressed: () async {
                                          await tripleName.ready;
                                          String getTripleName =
                                              tripleName.getItem('tripleName');

                                          if (getTripleName != null) {
                                            _showDialog();
                                          } else {
                                            await Future.delayed(const Duration(
                                                milliseconds: 500));
                                            await logId.ready;

                                            var getLogId =
                                                logId.getItem('logId');
                                            if (getLogId == null) {
                                              await _addLog();

                                              logId.setItem(
                                                  'logId', startQuizId);
                                            }

                                            Navigator.push<bool>(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        QuizPage(
                                                            deviceid,
                                                            cookieName,
                                                            oldData,
                                                            questionsListTest,
                                                            answersList)));
                                          }
                                        }),
                                  ),
                          ],
                        ))
                  ],
                ))),
      ),
    );
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

            new FlatButton(
              color: Colors.white,
              child: new Text(
                "عرض النتيجة",
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () async {
                await tripleName.ready;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SubmitPage(
                          deviceId: deviceid,
                          cookieName: deviceid,
                          questionsList: questionsListTest,
                          progress: 33.3,
                          oldData: oldData,
                          dataListWithCookieName: oldData,
                        )));
              },
            ),
            new FlatButton(
              color: Colors.lightBlue,
              child: new Text(
                "الإعادة من جديد",
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
          ],
        );
      },
    );
  }
}
