import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:flutter/material.dart';

class SettingsAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppbar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 12, 16, 12),
      color: Colors.transparent,
      child: Row(
        children: [
          MainIconButton(height: 50, onPressed: () => Navigator.of(context).pop(), icon: Assets.arrowLeft),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(title, style: AppStyles.header.headerXS.copyWith(color: AppColors.text.primary)),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(74);
}
