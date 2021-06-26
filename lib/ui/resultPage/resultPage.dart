import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibdaa_app/models/api.dart';
import 'package:ibdaa_app/models/fetchingData.dart';
import 'package:ibdaa_app/models/triple.dart';
import 'package:ibdaa_app/ui/resultPage/mobileView.dart';
import 'package:ibdaa_app/ui/resultPage/webView.dart';
import 'package:localstorage/localstorage.dart';
import '../responsiveWIdget.dart';

class ResultPage extends StatefulWidget {
  final String result;
  const ResultPage({
    Key key,
    @required this.result,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState(result);
}

class _ResultPageState extends State<ResultPage> {
  final LocalStorage storage = new LocalStorage('ibdaa');

  final LocalStorage progressStorage = new LocalStorage('progress');
  final LocalStorage logId = new LocalStorage('logId');
  final String result;
  int endQuizId;

  _addLog() async {
    await logId.ready;

    var getlogId = logId.getItem('logId');
    await API.updateLog(getlogId).then((response) {
      var result = jsonDecode(response.body);

      if (result['success']) {
        // print('ok');
      } else {
        // print('error');
      }
    });
  }

  Future<GetTriple> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(result, context);
    this._addLog();
  }

  _ResultPageState(this.result);
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return SafeArea(child: ResponsiveWIdget(builder: (context, constraints) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'نتيجة اختبار تحديد الميول ',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.lightBlue,
          ),
          body: FutureBuilder<GetTriple>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List tripleUrl = snapshot.data.tripleUrl.split(',');
                List<String> unviersitiesName =
                    snapshot.data.universityName.split('،');

                List tripleDescription =
                    snapshot.data.tripleDescription.split(',');

                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (orientation == Orientation.portrait ||
                        constraints.maxWidth < 800) {
                      return MobileView(
                        tripleUrl: tripleUrl,
                        unviersitiesName: unviersitiesName,
                        tripleDescription: tripleDescription,
                        snapshot: snapshot,
                      );
                    } else {
                      return WebView(
                        tripleUrl: tripleUrl,
                        unviersitiesName: unviersitiesName,
                        tripleDescription: tripleDescription,
                        snapshot: snapshot,
                      );
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          ));
    }));
  }
}
