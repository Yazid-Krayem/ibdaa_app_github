import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibdaa_app/models/triple.dart';

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

  _ResultPageState(this.result);
  @override
  Widget build(BuildContext context) {
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
                List vas = snapshot.data.tripleUrl.split(',');
                return Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      // triple url
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (var items in vas)
                                Text(
                                  items,
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                )
                            ],
                          ),
                        ),
                      ),

                      Icon(
                        Icons.arrow_back,
                        size: 60,
                        color: Colors.blue,
                      ),

                      // triple university container
                      Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width / 3.5,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: new BorderRadius.circular(25.0),
                              border: Border.all(color: Colors.blue, width: 8)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  for (var item in vas)
                                    Text(
                                      item,
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.black),
                                    )
                                ]),
                          )),
                      Icon(
                        Icons.arrow_back,
                        size: 60,
                        color: Colors.blue,
                      ),
                      //triple_name
                      Container(
                          padding: EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width / 3.5,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: new BorderRadius.circular(25.0),
                              border: Border.all(color: Colors.blue, width: 8)),
                          child: Stack(
                            children: [
                              Text(
                                "${snapshot.data.tripleName}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              Center(
                                child: Image.network(
                                  snapshot.data.tripleImage,
                                  height: 120,
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
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
