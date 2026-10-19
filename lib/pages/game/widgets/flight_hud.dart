import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/pages/game/widgets/result_banner.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/widgets/machine/outlined_text.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlightHud extends StatelessWidget {
  const FlightHud({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RoundBloc>().state;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: switch (state.phase) {
        RoundPhase.ready => const Align(alignment: Alignment.topLeft, child: Tag(AppTexts.ready)),
        RoundPhase.countdown => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Tag(AppTexts.takeOffIn),
              const SizedBox(height: AppSpacing.sm),
              OutlinedText('${state.secondsLeft}', style: AppStyles.figureXL, width: 8, shadows: AppShadows.text),
            ],
          ),
        ),
        _ => Stack(
          children: [
            Align(alignment: Alignment.topLeft, child: _liveMultiplier(state)),
            if (state.result != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: ResultBanner(key: ValueKey(state.result), result: state.result!),
              ),
          ],
        ),
      },
    );
  }

  Widget _liveMultiplier(RoundState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _phaseTag(state.phase),
        const SizedBox(height: AppSpacing.xs),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: OutlinedText(
            Coins.formatMultiplier(state.multiplier),
            style: AppStyles.figureXL,
            fill: _multiplierColor(state.phase),
            width: 8,
            shadows: AppShadows.text,
          ),
        ),
      ],
    );
  }

  Widget _phaseTag(RoundPhase phase) => switch (phase) {
    RoundPhase.cashedOut => const Tag(AppTexts.jumped, color: AppColors.positive),
    RoundPhase.crashed => const Tag(AppTexts.flewAway, color: AppColors.negative),
    _ => const Tag(AppTexts.flying),
  };

  Color _multiplierColor(RoundPhase phase) => switch (phase) {
    RoundPhase.cashedOut => AppColors.positive,
    RoundPhase.crashed => AppColors.negative,
    _ => AppColors.figure,
  };
}
