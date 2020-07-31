import 'package:flutter/material.dart';

const boldStyle = TextStyle(
  fontFamily: 'Hiragino Sans',
  locale: Locale('ja', 'JP'),
  fontWeight: FontWeight.w900,
);
const boldStyle1 = TextStyle(
  fontFamily: 'Hiragino Sans',
  locale: Locale('ja', 'JP'),
  fontWeight: FontWeight.w900,
  fontSize: 25
);
const yellowBoldText = TextStyle(
  fontSize: 22,
    locale: Locale('ja', 'JP'),
    fontWeight: FontWeight.w900,
    color: Colors.amberAccent);
const whiteText = TextStyle(fontSize: 14, color: Colors.white);

const style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

const bigWhiteText = TextStyle(fontSize: 20, color: Colors.white);
const inputTextLight = TextStyle(fontSize: 20, color: Colors.black26);


const shadowText  = TextStyle(
  color: Colors.yellow,
    shadows: [
        Shadow(
            blurRadius: 2.0,
            color: Colors.black,
            offset: Offset(0.0, 0.0),
            ),
        ],
    );