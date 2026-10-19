import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/crash_curve.dart';
import 'package:flutter/widgets.dart';

class FairnessTable extends StatelessWidget {
  const FairnessTable({super.key, required this.targets});

  final List<int> targets;

  @override
  Widget build(BuildContext context) {
    final header = AppStyles.tag.copyWith(color: AppColors.accent);
    final figure = AppStyles.figureS.copyWith(color: AppColors.figure);
    return Table(
      columnWidths: const {0: FlexColumnWidth(), 1: FlexColumnWidth(), 2: IntrinsicColumnWidth()},
      children: [
        TableRow(
          children: [
            Text(AppTexts.target, style: header),
            Text(AppTexts.chance, style: header),
            Text(AppTexts.returns, style: header, textAlign: TextAlign.end),
          ],
        ),
        for (final target in targets)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(Coins.formatMultiplier(target), style: figure),
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(Coins.formatPercent(CrashCurve.chanceToReach(target), decimals: 1), style: figure),
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  Coins.formatPercent(CrashCurve.chanceToReach(target) * target / 100, decimals: 1),
                  style: figure.copyWith(color: AppColors.positive),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
