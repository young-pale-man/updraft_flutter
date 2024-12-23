import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  @override
  PreferredSizeWidget? get appBar => const MainAppbar(currentPage: NavigationMenuItems.home);

  @override
  Widget pageBuilder(BuildContext context) {
    return Container();
  }
}
