import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/route.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:flutter/widgets.dart';

class NavigationMenuTile extends StatelessWidget {
  const NavigationMenuTile({
    super.key,
    required this.item,
    required this.isSelected,
  });

  final NavigationMenuItems item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MainIconButton(
          height: scaledSize(50),
          icon: item.icon,
          disabled: !isSelected,
          onPressed: () => _selectPage(context),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.title,
                style: AppStyles.header.headerM.copyWith(
                  color: isSelected ? AppColors.text.primary : AppColors.tertiary.tertiary1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectPage(BuildContext context) {
    if (isSelected) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route(item.page),
        (route) => false,
      );
    }
  }
}
