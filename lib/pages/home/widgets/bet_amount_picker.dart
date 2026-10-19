import 'package:updraft_flutter/pages/home/widgets/value_picker.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class BetAmountPicker extends StatelessWidget {
  const BetAmountPicker({super.key, required this.betAmount, required this.disabled});

  final ValueNotifier<double> betAmount;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: Text(AppTexts.roundEntry, style: AppStyles.body.body1.copyWith(color: AppColors.text.primary)),
        ),
        const SizedBox(height: 17),
        ValuePicker(
          valueListenable: betAmount,
          minValue: AppConst.minBetAmount,
          maxValue: AppConst.maxBetAmount,
          disabled: disabled,
        ),
      ],
    );
  }
}
