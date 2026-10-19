import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/round_summary.dart';
import 'package:updraft_flutter/widgets/machine/readout.dart';
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
        Readout(label: AppTexts.balance, value: Coins.format(balance)),
        const Spacer(),
        Readout(
          label: AppTexts.bestJump,
          value: bestJump == null ? AppTexts.noJumpYet : Coins.formatMultiplier(bestJump),
          alignEnd: true,
        ),
      ],
    );
  }
}
