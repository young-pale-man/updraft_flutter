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
      title: Text(title, style: AppStyles.regular.semiBold17.copyWith(color: AppColors.regular.text)),
      content: Text(content, style: AppStyles.regular.regular13.copyWith(color: AppColors.regular.text)),
      actions: [
        if (cancelIconTitle != null)
          CupertinoDialogAction(
            child: Text(cancelIconTitle, style: AppStyles.regular.regular17.copyWith(color: AppColors.regular.action)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        if (actionButtonTitle != null)
          CupertinoDialogAction(
            child: Text(
              actionButtonTitle,
              style: AppStyles.regular.semiBold17.copyWith(
                color: isActionDestructive ? AppColors.regular.destructiveAction : AppColors.regular.action,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
      ],
    ),
  );
}
