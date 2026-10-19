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

  static String percent(double fraction) => '${(fraction * 1000).round() / 10}%';

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
                child: Text(percent(CrashCurve.chanceToReach(target)), style: figure),
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  percent(CrashCurve.chanceToReach(target) * target / 100),
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
