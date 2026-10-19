import 'package:flutter/material.dart';

sealed class AppStyles {
  static HeaderStyle get header => const PhoneHeaderStyle._();
  static BodyStyle get body => const PhoneBodyStyle._();
  static CaptionStyle get caption => const PhoneCaptionStyle._();
  static RegularStyle get regular => const RegularStyle._();
}

sealed class HeaderStyle {
  final TextStyle headerSpecial = const TextStyle();
  final TextStyle headerL = const TextStyle();
  final TextStyle headerM = const TextStyle();
  final TextStyle headerS = const TextStyle();
  final TextStyle headerXS = const TextStyle();
}

sealed class BodyStyle {
  final TextStyle body1 = const TextStyle();
  final TextStyle body2 = const TextStyle();
}

sealed class CaptionStyle {
  final TextStyle caption1 = const TextStyle();
  final TextStyle caption2 = const TextStyle();
}

class PhoneHeaderStyle implements HeaderStyle {
  const PhoneHeaderStyle._();

  @override
  TextStyle get headerSpecial => const TextStyle(
    fontSize: 72,
    fontFamily: 'Kanit',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    height: 1.5,
  );

  @override
  TextStyle get headerL => const TextStyle(
    fontSize: 32,
    fontFamily: 'Kanit',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  @override
  TextStyle get headerM => const TextStyle(
    fontSize: 24,
    fontFamily: 'Kanit',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  @override
  TextStyle get headerS => const TextStyle(
    fontSize: 20,
    fontFamily: 'Kanit',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  @override
  TextStyle get headerXS => const TextStyle(
    fontSize: 17,
    fontFamily: 'Kanit',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );
}

class PhoneBodyStyle implements BodyStyle {
  const PhoneBodyStyle._();

  @override
  TextStyle get body1 => const TextStyle(
    fontSize: 16,
    fontFamily: 'Kanit',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.38,
  );

  @override
  TextStyle get body2 => const TextStyle(
    fontSize: 16,
    fontFamily: 'Kanit',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1.38,
  );
}

class PhoneCaptionStyle implements CaptionStyle {
  const PhoneCaptionStyle._();

  @override
  TextStyle get caption1 => const TextStyle(
    fontSize: 14,
    fontFamily: 'Kanit',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 1.38,
  );

  @override
  TextStyle get caption2 => const TextStyle(
    fontSize: 10,
    fontFamily: 'Kanit',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );
}

class RegularStyle {
  const RegularStyle._();
  final regular13 = const TextStyle(fontFamily: 'SF Pro', fontWeight: FontWeight.w400, fontSize: 13);

  final semiBold13 = const TextStyle(fontFamily: 'SF Pro', fontWeight: FontWeight.w600, fontSize: 13);

  final regular17 = const TextStyle(fontFamily: 'SF Pro', fontSize: 17, fontWeight: FontWeight.w400, height: 1);

  final semiBold17 = const TextStyle(fontFamily: 'SF Pro', fontSize: 17, fontWeight: FontWeight.w600, height: 1);

  final regular22 = const TextStyle(fontFamily: 'SF Pro', fontSize: 22, fontWeight: FontWeight.w400, height: 1);

  final semiBold22 = const TextStyle(fontFamily: 'SF Pro', fontSize: 22, fontWeight: FontWeight.w600, height: 1);
}
