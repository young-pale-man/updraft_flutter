import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  AppDialogs._();

  static Future<bool?> showMainDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? cancelIconTitle,
    String? actionButtonTitle,
    bool isActionDestructive = false,
  }) => showDialog(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title, style: AppStyles.titleS.copyWith(color: AppColors.ink)),
      content: Text(content, style: AppStyles.bodyM.copyWith(color: AppColors.ink)),
      actions: [
        if (cancelIconTitle != null)
          CupertinoDialogAction(
            child: Text(cancelIconTitle, style: AppStyles.bodyL.copyWith(color: AppColors.ink)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        if (actionButtonTitle != null)
          CupertinoDialogAction(
            child: Text(
              actionButtonTitle,
              style: AppStyles.titleS.copyWith(color: isActionDestructive ? AppColors.negative : AppColors.ink),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
      ],
    ),
  );
}
