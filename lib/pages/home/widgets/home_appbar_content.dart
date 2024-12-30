import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/pages/home/widgets/balance_bar.dart';
import 'package:updraft_flutter/pages/home/widgets/balance_increased_snackbar.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppbarContent extends StatefulWidget {
  const HomeAppbarContent({super.key});

  @override
  State<HomeAppbarContent> createState() => _HomeAppbarContentState();
}

class _HomeAppbarContentState extends State<HomeAppbarContent> {
  bool _balanceIncreased = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: BlocConsumer<BalanceBloc, BalanceState>(
                listener: (context, state) {
                  if (state.addedDifference > 0) {
                    _showBalanceIncreasedSnackbar();
                  }
                },
                builder: (context, state) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      BalanceBar(
                        balance: state.balance,
                      ),
                      if (_balanceIncreased)
                        Positioned(
                          bottom: scaledSize(35),
                          right: 16,
                          child: BalanceIncreasedSnackbar(difference: state.addedDifference),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBalanceIncreasedSnackbar() async {
    setState(() => _balanceIncreased = true);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _balanceIncreased = false);
    }
  }

}
