import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';

import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:flutter/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends BasePageState<SettingsPage> {
  @override
  PreferredSizeWidget? get appBar => const MainAppbar(currentPage: NavigationMenuItems.settings);

  @override
  Widget pageBuilder(BuildContext context) {
    return Container();
  }
}
