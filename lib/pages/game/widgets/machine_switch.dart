import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/widgets/machine/pressable.dart';
import 'package:flutter/widgets.dart';

class MachineSwitch extends StatelessWidget {
  const MachineSwitch({super.key, required this.value, required this.label, this.onChanged, this.enabled = true});

  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  static const double _width = 52;
  static const double _height = 28;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      child: Pressable(
        label: label,
        enabled: enabled,
        onPressed: onChanged == null ? null : () => onChanged!(!value),
        builder: (context, pressed) => Container(
          width: _width,
          height: _height,
          padding: const EdgeInsets.all(AppSizes.outline),
          decoration: BoxDecoration(
            color: value ? AppColors.accent : AppColors.screen,
            borderRadius: BorderRadius.circular(_height / 2),
            border: Border.all(color: AppColors.ink, width: AppSizes.outline),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 120),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: _height - AppSizes.outline * 4,
              height: _height - AppSizes.outline * 4,
              decoration: BoxDecoration(
                color: enabled ? AppColors.cap : AppColors.capDisabled,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.ink, width: AppSizes.hairline),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
