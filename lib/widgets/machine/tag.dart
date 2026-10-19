import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:flutter/widgets.dart';

class Tag extends StatelessWidget {
  const Tag(this.text, {super.key, this.color = AppColors.accent});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(AppRadii.tag)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.sm - 2, 3, AppSpacing.sm - 2, 1),
        child: Text(text, style: AppStyles.tag.copyWith(color: color)),
      ),
    );
  }
}
