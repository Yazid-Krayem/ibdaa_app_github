import 'package:flutter/material.dart';
import 'dart:ui';

final buttonStyle = new RoundedRectangleBorder(
  borderRadius: new BorderRadius.circular(30.0),
);

final questionStyle =
    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

final answerStyle = const TextStyle(
  fontSize: 18,
);

final outOfQuestionsTextStyle = const TextStyle(
    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red);

class AppColors {
  static const darkSlateGray = const Color(0xff252c4a);
  static const darkSlateBlue = const Color(0xff484e71);
  static const darkSlateGrayBorder = const Color(0xff204968);
  static const dodgerBlue = const Color(0xff2a85e3);
  static const tomato = const Color(0xfff4556d);
  static const purple = const Color(0xffb66ef6);
  static const green = const Color(0xff18da72);
}
