import 'package:updraft_flutter/pages/home/home_page.dart';
import 'package:updraft_flutter/pages/settings/settings_page.dart';
import 'package:updraft_flutter/pages/statistics/statistics_page.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/texts.dart';

enum NavigationMenuItems {
  home(title: AppTexts.home, icon: Assets.home, page: HomePage),
  statistics(title: AppTexts.statistics, icon: Assets.statistics, page: StatisticsPage),
  settings(title: AppTexts.settings, icon: Assets.settings, page: SettingsPage);

  const NavigationMenuItems({required this.title, required this.icon, required this.page});
  final String title;
  final String icon;
  final Type page;
}
