import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/widgets/machine/pressable.dart';
import 'package:flutter/widgets.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.title,
    this.detail,
    this.onPressed,
    this.enabled = true,
    this.size = AppSizes.actionButton,
  });

  static const Key capKey = ValueKey('action-button-cap');

  final String title;
  final String? detail;
  final VoidCallback? onPressed;
  final bool enabled;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cap = enabled ? AppColors.cap : AppColors.capDisabled;
    final shade = enabled ? AppColors.capShade : AppColors.capShadeDisabled;
    final ink = enabled ? AppColors.ink : AppColors.textDisabled;
    return Pressable(
      label: detail == null ? title : '$title $detail',
      onPressed: onPressed,
      enabled: enabled,
      builder: (context, pressed) => SizedBox(
        width: size,
        height: size + AppSizes.capTravel,
        child: Stack(
          children: [
            Positioned(
              top: AppSizes.capTravel,
              child: _Disc(size: size, color: shade),
            ),
            Positioned(
              key: capKey,
              top: pressed ? AppSizes.capTravel : 0,
              child: _Disc(
                size: size,
                color: cap,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: AppStyles.titleM.copyWith(color: ink)),
                        if (detail != null) Text(detail!, style: AppStyles.figureS.copyWith(color: ink)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Disc extends StatelessWidget {
  const _Disc({required this.size, required this.color, this.child});

  final double size;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.ink, width: AppSizes.outline),
      ),
      child: child,
    );
  }
}
