import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/material.dart';

final mainAppTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.shell,
  brightness: Brightness.light,
  fontFamily: 'Rubik',
  textTheme: const TextTheme().apply(bodyColor: AppColors.ink),
);
