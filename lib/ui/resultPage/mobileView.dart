import 'package:flutter/material.dart';
import 'package:link/link.dart';

class MobileView extends StatelessWidget {
  const MobileView(
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              //triple_name
              Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: new BorderRadius.circular(25.0),
                      border: Border.all(color: Colors.blue, width: 8)),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'أنماط الميول المهنية',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Image.network(
                          '${snapshot.data.tripleImage}',
                          // height: 120,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "${snapshot.data.tripleName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              for (var detail in tripleDescription)
                                Text(
                                  detail,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                            ],
                          ))
                    ],
                  )),

              SizedBox(
                height: 20,
              ),

              // triple university container
              Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: new BorderRadius.circular(25.0),
                      border: Border.all(color: Colors.blue, width: 8)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(shrinkWrap: true, children: [
                      // unviersitiesName.sort((a, b) => a.length.compareTo(b.length)),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'المجالات الدراسية /المهن الملائمة',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var item in unviersitiesName)
                        Text(
                          '$item\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        )
                    ]),
                  )),
              SizedBox(
                height: 20,
              ),

              // triple url
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: new BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.blue, width: 8)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'مقالات تعريفية',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var items in tripleUrl)
                        Link(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: "- ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: "$items\n\n",
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
            ],
          ),
        ),
      ),
    );
  }
}
