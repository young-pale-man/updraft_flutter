import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/round_periods.dart';
import 'package:updraft_flutter/widgets/machine/screen_panel.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:flutter/widgets.dart';

class DayPanel extends StatelessWidget {
  const DayPanel({super.key, required this.day, required this.now});

  final RoundDay day;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tag(RoundDays.label(day.date, now)),
        const SizedBox(height: AppSpacing.sm),
        ScreenPanel(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          child: Column(
            children: [
              for (final (index, round) in day.rounds.indexed) ...[
                if (index > 0)
                  const ColoredBox(
                    color: AppColors.screenLine,
                    child: SizedBox(height: 1, width: double.infinity),
                  ),
                _RoundRow(round: round),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundRow extends StatelessWidget {
  const _RoundRow({required this.round});

  final RoundRecord round;

  @override
  Widget build(BuildContext context) {
    final (outcome, color) = switch (round.outcome) {
      RoundOutcome.jumped => (AppTexts.jumped, AppColors.positive),
      RoundOutcome.flewAway => (AppTexts.flewAway, AppColors.negative),
      RoundOutcome.left => (AppTexts.leave, AppColors.textMuted),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(RoundDays.time(round.time), style: AppStyles.caption.copyWith(color: AppColors.textMuted)),
                Text(outcome, style: AppStyles.tag.copyWith(color: color)),
              ],
            ),
          ),
          Expanded(
            child: Text(
              Coins.formatMultiplier(round.multiplier),
              style: AppStyles.figureS.copyWith(color: AppColors.figure),
            ),
          ),
          Text(Coins.formatChange(round.change), style: AppStyles.figureS.copyWith(color: color)),
        ],
      ),
    );
  }
}
