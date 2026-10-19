import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/round_periods.dart';
import 'package:updraft_flutter/widgets/machine/pressable.dart';
import 'package:flutter/widgets.dart';

class PeriodChips extends StatelessWidget {
  const PeriodChips({super.key, required this.selected, required this.onSelected});

  final RoundPeriod selected;
  final ValueChanged<RoundPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final period in RoundPeriod.values) ...[
          if (period != RoundPeriod.values.first) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Semantics(
              selected: period == selected,
              child: Pressable(
                label: period.title,
                onPressed: () => onSelected(period),
                builder: (context, pressed) => _Chip(title: period.title, selected: period == selected),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.title, required this.selected});

  final String title;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.key - AppSpacing.sm,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.ink : AppColors.cap,
        borderRadius: BorderRadius.circular(AppRadii.slab),
        border: Border.all(color: AppColors.ink, width: AppSizes.outline),
        boxShadow: selected ? null : AppShadows.hard,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(title, style: AppStyles.tag.copyWith(color: selected ? AppColors.accent : AppColors.ink)),
      ),
    );
  }
}
