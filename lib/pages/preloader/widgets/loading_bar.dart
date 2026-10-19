import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:flutter/widgets.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.lg + AppSizes.outline * 2,
      padding: const EdgeInsets.all(AppSizes.outline),
      decoration: const BoxDecoration(color: AppColors.ink, boxShadow: AppShadows.hard),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0, 1),
          child: const ColoredBox(color: AppColors.accent, child: SizedBox.expand()),
        ),
      ),
    );
  }
}
