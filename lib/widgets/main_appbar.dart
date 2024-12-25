import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/device_info.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:updraft_flutter/widgets/navigation_menu/navigation_menu.dart';
import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({
    super.key,
    required this.currentPage,
    this.content,
    this.menuButtonSize = 50,
  });

  final NavigationMenuItems currentPage;
  final Widget? content;
  final double menuButtonSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 12, 16, 12),
      color: Colors.transparent,
      child: Stack(
        children: [
          Row(
            children: [
              MainIconButton(
                height: scaledSize(menuButtonSize),
                onPressed: () => _showNavigationMenu(context),
                icon: Assets.menu,
              ),
              if (content != null) ...[
                const SizedBox(width: 8),
                Expanded(child: content!),
              ],
            ],
          ),
          if (content == null)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: scaledSize(menuButtonSize) + 8),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    currentPage.title,
                    style: AppStyles.header.headerM.copyWith(color: AppColors.text.primary),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showNavigationMenu(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return NavigationMenu(currentPage: currentPage.page);
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(isTablet ? 100 : 74);
}
