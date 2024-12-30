import 'package:updraft_flutter/data/enums/statistics_parameter.dart';
import 'package:updraft_flutter/data/models/statistics_item_model.dart';
import 'package:updraft_flutter/pages/statistics/widgets/statistics_chart.dart';
import 'package:updraft_flutter/pages/statistics/widgets/statistics_parameter_picker.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/cupertino.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.selectedParameter,
    required this.changeParameter,
    required this.statistics,
  });

  final StatisticsParameter selectedParameter;
  final ValueChanged<int> changeParameter;
  final List<StatisticsItemModel> statistics;

  @override
  Widget build(BuildContext context) {
    final winPercentage = calculateWinPercentage();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        color: AppColors.main.layer1,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(width: 2, color: AppColors.main.layer2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatisticsParameterPicker(
            parameter: selectedParameter,
            changeParameter: changeParameter,
          ),
          const SizedBox(height: 26),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: StatisticsChart(
              winPercentage: winPercentage,
              losePercentage: statistics.isEmpty ? 0 : 100 - winPercentage,
            ),
          ),
        ],
      ),
    );
  }

  double calculateWinPercentage() {
    if (statistics.isEmpty) return 0.0;

    int winCount = statistics.where((item) => item.isWin == true).length;
    double winPercentage = (winCount / statistics.length) * 100;

    return winPercentage;
  }
}
