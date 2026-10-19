import 'dart:async';

import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/pages/home/home_page.dart';
import 'package:updraft_flutter/pages/preloader/widgets/loading_bar.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/route.dart';
import 'package:updraft_flutter/widgets/machine/outlined_text.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:flutter/widgets.dart';

class PreloaderPage extends StatefulWidget {
  const PreloaderPage({super.key});

  @override
  State<PreloaderPage> createState() => _PreloaderPageState();
}

class _PreloaderPageState extends BasePageState<PreloaderPage> with SingleTickerProviderStateMixin {
  static const Duration _loading = Duration(milliseconds: 1600);

  late final AnimationController _progress = AnimationController(vsync: this, duration: _loading)
    ..addStatusListener(_onProgress);

  @override
  void initState() {
    super.initState();
    unawaited(_progress.forward());
  }

  void _onProgress(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      unawaited(Navigator.of(context).pushReplacementNamed(route(HomePage)));
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget pageBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        children: [
          const Spacer(flex: 3),
          const FittedBox(
            child: OutlinedText(AppTexts.appName, style: AppStyles.logo, width: 8, shadows: AppShadows.text),
          ),
          const SizedBox(height: AppSpacing.md),
          const Tag(AppTexts.tagline),
          const Spacer(flex: 2),
          AnimatedBuilder(
            animation: _progress,
            builder: (context, _) => LoadingBar(progress: _progress.value),
          ),
          const SizedBox(height: AppSpacing.xxl * 2),
        ],
      ),
    );
  }
}
