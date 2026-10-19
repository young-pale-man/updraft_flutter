import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/pages/game/widgets/machine_switch.dart';
import 'package:updraft_flutter/pages/game/widgets/round_action_button.dart';
import 'package:updraft_flutter/pages/game/widgets/stepper_slot.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/balance_rules.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/round_rules.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlDeck extends StatelessWidget {
  const ControlDeck({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EntryControl(),
              SizedBox(height: AppSpacing.md),
              _AutoJumpControl(),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.lg),
        RoundActionButton(),
      ],
    );
  }
}

class _EntryControl extends StatelessWidget {
  const _EntryControl();

  @override
  Widget build(BuildContext context) {
    final round = context.read<RoundBloc>();
    final entry = context.select((RoundBloc bloc) => bloc.state.entry);
    final ready = context.select((RoundBloc bloc) => bloc.state.isReady);
    final balance = context.select((BalanceBloc bloc) => bloc.state.balance);
    final ceiling = BalanceRules.clampEntry(entry: BalanceRules.maxEntry, balance: balance);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Tag(AppTexts.entry),
        const SizedBox(height: AppSpacing.xs + 2),
        StepperSlot(
          value: Coins.format(entry),
          lowerLabel: AppTexts.lowerEntry,
          raiseLabel: AppTexts.raiseEntry,
          onLower: () => round.add(EntryChanged(round.state.entry - RoundRules.entryStep)),
          onRaise: () => round.add(EntryChanged(round.state.entry + RoundRules.entryStep)),
          canLower: entry > BalanceRules.minEntry,
          canRaise: entry < ceiling,
          enabled: ready,
        ),
      ],
    );
  }
}

class _AutoJumpControl extends StatelessWidget {
  const _AutoJumpControl();

  @override
  Widget build(BuildContext context) {
    final round = context.read<RoundBloc>();
    final target = context.select((RoundBloc bloc) => bloc.state.target);
    final autoJump = context.select((RoundBloc bloc) => bloc.state.autoJump);
    final ready = context.select((RoundBloc bloc) => bloc.state.isReady);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Tag(AppTexts.autoJump),
            const Spacer(),
            MachineSwitch(
              value: autoJump,
              label: AppTexts.autoJump,
              enabled: ready,
              onChanged: (value) => round.add(AutoJumpChanged(value)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        StepperSlot(
          value: Coins.formatMultiplier(target),
          lowerLabel: AppTexts.lowerTarget,
          raiseLabel: AppTexts.raiseTarget,
          onLower: () => round.add(TargetChanged(RoundRules.stepTarget(round.state.target, up: false))),
          onRaise: () => round.add(TargetChanged(RoundRules.stepTarget(round.state.target, up: true))),
          canLower: target > RoundRules.minTarget,
          canRaise: target < RoundRules.maxTarget,
          enabled: ready && autoJump,
        ),
      ],
    );
  }
}
