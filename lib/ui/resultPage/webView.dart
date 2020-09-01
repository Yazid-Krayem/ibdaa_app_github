import 'package:flutter/material.dart';
import 'package:link/link.dart';

class WebView extends StatelessWidget {
  const WebView(
      {Key key,
      @required this.tripleUrl,
      @required this.unviersitiesName,
      @required this.snapshot})
      : super(key: key);

  final List tripleUrl;
  final List unviersitiesName;
  final snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // triple url
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width / 3.5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var items in tripleUrl)
                    Link(
                      child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "-",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                              text: "$items\n\n\n",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontSize: 22,
                              ),
                            )
                          ])),

                      url: items,
                      // onError: _showErrorSnackBar,
                    ),
                ],
              ),
            ),
          ),

          Center(
            child: Icon(
              Icons.arrow_back,
              size: 60,
              color: Colors.blue,
            ),
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
                      for (var item in unviersitiesName)
                        Text(
                          item,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        )
                    ]),
              )),
          Center(
            child: Icon(
              Icons.arrow_back,
              size: 60,
              color: Colors.blue,
            ),
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
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "${snapshot.data.tripleName}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
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
  }
}
