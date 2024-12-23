import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> shadowOne = [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 2,
      spreadRadius: 0,
      color: AppColors.shadow.shadow1,
    ),
  ];
}
