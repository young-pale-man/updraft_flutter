import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/pages/statistics/widgets/day_panel.dart';
import 'package:updraft_flutter/pages/statistics/widgets/period_chips.dart';
import 'package:updraft_flutter/pages/statistics/widgets/summary_panel.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:updraft_flutter/utils/round_periods.dart';
import 'package:updraft_flutter/utils/round_summary.dart';
import 'package:updraft_flutter/widgets/machine/screen_panel.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends BasePageState<StatisticsPage> {
  RoundPeriod _period = RoundPeriod.allTime;

  @override
  bool get bottomSafeArea => false;

  @override
  PreferredSizeWidget? get appBar => const MainAppbar(title: AppTexts.statistics);

  @override
  Widget pageBuilder(BuildContext context) {
    final now = context.read<AppDependencies>().clock();
    final rounds = _period.select(context.select((StatisticsBloc bloc) => bloc.state.rounds), now);
    final days = RoundDays.of(rounds);
    final bottom = MediaQuery.paddingOf(context).bottom + AppSpacing.lg;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
          sliver: SliverList.list(
            children: [
              PeriodChips(selected: _period, onSelected: (period) => setState(() => _period = period)),
              const SizedBox(height: AppSpacing.lg),
              SummaryPanel(summary: RoundSummary.of(rounds)),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
        if (days.isEmpty)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, bottom),
            sliver: SliverToBoxAdapter(
              child: ScreenPanel(
                child: Text(
                  AppTexts.noFlightsYet,
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyL.copyWith(color: AppColors.textMuted),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, bottom),
            sliver: SliverList.separated(
              itemCount: days.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xl),
              itemBuilder: (context, index) => DayPanel(day: days[index], now: now),
            ),
          ),
      ],
    );
  }
}
