import 'package:updraft_flutter/pages/game/game_page.dart';
import 'package:updraft_flutter/pages/menu/menu_page.dart';
import 'package:updraft_flutter/pages/preloader/preloader_page.dart';
import 'package:updraft_flutter/pages/settings/settings_page.dart';
import 'package:updraft_flutter/pages/settings/widgets/privacy_policy.dart';
import 'package:updraft_flutter/pages/settings/widgets/terms_of_use.dart';
import 'package:updraft_flutter/pages/statistics/statistics_page.dart';
import 'package:flutter/widgets.dart';
import 'package:updraft_flutter/utils/route.dart';

Map<String, WidgetBuilder> generateRoutes() {
  return {
    route(PreloaderPage): (_) => const PreloaderPage(),
    route(MenuPage): (_) => const MenuPage(),
    route(GamePage): (_) => const GamePage(),
    route(StatisticsPage): (_) => const StatisticsPage(),
    route(SettingsPage): (_) => const SettingsPage(),
    route(TermsOfUse): (_) => const TermsOfUse(),
    route(PrivacyPolicy): (_) => const PrivacyPolicy(),
  };
}
