import 'dart:async';

import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/pages/game/game_page.dart';
import 'package:updraft_flutter/pages/menu/widgets/menu_header.dart';
import 'package:updraft_flutter/pages/settings/settings_page.dart';
import 'package:updraft_flutter/pages/statistics/statistics_page.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/route.dart';
import 'package:updraft_flutter/widgets/machine/outlined_text.dart';
import 'package:updraft_flutter/widgets/machine/slab_button.dart';
import 'package:flutter/widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends BasePageState<MenuPage> {
  void _open(Type page) => unawaited(Navigator.of(context).pushNamed(route(page)));

  @override
  Widget pageBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          const MenuHeader(),
          const Spacer(),
          const FittedBox(
            child: OutlinedText(AppTexts.appName, style: AppStyles.logo, width: 8, shadows: AppShadows.text),
          ),
          const Spacer(),
          SlabButton(title: AppTexts.play, selected: true, onPressed: () => _open(GamePage)),
          const SizedBox(height: AppSpacing.md),
          SlabButton(title: AppTexts.statistics, onPressed: () => _open(StatisticsPage)),
          const SizedBox(height: AppSpacing.md),
          SlabButton(title: AppTexts.settings, onPressed: () => _open(SettingsPage)),
          const Spacer(flex: 2),
          Text(
            AppTexts.playMoney,
            textAlign: TextAlign.center,
            style: AppStyles.caption.copyWith(color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
