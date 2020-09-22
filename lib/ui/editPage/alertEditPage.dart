import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/introPage/introPage.dart';
import 'package:ibdaa_app/ui/resultPage/resultPage.dart';
import 'package:cooky/cooky.dart' as cookie;
import 'package:localstorage/localstorage.dart';

void alertEditPage(context) {
  final LocalStorage tripleName = new LocalStorage('tripleName');
  final LocalStorage storage = new LocalStorage('ibdaa');
  final LocalStorage progressStorage = new LocalStorage('progress');
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
                  builder: (context) => ResultPage(
                        result: tripleName.getItem('tripleName'),
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
