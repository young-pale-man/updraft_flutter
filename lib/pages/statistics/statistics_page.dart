import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/data/enums/statistics_parameter.dart';
import 'package:updraft_flutter/data/models/statistics_item_model.dart';
import 'package:updraft_flutter/pages/statistics/widgets/statistics_card.dart';
import 'package:updraft_flutter/pages/statistics/widgets/statistics_day_group.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends BasePageState<StatisticsPage> {
  StatisticsParameter _selectedParameter = StatisticsParameter.allTime;

  late final List<StatisticsItemModel> _allStatistics;

  @override
  void initState() {
    super.initState();
    _allStatistics = context.read<StatisticsBloc>().state.statisticsItemsList;
  }

  @override
  bool get bottomSafeArea => false;

  @override
  PreferredSizeWidget? get appBar => const MainAppbar(currentPage: NavigationMenuItems.statistics);

  @override
  Widget pageBuilder(BuildContext context) {
    final statBySelectedParameter = _filterStatisticsByParameter();
    final statGrouped = _groupItemsByDates(statBySelectedParameter).entries.toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              StatisticsCard(
                selectedParameter: _selectedParameter,
                changeParameter: _changeParameter,
                statistics: statBySelectedParameter,
              ),
              const SizedBox(height: 16),
              statGrouped.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 64),
                        Text(
                          AppTexts.thereAreNoStatisticsAtThisMoment,
                          style: AppStyles.body.body2.copyWith(color: AppColors.text.secondary),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                  : Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 16),
                        itemCount: statGrouped.length,
                        itemBuilder: (context, index) => StatisticsDayGroup(
                          date: statGrouped[index].key,
                          dayGroup: statGrouped[index].value,
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _changeParameter(int index) => setState(() => _selectedParameter = StatisticsParameter.values[index]);

  List<StatisticsItemModel> _filterStatisticsByParameter() {
    if (_selectedParameter == StatisticsParameter.allTime) {
      return _allStatistics;
    }

    final now = DateTime.now();
    final fromDate = now.subtract(Duration(days: _selectedParameter.daysFromNow ?? 0));

    return _allStatistics.where((item) {
      if (item.date == null) return false;

      final itemDate = DateTime(item.date!.year, item.date!.month, item.date!.day);
      final todayDate = DateTime(now.year, now.month, now.day);

      if (_selectedParameter == StatisticsParameter.today) {
        return itemDate == todayDate;
      } else {
        return itemDate.isAfter(fromDate) || itemDate == fromDate;
      }
    }).toList();
  }

  Map<DateTime, List<StatisticsItemModel>> _groupItemsByDates(List<StatisticsItemModel> statistics) {
    final Map<DateTime, List<StatisticsItemModel>> grouped = {};

    for (var item in statistics) {
      if (item.date != null) {
        final dateWithoutTime = DateTime(item.date!.year, item.date!.month, item.date!.day);

        if (!grouped.containsKey(dateWithoutTime)) {
          grouped[dateWithoutTime] = [];
        }

        grouped[dateWithoutTime]!.insert(0, item);
      }
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {
      for (var key in sortedKeys) key: grouped[key]!,
    };
  }
}
