import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:flutter/widgets.dart';

class BalanceBar extends StatelessWidget {
  const BalanceBar({super.key, required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cap,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(width: 2, color: AppColors.ink),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(Coins.format(balance), style: AppStyles.figureM.copyWith(color: AppColors.ink)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
