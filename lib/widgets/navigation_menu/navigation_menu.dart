import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:updraft_flutter/widgets/navigation_menu/navigation_menu_item.dart';
import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({
    super.key,
    required this.currentPage,
  });

  final Type currentPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeInOut,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 12, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.main.background,
              border: Border(
                bottom: BorderSide(width: 2, color: AppColors.main.layer3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainIconButton(
                  height: scaledSize(50),
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Assets.close,
                ),
                const SizedBox(height: 32),
                ...List.generate(
                  NavigationMenuItems.values.length,
                  (index) {
                    final item = NavigationMenuItems.values[index];
                    return NavigationMenuTile(
                      item: item,
                      isSelected: currentPage == item.page,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
