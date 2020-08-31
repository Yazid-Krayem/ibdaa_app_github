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

  final url = 'https://ibdaa.herokuapp.com';

  Future<GetTriple> fetchAlbum() async {
    final response = await http.get('$url/triple/get/$result');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GetTriple.fromJson(json.decode(response.body)['result']);
    } else {
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

  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }

  _ResultPageState(this.result);
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return SafeArea(child: ResponsiveWIdget(builder: (context, constraints) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('النتيجة'),
            backgroundColor: Colors.blue,
          ),
          body: FutureBuilder<GetTriple>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List tripleUrl = snapshot.data.tripleUrl.split(',');
                List unviersitiesName = snapshot.data.universityName.split(',');
                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (orientation == Orientation.portrait ||
                        constraints.maxHeight < 650 ||
                        constraints.maxWidth < 800) {
                      return MobileView(
                        tripleUrl: tripleUrl,
                        unviersitiesName: unviersitiesName,
                        snapshot: snapshot,
                      );
                    } else {
                      return MobileView(
                        tripleUrl: tripleUrl,
                        unviersitiesName: unviersitiesName,
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
