import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:flutter/widgets.dart';

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> hard = [
    BoxShadow(color: AppColors.dropShadow, offset: Offset(AppSizes.dropShadow, AppSizes.dropShadow)),
  ];

  static const List<Shadow> text = [Shadow(color: AppColors.dropShadow, offset: Offset(3, 3))];
}
