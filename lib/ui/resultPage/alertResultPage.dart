import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/introPage/introPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:cooky/cooky.dart' as cookie;

void showDialogResultPage(BuildContext context) {
  final LocalStorage storage = new LocalStorage('ibdaa');
  final LocalStorage triple = new LocalStorage('tripleName');

  final LocalStorage progressStorage = new LocalStorage('progress');
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "الفرع المناسب غير موجود في الجامعات السورية",
          strutStyle: StrutStyle(
            fontSize: 14.0,
            height: 1,
          ),
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.lightBlue),
        ),
        content: Text(
          'يرجى اعادة الاختبار والتركيز اكثر عند الإجابة للحصول على نتيجة دقيقة',
          strutStyle: StrutStyle(
            fontSize: 14.0,
            height: 1,
          ),
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.lightBlue),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          Center(
            // ignore: deprecated_member_use
            child: new FlatButton(
              child: new Text(
                "اعادة الاختبار ",
                strutStyle: StrutStyle(
                  fontSize: 14.0,
                  height: 1,
                ),
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlue,
              onPressed: () async {
                await storage.ready;
                await progressStorage.ready;
                await triple.ready;

                triple.clear();
                storage.clear();
                progressStorage.clear();
                cookie.remove('id');

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => IntroPage()));
              },
            ),
          ),
        ],
      );
    },
  );
}
