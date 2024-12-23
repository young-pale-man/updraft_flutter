import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const MainColors main = MainColors._();
  static const AccentColors accent = AccentColors._();
  static const TextColors text = TextColors._();
  static const SystemColors system = SystemColors._();
  static const TertiaryColors tertiary = TertiaryColors._();
  static const ShadowColors shadow = ShadowColors._();
  static RegularColors get regular => const RegularColors._();
}

class MainColors {
  const MainColors._();

  final background = const Color(0xFFF6F6F6);
  final layer1 = const Color(0xFFFFFFFF);
  final layer2 = const Color(0xFFEAEAEA);
  final layer3 = const Color(0xFFDADADA);
  final layer4 = const Color(0xFFCBCBCB);
}

class AccentColors {
  const AccentColors._();

  final primary1 = const Color(0xFF2F24FF);
  final primary2 = const Color(0xFF160CD1);
}

class TextColors {
  const TextColors._();

  final primary = const Color(0xFF000000);
  final secondary = const Color(0xFFA3A3A3);
}

class SystemColors {
  const SystemColors._();

  final positive = const Color(0xFF34C759);
  final negative = const Color(0xFFFF2B2E);
}

class TertiaryColors {
  const TertiaryColors._();

  final tertiary1 = const Color(0xFFC0BFCD);
}

class ShadowColors {
  const ShadowColors._();

  final shadow1 = const Color(0x1F000000);
  final buttonDisabled = const Color(0x33000000);
}

class RegularColors {
  const RegularColors._();
  final background = const Color(0xFFEFEFEF);
  final action = const Color(0xFF007AFF);
  final destructiveAction = const Color(0xFFFF3B30);
  final text = const Color(0xFF000000);
  final textDisabled = const Color(0xFF9C9C9C);
}
