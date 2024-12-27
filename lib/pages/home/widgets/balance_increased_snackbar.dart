import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:flutter/material.dart';

class BalanceIncreasedSnackbar extends StatelessWidget {
  const BalanceIncreasedSnackbar({
    super.key,
    required this.difference,
  });

  final double difference;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.system.positive,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          width: 2,
          color: AppColors.text.primary,
        ),
        boxShadow: AppShadows.shadowOne,
      ),
      child: Text(
        difference.toStringAsFixed(2),
        style: AppStyles.body.body1.copyWith(color: AppColors.text.primary),
      ),
    );
  }
}
