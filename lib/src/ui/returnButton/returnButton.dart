import 'package:flutter/material.dart';

class ReturnButton extends StatelessWidget {
  final returnButtonFunction;

  ReturnButton(this.returnButtonFunction);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      alignment: Alignment.topRight,
      child: RaisedButton.icon(
        hoverColor: Colors.black,
        onPressed: () => {returnButtonFunction()},
        icon: Icon(Icons.arrow_back),
        textColor: Colors.white,
        color: Colors.lightBlue,
        label: Text('عودة'),
      ),
    );
  }
}
