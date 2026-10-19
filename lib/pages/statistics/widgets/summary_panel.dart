import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/round_summary.dart';
import 'package:updraft_flutter/widgets/machine/screen_panel.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:flutter/widgets.dart';

class SummaryPanel extends StatelessWidget {
  const SummaryPanel({super.key, required this.summary});

  final RoundSummary summary;

  @override
  Widget build(BuildContext context) {
    final change = summary.change;
    final best = summary.bestJump;
    return ScreenPanel(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _Figure(label: AppTexts.rounds, value: '${summary.rounds}'),
              ),
              Expanded(
                child: _Figure(label: AppTexts.jumpRate, value: '${summary.jumpRate}%'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _Figure(
                  label: AppTexts.bestJump,
                  value: best == null ? AppTexts.noJumpYet : Coins.formatMultiplier(best),
                ),
              ),
              Expanded(
                child: _Figure(
                  label: AppTexts.net,
                  value: Coins.formatChange(change),
                  color: change > 0
                      ? AppColors.positive
                      : change < 0
                      ? AppColors.negative
                      : AppColors.figure,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _JumpBar(jumps: summary.jumps, rounds: summary.rounds),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, this.color = AppColors.figure});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tag(label),
        const SizedBox(height: AppSpacing.xs),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: AppStyles.figureL.copyWith(color: color)),
        ),
      ],
    );
  }
}

class _JumpBar extends StatelessWidget {
  const _JumpBar({required this.jumps, required this.rounds});

  final int jumps;
  final int rounds;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.md + AppSizes.outline * 2,
      decoration: BoxDecoration(
        color: rounds == 0 ? AppColors.screenRaised : AppColors.negative,
        border: Border.all(color: AppColors.ink, width: AppSizes.outline),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: rounds == 0 ? 0 : jumps / rounds,
          child: const ColoredBox(color: AppColors.positive, child: SizedBox.expand()),
        ),
      ),
    );
  }
}
