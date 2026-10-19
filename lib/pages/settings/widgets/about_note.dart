import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:flutter/widgets.dart';

class AboutNote extends StatelessWidget {
  const AboutNote({super.key, required this.title, required this.note});

  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.tag.copyWith(color: AppColors.accent)),
          const SizedBox(height: AppSpacing.xs),
          Text(note, style: AppStyles.bodyM.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
