import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibdaa_app/models/triple.dart';
import 'package:ibdaa_app/ui/resultPage/mobileView.dart';
import 'package:ibdaa_app/ui/resultPage/webView.dart';

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
  final String result;

  Future<GetTriple> futureAlbum;

  // final url = 'https://ibdaa.herokuapp.com';
  final url = 'http://localhost:8000';

  Future<GetTriple> fetchAlbum() async {
    final response = await http.get('$url/triple/get/$result');

    if (response.statusCode == 200) {
      return GetTriple.fromJson(json.decode(response.body)['result']);
    } else {
      print(result);

      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load triple');
    }
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  // void _showErrorSnackBar() {
  //   Scaffold.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Oops... the URL couldn\'t be opened!'),
  //     ),
  //   );
  // }

  _ResultPageState(this.result);
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return SafeArea(child: ResponsiveWIdget(builder: (context, constraints) {
      return Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'نظرية هولاند في اختيار المهنة',
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
