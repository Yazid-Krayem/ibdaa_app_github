import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/startQuizPage/startQuizPage.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroPage> {
  static const _titles = <String>[
    "Covid-19 made us \nuneasy",
    "Focus on what is \nimportant for you",
    "Create a task and \nlet the bubbles pop",
  ];

  Timer _timer;
  int index = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (index < 2) {
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
    return Material(
      child: Stack(
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Text(
                _titles[index],
                key: ValueKey(_titles[index]),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          Positioned(
            bottom: 34,
            right: 34,
            child: FlatButton(
              onPressed: () {
                _timer.cancel();
                pushReplacementOverview();
              },
              child: Text(
                "Skip",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void pushReplacementOverview() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => StartQuizPage()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
