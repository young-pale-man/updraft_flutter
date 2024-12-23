import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final mainAppTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.main.background,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),
  fontFamily: 'Kanit',
  textTheme: const TextTheme().apply(bodyColor: AppColors.text.primary),
);
