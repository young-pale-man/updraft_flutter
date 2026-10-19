import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/widgets/machine/outlined_text.dart';
import 'package:flutter/widgets.dart';

class ResultBanner extends StatelessWidget {
  const ResultBanner({super.key, required this.result});

  final RoundRecord result;

  @override
  Widget build(BuildContext context) {
    final color = result.jumped ? AppColors.positive : AppColors.negative;
    final headline = result.jumped ? AppTexts.jumpedAt : AppTexts.flewAwayAt;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(AppRadii.slab),
          boxShadow: AppShadows.hard,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$headline ${Coins.formatMultiplier(result.multiplier)}',
                style: AppStyles.tag.copyWith(color: AppColors.accent),
              ),
              OutlinedText(Coins.formatChange(result.change), style: AppStyles.figureL, fill: color, width: 6),
            ],
          ),
        ),
      ),
    );
  }
}
