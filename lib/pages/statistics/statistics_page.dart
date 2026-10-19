import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/data/enums/statistics_parameter.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
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

  @override
  bool get bottomSafeArea => false;

  @override
  PreferredSizeWidget? get appBar => const MainAppbar(currentPage: NavigationMenuItems.statistics);

  @override
  Widget pageBuilder(BuildContext context) {
    final rounds = context.select((StatisticsBloc bloc) => bloc.state.rounds);
    final statBySelectedParameter = _filterStatisticsByParameter(rounds);
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
                          style: AppStyles.bodyL.copyWith(color: AppColors.textMuted),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 16),
                        itemCount: statGrouped.length,
                        itemBuilder: (context, index) =>
                            StatisticsDayGroup(date: statGrouped[index].key, dayGroup: statGrouped[index].value),
                        separatorBuilder: (_, _) => const SizedBox(height: 20),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeParameter(int index) => setState(() => _selectedParameter = StatisticsParameter.values[index]);

  List<RoundRecord> _filterStatisticsByParameter(List<RoundRecord> rounds) {
    if (_selectedParameter == StatisticsParameter.allTime) {
      return rounds;
    }

    final now = DateTime.now();
    final fromDate = now.subtract(Duration(days: _selectedParameter.daysFromNow ?? 0));
    final todayDate = DateTime(now.year, now.month, now.day);

    return rounds.where((item) {
      final itemDate = DateTime(item.time.year, item.time.month, item.time.day);
      if (_selectedParameter == StatisticsParameter.today) {
        return itemDate == todayDate;
      }
      return itemDate.isAfter(fromDate) || itemDate == fromDate;
    }).toList();
  }

  Map<DateTime, List<RoundRecord>> _groupItemsByDates(List<RoundRecord> statistics) {
    final grouped = <DateTime, List<RoundRecord>>{};
    for (final item in statistics) {
      final dateWithoutTime = DateTime(item.time.year, item.time.month, item.time.day);
      grouped.putIfAbsent(dateWithoutTime, () => []).insert(0, item);
    }
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return {for (final key in sortedKeys) key: grouped[key]!};
  }
}
