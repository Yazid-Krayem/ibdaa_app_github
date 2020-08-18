import 'package:flutter/material.dart';
import 'package:ibdaa_app/ui/style.dart';

import 'baseCard.dart';

class ResultCard extends StatelessWidget {
  final bool isCorrect;
  final String titleLabel;

  const ResultCard({
    @required this.titleLabel,
    @required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      titleLabel: titleLabel,
      borderColor: isCorrect ? AppColors.green : AppColors.tomato,
      iconColor: isCorrect ? AppColors.green : AppColors.tomato,
      icon: isCorrect ? Icons.check : Icons.clear,
    );
  }
}
