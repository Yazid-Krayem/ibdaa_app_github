import 'package:flutter/material.dart';

class Linearprogress extends StatelessWidget {
  final double progress;

  const Linearprogress({Key key, this.progress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,

        //hard coded width
        width: MediaQuery.of(context).size.width * 0.5,
        child: Positioned(
            child: LinearProgressIndicator(
          backgroundColor: Colors.cyanAccent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
          value: progress,
        )));
  }
}
