import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/shadows.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/widgets/machine/outlined_text.dart';
import 'package:updraft_flutter/widgets/machine/pressable.dart';
import 'package:flutter/widgets.dart';

class SlabButton extends StatelessWidget {
  const SlabButton({super.key, required this.title, this.onPressed, this.selected = false});

  final String title;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      label: title,
      onPressed: onPressed,
      builder: (context, pressed) => Transform.translate(
        offset: Offset(0, pressed ? AppSizes.capTravel / 2 : 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) const _Chevron(AppTexts.selectedOpen),
            DecoratedBox(
              decoration: BoxDecoration(
                color: selected ? AppColors.ink : null,
                borderRadius: BorderRadius.circular(AppRadii.slab),
                boxShadow: selected ? AppShadows.hard : null,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs + 2),
                child: selected
                    ? Text(
                        title,
                        style: AppStyles.titleL.copyWith(color: pressed ? AppColors.figure : AppColors.accent),
                      )
                    : OutlinedText(
                        title,
                        style: AppStyles.titleL,
                        fill: pressed ? AppColors.figure : AppColors.shellText,
                        width: 6,
                        shadows: AppShadows.text,
                      ),
              ),
            ),
            if (selected) const _Chevron(AppTexts.selectedClose),
          ],
        ),
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron(this.glyph);

  final String glyph;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(glyph, style: AppStyles.titleL.copyWith(color: AppColors.ink)),
    );
  }
}
