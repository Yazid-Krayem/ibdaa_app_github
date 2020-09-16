import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/contactUs/ContactUs.dart';
import 'package:link/link.dart';

class WebView extends StatelessWidget {
  const WebView(
      {Key key,
      @required this.tripleUrl,
      @required this.unviersitiesName,
      @required this.tripleDescription,
      @required this.snapshot})
      : super(key: key);

  final List tripleUrl;
  final List unviersitiesName;
  final List tripleDescription;
  final snapshot;

  @override
  Widget build(BuildContext context) {
    tripleDescription.sort();
    unviersitiesName.sort((a, b) => a.length.compareTo(b.length));
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          // triple url
          Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width / 3.5,
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: new BorderRadius.circular(25.0),
                border: Border.all(color: Colors.lightBlue, width: 8)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'مقالات تعريفية',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  for (var items in tripleUrl)
                    if (items.contains('لا'))
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "$items\n\n\n",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            )
                          ]))
                    else
                      Link(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "$items\n\n\n",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
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
              color: Colors.lightBlue,
            ),
          ),

          //triple_name
          Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.lightBlue, width: 8)),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      'أنماط الميول المهنية',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image.network(
                    '${snapshot.data.tripleImage}',
                    height: 220,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          for (var detail in tripleDescription)
                            Text(
                              detail,
                              strutStyle: StrutStyle(
                                fontSize: 18.0,
                                height: 1,
                              ),
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Colors.lightBlue,
                              ),
                            )
                        ],
                      ))
                ],
              )),
          Center(
            child: Icon(
              Icons.arrow_back,
              size: 60,
              color: Colors.lightBlue,
            ),
          ),
          // triple university container
          Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: new BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.lightBlue, width: 8)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(shrinkWrap: true, children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      'المجالات الدراسية /المهن الملائمة',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  for (var item in unviersitiesName)
                    ListTile(
                        title: Text(
                      '$item\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ))
                ]),
              )),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
                child: Text('Contact US'),
                onPressed: () {
                  Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ContactUs()));
                }),
          )
        ],
      )
    ]);
  }
}
