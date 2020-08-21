import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ibdaa_app/models/api.dart';
import 'package:ibdaa_app/ui/quizPage/quizPage.dart';
import 'package:ibdaa_app/ui/style.dart';
import 'package:js_shims/js_shims.dart';
import 'package:localstorage/localstorage.dart';
import 'package:share/share.dart';
import 'package:cooky/cooky.dart' as cookie;

import '../../main.dart';

class SubmitPage extends StatefulWidget {
  final List oldData;
  final deviceId;
  final List questionsListTest;
  final List dataListWithCookieName;
  final String cookieName;
  final double progress;

  SubmitPage(
      {Key key,
      @required this.deviceId,
      @required this.questionsListTest,
      @required this.dataListWithCookieName,
      @required this.cookieName,
      @required this.oldData,
      @required this.progress})
      : super(key: key);

  @override
  _SubmitPageState createState() => _SubmitPageState(
      deviceId,
      questionsListTest,
      this.dataListWithCookieName,
      cookieName,
      oldData,
      progress);
}

class _SubmitPageState extends State<SubmitPage> {
  final List oldData;
  final double progress;
  final cookieName;
  final deviceId;
  final List questionsListTest;
  List dataListWithCookieName;
  _SubmitPageState(
      this.deviceId,
      this.questionsListTest,
      this.dataListWithCookieName,
      this.cookieName,
      this.oldData,
      this.progress);
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  final LocalStorage storage = new LocalStorage('ibdaa');

  final LocalStorage progressStorage = new LocalStorage('progress');

  double newProgress;

  List answersData = [];
  _getLocalStorageData() async {
    var items = storage.getItem(deviceId);
    setState(() {
      answersData = items;
    });
  }

  _getAnswersResult() async {
    var resultVar =
        answersData.map((m) => m['answer_value']).reduce((a, b) => a + b);
    setState(() {
      result = double.parse(resultVar.toStringAsFixed(2));
    });
  }

  List dataResult = [];

  _addResult(deviceId, stringResult, user_answers) async {
    final stringResult = result.toString();
    await API
        .usersAnswers(deviceId, stringResult, user_answers)
        .then((response) {
      // print('here ${json.decode(response.body.result)}');
      // print("${json.encode(response.body['result'])}");
    });
  }

  List<Widget> itemsData = [];

  List questionsAnswers = [];

  List<Widget> listItems = [];
  double result;
  void getPostsData() {
    List<Widget> listItems = [];

    answersData.asMap().forEach((index, post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        questionsListTest[index]['question_data'],
                        style: questionStyle,
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        post["answers_text"],
                        style: answerStyle,
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    this._getLocalStorageData();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
    this._getAnswersResult();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
    super.initState();
  }

//Alert
  void _showDialog() {
    // flutter defined function
    final device_id = "$deviceId";
    final user_answers = "$answersData";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: new Text("Mabrouk "),
          content: new Text("Your result is $result"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            Row(
              children: [
                new FlatButton(
                  child: new Text("Sahre it "),
                  onPressed: () async {
                    await _addResult(device_id, result, user_answers);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (Route<dynamic> route) => false);
                  },
                ),
                FlatButton(
                  child: new Text("Start over "),
                  onPressed: () async {
                    await storage.clear();
                    await progressStorage.clear();

                    cookie.remove('id');

                    setState(() {
                      dataListWithCookieName = [];
                    });

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void share(BuildContext context, result) {
    final String text = "Hey, my result is $result";
    Share.share(text, subject: "$result");
  }

  //speedDial Buttons

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  ScrollController scrollController;
  bool dialVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("نتيجة"),
          backgroundColor: Colors.brown[200],
        ),
        // floatingActionButton: buildSpeedDial(),
        body: SafeArea(
            child: Column(children: [
          Expanded(
              child: ListView.builder(
                  controller: controller,
                  itemCount: itemsData.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    double scale = 1.0;
                    if (topContainer > 0.5) {
                      scale = index + 0.5 - topContainer;
                      if (scale < 0) {
                        scale = 0;
                      } else if (scale > 1) {
                        scale = 1;
                      }
                    }
                    return Opacity(
                      opacity: scale,
                      child: Transform(
                        transform: Matrix4.identity()..scale(scale, scale),
                        alignment: Alignment.bottomCenter,
                        child: Align(
                            heightFactor: 0.7,
                            alignment: Alignment.topCenter,
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: itemsData[index])),
                      ),
                    );
                  })),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton.icon(
                  shape: buttonStyle,
                  color: Colors.blue,
                  onPressed: () async {
                    await storage.ready;
                    await progressStorage.ready;

                    setState(() {
                      newProgress = progress - 0.33;
                    });

                    progressStorage.setItem('progress', newProgress);

                    List removeItemFromLocalStorageList = [];
                    var getData = storage.getItem(deviceId);

                    setState(() {
                      removeItemFromLocalStorageList = getData;
                      removeItemFromLocalStorageList = dataListWithCookieName;
                    });

                    // int deleteCurrentIndex = currentIndex - 1;
                    await pop(removeItemFromLocalStorageList);

                    await storage.deleteItem('ibdaa');
                    storage.setItem(
                        "$cookieName", removeItemFromLocalStorageList);
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            QuizPage(deviceId, cookieName, oldData)));

                    // _decrementCurrentIndex();
                  },
                  label: Text('تعديل'),
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton.icon(
                  shape: buttonStyle,
                  color: Colors.green,
                  onPressed: () async {
                    _showDialog();

                    // await _addResult(deviceId, result, answersData);
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => MyApp()),
                    //     (Route<dynamic> route) => false);
                  },
                  label: Text('إرسال'),
                  icon: Icon(Icons.send),
                ),
              ),
            ],
          )
        ])));
  }

  // SpeedDial buildSpeedDial() {
  //   return SpeedDial(
  //     animatedIcon: AnimatedIcons.menu_arrow,
  //     animatedIconTheme: IconThemeData(size: 22.0),
  //     // child: Icon(Icons.add),
  //     // onOpen: () => print('OPENING DIAL'),
  //     // onClose: () => print('DIAL CLOSED'),
  //     visible: dialVisible,
  //     curve: Curves.bounceIn,
  //     children: [
  //       SpeedDialChild(
  //         child: Icon(Icons.save, color: Colors.white),
  //         backgroundColor: Colors.deepOrange,
  //         onTap: () => _showDialog(),
  //         label: 'Submit',
  //         labelStyle: TextStyle(fontWeight: FontWeight.w500),
  //         labelBackgroundColor: Colors.deepOrangeAccent,
  //       ),
  //       SpeedDialChild(
  //         child: Icon(Icons.share, color: Colors.white),
  //         backgroundColor: Colors.green,
  //         onTap: () {
  //           Share.share('check out my website https://example.com',
  //               subject: 'Look what I made!');

  //           // share(context, result);
  //         },
  //         label: 'Share',
  //         labelStyle: TextStyle(fontWeight: FontWeight.w500),
  //         labelBackgroundColor: Colors.green,
  //       ),
  //     ],
  //   );
  // }
}
