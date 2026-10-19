import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:flutter/cupertino.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key, required this.timerValue});

  final int timerValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppTexts.newRoundStartsIn, style: AppStyles.bodyL.copyWith(color: AppColors.ink)),
        Text(timerValue.toString(), style: AppStyles.figureXL.copyWith(color: AppColors.ink)),
      ],
    );
  }
}
