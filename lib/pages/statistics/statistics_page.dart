import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:flutter/widgets.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends BasePageState<StatisticsPage> {
  @override
  PreferredSizeWidget? get appBar => const MainAppbar(currentPage: NavigationMenuItems.statistics);

  @override
  Widget pageBuilder(BuildContext context) {
    return Container();
  }
}
