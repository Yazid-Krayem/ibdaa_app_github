import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/quizPage/quizPage.dart';
import 'package:uuid/uuid.dart';
import 'package:cooky/cooky.dart' as cookie;

import '../style.dart';

class StartQuizPage extends StatefulWidget {
  @override
  _StartQuizPageState createState() => _StartQuizPageState();
}

class _StartQuizPageState extends State<StartQuizPage> {
  String deviceid;
  String cookieName;
  final Storage _localStorage = window.localStorage;

  List oldData = ['empty'];

  _copyTheOldDataFromLocalStorage() async {
    var items = _localStorage['ibdaa'];

    if (items != null) {
      final decoding = json.decode(items);
      final getData = decoding['$deviceid'];

      if (getData == null) {
        setState(() {
          oldData = [];
        });
      } else if (getData == []) {
        setState(() {
          oldData = [];
        });
      } else if (getData == true) {
        setState(() {
          oldData = [];
        });
      } else {
        setState(() {
          oldData = getData;
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

  @override
  void initState() {
    super.initState();
    this._checkCookie();
    this._copyTheOldDataFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: RaisedButton(
            shape: buttonStyle,
            textColor: Colors.white,
            color: Colors.blue,
            child: Text('Start Quiz'),
            onPressed: () {
              Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        QuizPage(deviceid, cookieName, oldData),
                  ));
            }),
      ),
    );
  }
}
