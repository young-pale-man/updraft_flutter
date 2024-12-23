import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  AppDialogs._();

  static Future<void> showMainDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String actionButtonTitle,
  }) =>
      showDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(
            title,
            style: AppStyles.regular.semiBold17.copyWith(color: AppColors.regular.text),
          ),
          content: Text(
            content,
            style: AppStyles.regular.regular13.copyWith(color: AppColors.regular.text),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                actionButtonTitle,
                style: AppStyles.regular.semiBold17.copyWith(color: AppColors.regular.action),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
}
