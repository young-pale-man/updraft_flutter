import 'package:updraft_flutter/data/models/refill_record.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
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
        for (final (index, segment) in _segments(day.entries).indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          switch (segment) {
            [RefillEntry(:final refill)] => RefillBanner(refill: refill),
            _ => _RoundsPanel(rounds: [for (final entry in segment) (entry as RoundEntry).round]),
          },
        ],
      ],
    );
  }
}

List<List<DayEntry>> _segments(List<DayEntry> entries) {
  final segments = <List<DayEntry>>[];
  for (final entry in entries) {
    if (entry is RoundEntry && segments.isNotEmpty && segments.last.first is RoundEntry) {
      segments.last.add(entry);
    } else {
      segments.add([entry]);
    }
  }
  return segments;
}

class _RoundsPanel extends StatelessWidget {
  const _RoundsPanel({required this.rounds});

  final List<RoundRecord> rounds;

  @override
  Widget build(BuildContext context) {
    return ScreenPanel(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: Column(
        children: [
          for (final (index, round) in rounds.indexed) ...[
            if (index > 0)
              const ColoredBox(
                color: AppColors.screenLine,
                child: SizedBox(height: 1, width: double.infinity),
              ),
            _RoundRow(round: round),
          ],
        ],
      ),
    );
  }
}

class RefillBanner extends StatelessWidget {
  const RefillBanner({super.key, required this.refill});

  final RefillRecord refill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.positive,
        borderRadius: BorderRadius.circular(AppRadii.screen),
        border: Border.all(color: AppColors.ink, width: AppSizes.outline),
        boxShadow: AppShadows.hard,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(RoundDays.time(refill.time), style: AppStyles.caption.copyWith(color: AppColors.ink)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(AppTexts.balanceRefilled, style: AppStyles.titleM.copyWith(color: AppColors.ink)),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(Coins.formatChange(refill.amount), style: AppStyles.figureM.copyWith(color: AppColors.ink)),
        ],
      ),
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
