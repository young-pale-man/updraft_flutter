import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/pages/settings/widgets/parameter_tile.dart';
import 'package:updraft_flutter/pages/settings/widgets/privacy_policy.dart';
import 'package:updraft_flutter/pages/settings/widgets/terms_of_use.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:updraft_flutter/utils/dialogs.dart';
import 'package:updraft_flutter/utils/route.dart';

import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.paddingOf(context).bottom + 16),
        child: Center(
          child: Column(
            children: [
              ...Settings.values.map(
                (parameter) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: ParameterTile(
                      title: parameter.title,
                      icon: parameter.icon,
                      onPressed: () => parameter.action(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Settings {
  notifications(
    title: AppTexts.notifications,
    icon: Assets.notifications,
  ),
  privacyPolicy(
    title: AppTexts.privacyPolicy,
    icon: Assets.privacyPolicy,
  ),
  termsOfUse(
    title: AppTexts.termsOfUse,
    icon: Assets.termsOfUse,
  ),
  rateUs(
    title: AppTexts.rateUs,
    icon: Assets.rateUs,
  ),
  shareThisApp(
    title: AppTexts.shareThisApp,
    icon: Assets.shareThisApp,
  ),
  clearStatistics(
    title: AppTexts.clearStatistics,
    icon: Assets.clear,
  );

  const Settings({
    required this.title,
    required this.icon,
  });

  final String title;
  final String icon;

  void Function(BuildContext) get action {
    switch (this) {
      case Settings.notifications:
        return (_) async => await AppSettings.openAppSettings(type: AppSettingsType.notification);
      case Settings.privacyPolicy:
        return (context) => Navigator.of(context).pushNamed(route(PrivacyPolicy));
      case Settings.termsOfUse:
        return (context) => Navigator.of(context).pushNamed(route(TermsOfUse));
      case Settings.rateUs:
        return (_) async {
          final inAppReview = InAppReview.instance;
          if (await inAppReview.isAvailable()) {
            if (Platform.isIOS) {
              inAppReview.requestReview();
            } else {
              inAppReview.openStoreListing();
            }
          }
        };
      case Settings.shareThisApp:
        return (context) async {
          final Size size = MediaQuery.of(context).size;
          await Share.share(
            'https://www.youtube.com',
            subject: 'Welcome to the App',
            sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
          );
        };
      case Settings.clearStatistics:
        return (context) async {
          final clearConfirmed = await AppDialogs.showMainDialog(
            context,
            title: AppTexts.clearStatistics,
            content: AppTexts.areYouSureTheStatisticsData,
            cancelIconTitle: AppTexts.cancel,
            actionButtonTitle: AppTexts.clear,
            isActionDestructive: true,
          );

          if (clearConfirmed == true) {
            injector<StatisticsBloc>().add(ClearStatisticsEV());
          }
        };
    }
  }
}
