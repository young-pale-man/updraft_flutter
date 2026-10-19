import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:flutter/cupertino.dart';

class CoefDisplay extends StatelessWidget {
  const CoefDisplay({super.key, required this.multiplier, required this.flewAway});

  final int multiplier;
  final bool flewAway;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Coins.formatMultiplier(multiplier),
          style: AppStyles.figureL.copyWith(color: flewAway ? AppColors.negative : AppColors.ink),
        ),
        Text(
          flewAway ? AppTexts.flewAway : AppTexts.currentCoefficient,
          style: AppStyles.caption.copyWith(color: AppColors.ink),
        ),
      ],
    );
  }
}
