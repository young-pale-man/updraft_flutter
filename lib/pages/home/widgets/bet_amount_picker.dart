import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/pages/home/widgets/value_picker.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/balance_rules.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/round_rules.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BetAmountPicker extends StatelessWidget {
  const BetAmountPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final entry = context.select((RoundBloc bloc) => bloc.state.entry);
    final disabled = context.select((RoundBloc bloc) => !bloc.state.isReady);
    final balance = context.select((BalanceBloc bloc) => bloc.state.balance);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppTexts.roundEntry, style: AppStyles.body.body1.copyWith(color: AppColors.text.primary)),
        const SizedBox(height: 17),
        ValuePicker(
          value: entry,
          minValue: BalanceRules.minEntry,
          maxValue: BalanceRules.clampEntry(entry: BalanceRules.maxEntry, balance: balance),
          step: RoundRules.entryStep,
          format: Coins.format,
          onChanged: (value) => context.read<RoundBloc>().add(EntryChanged(value)),
          disabled: disabled,
        ),
      ],
    );
  }
}
