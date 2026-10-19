import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/pages/home/widgets/balance_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppbarContent extends StatelessWidget {
  const HomeAppbarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: BlocSelector<BalanceBloc, BalanceState, int>(
          selector: (state) => state.balance,
          builder: (context, balance) => BalanceBar(balance: balance),
        ),
      ),
    );
  }
}
