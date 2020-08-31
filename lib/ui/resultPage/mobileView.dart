import 'package:flutter/material.dart';
import 'package:link/link.dart';

class MobileView extends StatelessWidget {
  const MobileView(
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  for (var items in tripleUrl)
                    Link(
                      child: Text(
                        items,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 22),
                      ),
                      url: items,
                      // onError: _showErrorSnackBar,
                    ),
                ],
              ),
            ),
          ),

          // Center(
          //   child: Icon(
          //     Icons.arrow_back,
          //     size: 60,
          //     color: Colors.blue,
          //   ),
          // ),

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
          // Center(
          //   child: Icon(
          //     Icons.arrow_back,
          //     size: 60,
          //     color: Colors.blue,
          //   ),
          // ),
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
