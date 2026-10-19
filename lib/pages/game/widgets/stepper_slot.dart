import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/widgets/machine/arrow_button.dart';
import 'package:flutter/widgets.dart';

class StepperSlot extends StatelessWidget {
  const StepperSlot({
    super.key,
    required this.value,
    required this.lowerLabel,
    required this.raiseLabel,
    required this.onLower,
    required this.onRaise,
    this.canLower = true,
    this.canRaise = true,
    this.enabled = true,
  });

  final String value;
  final String lowerLabel;
  final String raiseLabel;
  final VoidCallback onLower;
  final VoidCallback onRaise;
  final bool canLower;
  final bool canRaise;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ArrowButton(
          direction: AxisDirection.left,
          label: lowerLabel,
          onStep: onLower,
          enabled: enabled && canLower,
          size: AppSizes.arrowButton - 6,
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        Expanded(
          child: Container(
            height: AppSizes.arrowButton - 6,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.screen,
              borderRadius: BorderRadius.circular(AppRadii.slab),
              border: Border.all(color: AppColors.ink, width: AppSizes.outline),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppStyles.figureS.copyWith(color: enabled ? AppColors.figure : AppColors.textDisabled),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        ArrowButton(
          direction: AxisDirection.right,
          label: raiseLabel,
          onStep: onRaise,
          enabled: enabled && canRaise,
          size: AppSizes.arrowButton - 6,
        ),
      ],
    );
  }
}
