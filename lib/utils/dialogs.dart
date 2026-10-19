import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/widgets/main_dialog.dart';
import 'package:flutter/widgets.dart';

class AppDialogs {
  AppDialogs._();

  static Future<bool?> showMainDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String cancelTitle,
    required String actionTitle,
    bool destructive = false,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: cancelTitle,
      barrierColor: AppColors.scrim,
      transitionDuration: const Duration(milliseconds: 180),
      transitionBuilder: (context, animation, _, child) => ScaleTransition(
        scale: Tween(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
        child: FadeTransition(opacity: animation, child: child),
      ),
      pageBuilder: (context, _, _) => MainDialog(
        title: title,
        content: content,
        cancelTitle: cancelTitle,
        actionTitle: actionTitle,
        destructive: destructive,
      ),
    );
  }
}
