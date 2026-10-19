import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/widgets/machine/screen_panel.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:flutter/widgets.dart';

class RuleSection extends StatelessWidget {
  const RuleSection({super.key, required this.title, required this.note, this.child});

  final String title;
  final String note;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tag(title),
          const SizedBox(height: AppSpacing.sm),
          ScreenPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(note, style: AppStyles.bodyL.copyWith(color: AppColors.figure)),
                if (child != null) ...[const SizedBox(height: AppSpacing.md), child!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
