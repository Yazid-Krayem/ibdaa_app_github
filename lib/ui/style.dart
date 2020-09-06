import 'package:flutter/material.dart';
import 'dart:ui';

final buttonStyle = new RoundedRectangleBorder(
  borderRadius: new BorderRadius.circular(30.0),
);

final questionStyle = const TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

final answerStyle = const TextStyle(fontSize: 18, color: Colors.black);

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

final webQuestionsFont = const TextStyle(
    fontSize: 23, color: Colors.black, fontWeight: FontWeight.bold);
final mobileQuestionsFont = const TextStyle(
    fontSize: 19, color: Colors.black, fontWeight: FontWeight.bold);

final mainQuestionWeb = const TextStyle(fontSize: 20, color: Colors.red);
final mainQuestionMobile = const TextStyle(fontSize: 16, color: Colors.red);

final webAnswersFont = const TextStyle(
  fontSize: 25,
  color: Colors.black,
);

final startQuizPageTextWeb = const TextStyle(
    fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold);

final startQuizPageTextMobile = const TextStyle(
    fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold);
