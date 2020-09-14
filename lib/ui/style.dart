import 'package:flutter/material.dart';
import 'dart:ui';

final buttonStyle = new RoundedRectangleBorder(
    borderRadius: new BorderRadius.circular(30.0),
    side: BorderSide(color: Colors.lightBlue, width: 2));

final questionStyleWeb = const TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightBlue);
final questionStyleMobile = const TextStyle(
    fontSize: 14, fontWeight: FontWeight.bold, color: Colors.lightBlue);

final answerStyleWeb = const TextStyle(fontSize: 18, color: Colors.lightBlue);
final answerStyleMobile =
    const TextStyle(fontSize: 12, color: Colors.lightBlue);

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
    fontSize: 22.5, color: Colors.white, fontWeight: FontWeight.bold);
final mobileQuestionsFont = const TextStyle(
    fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);

final mainQuestionWeb = const TextStyle(fontSize: 15, color: Colors.white);
final mainQuestionMobile = const TextStyle(fontSize: 10, color: Colors.white);

final webAnswersFont = const TextStyle(
  fontSize: 25,
  color: Colors.lightBlue,
);

final startQuizPageTextWeb = const TextStyle(
    fontSize: 30, color: Colors.lightBlue, fontWeight: FontWeight.bold);

final startQuizPageTextMobile = const TextStyle(
    fontSize: 18, color: Colors.lightBlue, fontWeight: FontWeight.bold);

///intro Page
///
///

final introPageMobile = const TextStyle(
  color: Colors.lightBlue,
  fontSize: 18,
);
final introPageWeb = const TextStyle(
  color: Colors.lightBlue,
  fontSize: 24,
);
