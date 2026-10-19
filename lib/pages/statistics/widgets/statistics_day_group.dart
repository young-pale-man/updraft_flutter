import 'package:updraft_flutter/data/models/statistics_item_model.dart';
import 'package:updraft_flutter/pages/statistics/widgets/statistics_item_tile.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/extensions/date_format_ext.dart';
import 'package:flutter/cupertino.dart';

class StatisticsDayGroup extends StatelessWidget {
  const StatisticsDayGroup({super.key, required this.date, required this.dayGroup});

  final DateTime date;
  final List<StatisticsItemModel> dayGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(date.formatStatisticsDate(), style: AppStyles.body.body2.copyWith(color: AppColors.text.secondary)),
        const SizedBox(height: 4),
        ListView.separated(
          itemCount: dayGroup.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) =>
              StatisticsItemTile(key: ValueKey(dayGroup[index].id), statisticsItem: dayGroup[index]),
          separatorBuilder: (_, _) => const SizedBox(height: 6),
        ),
      ],
    );
  }
}
