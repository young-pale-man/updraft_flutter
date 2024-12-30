import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:flutter/cupertino.dart';

class CoefDisplay extends StatelessWidget {
  const CoefDisplay({
    super.key,
    required this.currentCoef,
    required this.coefDeadline,
  });

  final double currentCoef;
  final double coefDeadline;

  @override
  Widget build(BuildContext context) {
    final isMax = currentCoef >= coefDeadline;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${currentCoef.toStringAsFixed(1)}x',
          style: AppStyles.header.headerL.copyWith(
            color: isMax ? AppColors.system.negative : AppColors.text.primary,
          ),
        ),
        Text(
          isMax ? AppTexts.flewAway : AppTexts.currentCoefficient,
          style: AppStyles.caption.caption1.copyWith(color: AppColors.text.primary),
        )
      ],
    );
  }
}
