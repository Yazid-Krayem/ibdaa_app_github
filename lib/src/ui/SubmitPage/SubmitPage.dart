import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ibdaa_app/src/Models/answersList.dart';
import 'package:localstorage/localstorage.dart';

// ignore: must_be_immutable
class SubmitPage extends StatefulWidget {
  final deviceId;
  SubmitPage(this.deviceId);

  @override
  _SubmitPageState createState() => _SubmitPageState(deviceId);
}

class _SubmitPageState extends State<SubmitPage> {
  final deviceId;

  final LocalStorage storage = new LocalStorage('ibdaa');

  final AnswersList list1 = new AnswersList();

  bool initialized = false;

  _SubmitPageState(this.deviceId);

  @override
  Widget build(BuildContext context) {
    // _getItemsFromLocalStorage();
    //  ITEMS holds the answer's of the user
    var items = storage.getItem(deviceId);
    String jsonString = jsonEncode(items); // encode map to json

    List<int> data = utf8.encode(jsonString);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Submit'),
        ),
        body: Column(
          children: [
            // for (var item in items) Center(child: questionsList(item)),
            new Expanded(
                child: new ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return new Text(items[index]['answers_text']);
              },
            )),

            Container(
              child: RaisedButton(
                onPressed: () {},
                child: Text('Submit'),
              ),
            ),
          ],
        ));
  }
}
