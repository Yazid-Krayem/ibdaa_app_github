import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/introPage/introPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ibdaa',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: IntroPage(),
        ));
  }
}
