import 'package:flutter/material.dart';
import 'package:ibdaa_app/common/button.dart';
import 'package:ibdaa_app/ui/quizPage/quizPage.dart';
import 'package:ibdaa_app/ui/style.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';
import 'package:cooky/cooky.dart' as cookie;

class StartQuizPage extends StatefulWidget {
  @override
  _StartQuizPageState createState() => _StartQuizPageState();
}

class _StartQuizPageState extends State<StartQuizPage> {
  String deviceid;
  String cookieName;
  // Save and Delete data from Local Storage

  List oldData = ['empty'];
  List progress = [];

  final LocalStorage storage = new LocalStorage('ibdaa');
  final progressStorage = LocalStorage('progress');

  _copyTheOldDataFromLocalStorage() async {
    await storage.ready;
    final getIbdaaData = storage.getItem(deviceid);

    if (getIbdaaData != null) {
      if (getIbdaaData == null) {
        setState(() {
          oldData = [];
        });
      } else if (getIbdaaData == []) {
        setState(() {
          oldData = [];
        });
      } else if (getIbdaaData == true) {
        setState(() {
          oldData = [];
        });
      } else {
        setState(() {
          oldData = getIbdaaData;
        });
      }
    } else {
      setState(() {
        oldData = [];
      });
    }
  }

  _getDeviceId() {
    var uuid = Uuid();
    // Generate a v1 (time-based) id
    var v1 = uuid.v1();
    setState(() {
      deviceid = v1;
    });
    return v1;
  }

  _addCookie() {
    cookie.set('id', deviceid, maxAge: Duration(days: 3));
  }

  _checkCookie() async {
    var value = cookie.get('id');

    if (value != null) {
      setState(() {
        cookieName = value;
        deviceid = value;
      });
    } else {
      await _getDeviceId();
      await _addCookie();

      setState(() {
        cookieName = deviceid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this._checkCookie();
    this._copyTheOldDataFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    String webText = "اختبار تحديد الميول المهنية";
    // String mobileText = "اختبار تحديد \nالميول المهنية";
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('/images/intro.png'), fit: BoxFit.fill),
            ),
            child: Container(
                width: width,
                height: height,
                child: Row(
                  children: [
                    Container(
                      width: width * 0.65,
                      height: height / 2,
                    ),
                    Container(
                        width: width * 0.35,
                        height: height / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: Text(webText,
                                  style: width < 700
                                      ? startQuizPageTextMobile
                                      : startQuizPageTextWeb),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text('مبادرة إبدا',
                                style: width < 700
                                    ? startQuizPageTextMobile
                                    : startQuizPageTextWeb),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Button(
                                  buttonLabel: 'ابدأ الاختبار',
                                  onPressed: () {
                                    Navigator.push<bool>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              QuizPage(deviceid, cookieName,
                                                  oldData),
                                        ));
                                  }),
                            ),
                          ],
                        ))
                  ],
                ))

            // Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Container(
            //         width: MediaQuery.of(context).size.width / 2,
            //         child: Text('data'),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(20.0),
            //         child: Container(
            //             width: MediaQuery.of(context).size.width / 2,
            //             child: Row(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Padding(
            //                   padding: const EdgeInsets.all(20.0),
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Align(
            //                         alignment: Alignment.center,
            //                         child: RichText(
            //                             textDirection: TextDirection.rtl,
            //                             text: TextSpan(children: [
            //                               TextSpan(
            //                                   text: "$webText \n\n",
            //                                   style: width < 700
            //                                       ? startQuizPageTextMobile
            //                                       : startQuizPageTextWeb),
            //                               TextSpan(
            //                                   text: 'مبادرة إبدا',
            //                                   style: width < 700
            //                                       ? startQuizPageTextMobile
            //                                       : startQuizPageTextWeb),
            //                             ])),
            //                       ),
            //                       SizedBox(
            //                         height: 40,
            //                       ),
            //                       Container(
            //                         child: Button(
            //                             buttonLabel: 'ابدأ الاختبار',
            //                             onPressed: () {
            //                               Navigator.push<bool>(
            //                                   context,
            //                                   MaterialPageRoute(
            //                                     builder:
            //                                         (BuildContext context) =>
            //                                             QuizPage(
            //                                                 deviceid,
            //                                                 cookieName,
            //                                                 oldData),
            //                                   ));
            //                             }),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             )),
            //       ),
            //     ])

            ),
      ),
    );
  }
}
