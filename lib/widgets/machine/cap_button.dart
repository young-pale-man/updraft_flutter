import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/widgets/machine/pressable.dart';
import 'package:flutter/widgets.dart';

enum CapTone { plain, positive, destructive }

class CapButton extends StatelessWidget {
  const CapButton({super.key, required this.title, this.onPressed, this.tone = CapTone.plain, this.enabled = true});

  final String title;
  final VoidCallback? onPressed;
  final CapTone tone;
  final bool enabled;

  Color get _ink => !enabled
      ? AppColors.textDisabled
      : switch (tone) {
          CapTone.plain => AppColors.ink,
          CapTone.positive => AppColors.positiveOnCap,
          CapTone.destructive => AppColors.negativeOnCap,
        };

  static const double _height = 52;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      label: title,
      onPressed: onPressed,
      enabled: enabled,
      builder: (context, pressed) => SizedBox(
        height: _height + AppSizes.capTravel,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: AppSizes.capTravel,
              child: _Face(color: enabled ? AppColors.capShade : AppColors.capShadeDisabled),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: pressed ? AppSizes.capTravel : 0,
              child: _Face(
                color: enabled ? AppColors.cap : AppColors.capDisabled,
                child: Text(title, style: AppStyles.titleS.copyWith(color: _ink)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Face extends StatelessWidget {
  const _Face({required this.color, this.child});

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CapButton._height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadii.key),
        border: Border.all(color: AppColors.ink, width: AppSizes.outline),
      ),
      child: child,
    );
  }
}
