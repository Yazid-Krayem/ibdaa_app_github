import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonLabel;
  final Function onPressed;

  Button({@required this.buttonLabel, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ButtonTheme(
      minWidth: 120,
      height: width < 500 ? 40 : 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.lightBlue,
        // disabledColor: AppColors.darkSlateBlue,
        child: Text(
          buttonLabel,
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 15, color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
