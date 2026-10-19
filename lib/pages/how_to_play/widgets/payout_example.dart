import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:flutter/widgets.dart';

class PayoutExample extends StatelessWidget {
  const PayoutExample({super.key, required this.entry, required this.multiplier});

  final int entry;
  final int multiplier;

  @override
  Widget build(BuildContext context) {
    final muted = AppStyles.bodyM.copyWith(color: AppColors.textMuted);
    final figure = AppStyles.figureS.copyWith(color: AppColors.figure);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Text(AppTexts.jumpingExample, style: muted),
          const SizedBox(width: AppSpacing.xs),
          Text(Coins.format(entry), style: figure),
          Text('${AppTexts.separator}${AppTexts.jumpingAt}', style: muted),
          const SizedBox(width: AppSpacing.xs),
          Text(Coins.formatMultiplier(multiplier), style: figure),
          const Spacer(),
          Text(
            Coins.format(Coins.payout(entry, multiplier)),
            style: AppStyles.figureS.copyWith(color: AppColors.positive),
          ),
        ],
      ),
    );
  }
}
