import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/introPage/introPage.dart';
import 'package:ibdaa_app/ui/submitPage/submitPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:cooky/cooky.dart' as cookie;

void alertStartQuiz(
    context, String deviceid, List questionsListTest, List oldData) {
  final LocalStorage storage = new LocalStorage('ibdaa');
  final progressStorage = LocalStorage('progress');
  final tripleName = LocalStorage('tripleName');
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

            // ignore: deprecated_member_use
            new FlatButton(
              color: Colors.white,
              child: new Text(
                "عرض النتيجة",
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () async {
                await tripleName.ready;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SubmitPage(
                          deviceId: deviceid,
                          cookieName: deviceid,
                          questionsList: questionsListTest,
                          oldData: oldData,
                          dataListWithCookieName: oldData,
                        )));
              },
            ),
            // ignore: deprecated_member_use
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
      });
}
