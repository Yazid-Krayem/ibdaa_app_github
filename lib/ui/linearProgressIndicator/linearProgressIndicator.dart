import 'package:flutter/material.dart';

class Linearprogress extends StatelessWidget {
  static const _totalHeight = 20.0;
  static const _circularBorderRadius = 40.0;
  static const _borderWidth = 5.0;
  static const _fillContainerMargin = 5.0;

  final int currentIndex;
  final int totalNumberOfQuestions;

  const Linearprogress({
    @required this.currentIndex,
    @required this.totalNumberOfQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final outlineContainerHeight = _totalHeight;
    final outlineContainerWidth = MediaQuery.of(context).size.width * 0.4;
    final fillContainerHeight =
        outlineContainerHeight - 2 * _fillContainerMargin;
    final totalFillContainerWidth =
        outlineContainerWidth - 2 * _fillContainerMargin;
    final fillContainerWidth =
        totalFillContainerWidth * (currentIndex / totalNumberOfQuestions);

    return Stack(
      children: <Widget>[
        Container(
          height: fillContainerHeight,
          width: fillContainerWidth,
          margin: EdgeInsets.all(_fillContainerMargin),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_circularBorderRadius),
              color: Colors.lightBlue),
        ),
        Container(
          height: outlineContainerHeight,
          width: outlineContainerWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_circularBorderRadius),
            border: Border.all(
              width: _borderWidth,
              color: Colors.lightBlue,
            ),
          ),
        ),
      ],
    );
  }
}
