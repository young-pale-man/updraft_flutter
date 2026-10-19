import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/widgets/machine/pressable.dart';
import 'package:flutter/widgets.dart';

class KeyButton extends StatelessWidget {
  const KeyButton({super.key, required this.icon, required this.label, this.onPressed, this.size = AppSizes.key});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      label: label,
      onPressed: onPressed,
      builder: (context, pressed) => SizedBox(
        width: size,
        height: size + AppSizes.capTravel,
        child: Stack(
          children: [
            Positioned(
              top: AppSizes.capTravel,
              child: _Face(size: size, color: AppColors.capShade),
            ),
            Positioned(
              top: pressed ? AppSizes.capTravel : 0,
              child: _Face(
                size: size,
                color: AppColors.cap,
                child: Icon(icon, size: AppSizes.icon, color: AppColors.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Face extends StatelessWidget {
  const _Face({required this.size, required this.color, this.child});

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
        borderRadius: BorderRadius.circular(AppRadii.key),
        border: Border.all(color: AppColors.ink, width: AppSizes.outline),
      ),
      child: child,
    );
  }
}
