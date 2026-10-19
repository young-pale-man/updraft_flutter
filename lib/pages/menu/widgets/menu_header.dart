import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/round_summary.dart';
import 'package:updraft_flutter/widgets/machine/outlined_text.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final balance = context.select((BalanceBloc bloc) => bloc.state.balance);
    final bestJump = context.select((StatisticsBloc bloc) => RoundSummary.of(bloc.state.rounds).bestJump);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Readout(label: AppTexts.balance, value: Coins.format(balance)),
        const Spacer(),
        _Readout(
          label: AppTexts.bestJump,
          value: bestJump == null ? AppTexts.noJumpYet : Coins.formatMultiplier(bestJump),
          end: true,
        ),
      ],
    );
  }
}

class _Readout extends StatelessWidget {
  const _Readout({required this.label, required this.value, this.end = false});

  final String label;
  final String value;
  final bool end;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Tag(label),
        const SizedBox(height: AppSpacing.xs),
        OutlinedText(value, style: AppStyles.figureM, width: 4, shadows: AppShadows.text),
      ],
    );
  }
}
