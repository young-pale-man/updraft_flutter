import 'package:updraft_flutter/pages/statistics/widgets/chart_row.dart';
import 'package:updraft_flutter/pages/statistics/widgets/custom_chart.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticsChart extends StatelessWidget {
  const StatisticsChart({super.key, required this.winPercentage, required this.losePercentage});

  final double winPercentage;
  final double losePercentage;

  @override
  Widget build(BuildContext context) {
    return CustomChart(
      radius: 96,
      percentValue: winPercentage,
      chartColor: AppColors.system.positive,
      child: CustomChart(
        radius: 80,
        percentValue: losePercentage,
        chartColor: AppColors.system.negative,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChartRow(isWin: true, value: winPercentage.ceil()),
            const SizedBox(height: 4),
            ChartRow(isWin: false, value: losePercentage.floor()),
          ],
        ),
      ),
    );
  }
}
