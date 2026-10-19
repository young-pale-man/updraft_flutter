import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/widgets/machine/cap_button.dart';
import 'package:updraft_flutter/widgets/machine/screen_panel.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:flutter/material.dart';

class MainDialog extends StatelessWidget {
  const MainDialog({
    super.key,
    required this.title,
    required this.content,
    required this.cancelTitle,
    required this.actionTitle,
    this.destructive = false,
  });

  final String title;
  final String content;
  final String cancelTitle;
  final String actionTitle;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ScreenPanel(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tag(title),
                  const SizedBox(height: AppSpacing.md),
                  Text(content, style: AppStyles.bodyL.copyWith(color: AppColors.figure)),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: CapButton(title: cancelTitle, onPressed: () => Navigator.of(context).pop(false)),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: CapButton(
                          title: actionTitle,
                          destructive: destructive,
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
