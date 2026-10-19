import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/balance_rules.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/widgets/machine/action_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoundActionButton extends StatelessWidget {
  const RoundActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RoundBloc>().state;
    final balance = context.select((BalanceBloc bloc) => bloc.state.balance);
    final round = context.read<RoundBloc>();
    if (state.paused) {
      return ActionButton(title: AppTexts.resume, onPressed: () => round.add(const RoundResumed()));
    }
    return switch (state.phase) {
      RoundPhase.ready => ActionButton(
        title: AppTexts.play,
        detail: Coins.format(state.entry),
        onPressed: () => round.add(const PlayPressed()),
        enabled: BalanceRules.canEnter(balance: balance, entry: state.entry),
      ),
      RoundPhase.countdown => ActionButton(
        title: AppTexts.cancel,
        onPressed: () => round.add(const CountdownCancelled()),
      ),
      RoundPhase.flying => ActionButton(
        title: AppTexts.jump,
        detail: Coins.format(state.livePayout),
        onPressed: () => round.add(const JumpPressed()),
      ),
      _ => const ActionButton(title: AppTexts.jump, enabled: false),
    };
  }
}
