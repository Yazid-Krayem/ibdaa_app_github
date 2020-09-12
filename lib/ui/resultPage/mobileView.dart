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
    tripleDescription.sort();
    unviersitiesName.sort((a, b) => a.length.compareTo(b.length));

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              // triple university container
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: new BorderRadius.circular(25.0),
                      border: Border.all(color: Colors.lightBlue, width: 8)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'المجالات الدراسية /المهن الملائمة',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var item in unviersitiesName)
                        Text(
                          '$item\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        )
                    ]),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              //triple_name
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.white, width: 8)),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        'أنماط الميول المهنية',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue),
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
                    Column(
                      children: [
                        for (var detail in tripleDescription)
                          Text(
                            detail,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.lightBlue,
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              // triple url
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: new BorderRadius.circular(25.0),
                      border: Border.all(color: Colors.lightBlue, width: 8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        height: 10,
                      ),
                      for (var items in tripleUrl)
                        Link(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: "$items\n\n",
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
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
