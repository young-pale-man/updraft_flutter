import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:flutter/widgets.dart';

class ScreenPanel extends StatelessWidget {
  const ScreenPanel({super.key, required this.child, this.padding = const EdgeInsets.all(AppSpacing.lg)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.screen,
        borderRadius: BorderRadius.circular(AppRadii.screen),
        border: Border.all(color: AppColors.ink, width: AppSizes.outline),
        boxShadow: AppShadows.hard,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
