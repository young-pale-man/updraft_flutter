import 'package:updraft_flutter/res/texts.dart';

enum StatisticsParameter {
  allTime(title: AppTexts.allTime),
  today(title: AppTexts.today, daysFromNow: 0),
  lastWeek(title: AppTexts.lastWeek, daysFromNow: 7),
  lastMonth(title: AppTexts.lastMonth, daysFromNow: 30);

  const StatisticsParameter({required this.title, this.daysFromNow});
  final String title;
  final int? daysFromNow;
}
