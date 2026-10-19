import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/pages/settings/widgets/about_note.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/dialogs.dart';
import 'package:updraft_flutter/widgets/machine/cap_button.dart';
import 'package:updraft_flutter/widgets/machine/screen_panel.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends BasePageState<SettingsPage> {
  @override
  bool get bottomSafeArea => false;

  @override
  PreferredSizeWidget? get appBar => const MainAppbar(title: AppTexts.settings);

  @override
  Widget pageBuilder(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        MediaQuery.paddingOf(context).bottom + AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(alignment: Alignment.centerLeft, child: Tag(AppTexts.data)),
          const SizedBox(height: AppSpacing.sm),
          ScreenPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppTexts.clearStatisticsDescription, style: AppStyles.bodyM.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: AppSpacing.lg),
                CapButton(title: AppTexts.clearStatistics, tone: CapTone.destructive, onPressed: _clearStatistics),
                const SizedBox(height: AppSpacing.xl),
                Text(AppTexts.refillDescription, style: AppStyles.bodyM.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: AppSpacing.lg),
                CapButton(
                  title: AppTexts.refillBalance,
                  tone: CapTone.positive,
                  enabled: context.select((BalanceBloc bloc) => bloc.state.needsRefill),
                  onPressed: () => context.read<BalanceBloc>().add(const BalanceRefilled()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Align(alignment: Alignment.centerLeft, child: Tag(AppTexts.about)),
          const SizedBox(height: AppSpacing.sm),
          ScreenPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppTexts.appName, style: AppStyles.titleL.copyWith(color: AppColors.figure)),
                Text(AppTexts.version, style: AppStyles.caption.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: AppSpacing.md),
                Text(AppTexts.aboutSummary, style: AppStyles.bodyL.copyWith(color: AppColors.figure)),
                const AboutNote(title: AppTexts.theGame, note: AppTexts.theGameNote),
                const AboutNote(title: AppTexts.fairSkies, note: AppTexts.fairSkiesNote),
                const AboutNote(title: AppTexts.playCoins, note: AppTexts.playCoinsNote),
                const AboutNote(title: AppTexts.privacy, note: AppTexts.offlineNote),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearStatistics() async {
    final confirmed = await AppDialogs.showMainDialog(
      context,
      title: AppTexts.clearStatistics,
      content: AppTexts.clearStatisticsWarning,
      cancelTitle: AppTexts.cancel,
      actionTitle: AppTexts.clear,
      destructive: true,
    );
    if (confirmed != true || !mounted) return;
    context.read<StatisticsBloc>().add(const StatisticsCleared());
  }
}
