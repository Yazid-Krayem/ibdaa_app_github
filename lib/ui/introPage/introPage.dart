import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/startQuizPage/startQuizPage.dart';
import 'package:ibdaa_app/ui/style.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroPage> {
  // Get questions From the server

  static const _titles = <String>[
    "النجاح ليس نهائيا أبدا. الفشل ليس قاتلا أبدا. الشجاعة هي التي تهم",
    "ركز على ما هو مهم بالنسبة لك",
    "لاشئ مستحيل. كلمة نفسها تقول أنا ممكن",
  ];

  Timer _timer;
  int index = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (index < 4) {
        setState(() {
          index++;
        });
      }

      if (index == _titles.length - 1) {
        _timer.cancel();
        pushReplacementOverview();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Material(
      child: Stack(
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: Duration(seconds: 6),
              child: Text(_titles[index],
                  strutStyle: StrutStyle(
                    fontSize: 18.0,
                    height: 1,
                  ),
                  maxLines: 4,
                  key: ValueKey(_titles[index]),
                  textAlign: TextAlign.center,
                  style: width < 500 ? introPageMobile : introPageWeb),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
              onPressed: () async {
                _timer.cancel();
                await pushReplacementOverview();
              },
              child: Text(
                "تخطى",
                strutStyle: StrutStyle(
                  fontSize: 16.0,
                  height: 1,
                ),
                style: TextStyle(color: Colors.lightBlue, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pushReplacementOverview() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => StartQuizPage()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
