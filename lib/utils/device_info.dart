import 'dart:math';
import 'package:flutter/material.dart';

bool isTablet = false;

class DeviceInfo {
  DeviceInfo._();

  static void initializeDeviceInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diagonal = sqrt(size.width * size.width + size.height * size.height);
    isTablet = diagonal > 1100.0;
  }
}
