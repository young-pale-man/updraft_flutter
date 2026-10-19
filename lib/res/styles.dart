import 'package:flutter/material.dart';

sealed class AppStyles {
  static const String _display = 'Bungee';
  static const String _text = 'Rubik';
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  static const TextStyle logo = TextStyle(fontFamily: _display, fontSize: 46, height: 1.05, letterSpacing: 1);

  static const TextStyle titleL = TextStyle(fontFamily: _display, fontSize: 28, height: 1.1, letterSpacing: 0.5);

  static const TextStyle titleM = TextStyle(fontFamily: _display, fontSize: 22, height: 1.15, letterSpacing: 0.5);

  static const TextStyle titleS = TextStyle(fontFamily: _display, fontSize: 16, height: 1.2, letterSpacing: 0.5);

  static const TextStyle tag = TextStyle(fontFamily: _display, fontSize: 13, height: 1.2, letterSpacing: 0.6);

  static const TextStyle figureXL = TextStyle(
    fontFamily: _text,
    fontSize: 60,
    fontWeight: FontWeight.w900,
    fontVariations: [FontVariation.weight(900)],
    height: 1.05,
    fontFeatures: _tabular,
  );

  static const TextStyle figureL = TextStyle(
    fontFamily: _text,
    fontSize: 40,
    fontWeight: FontWeight.w900,
    fontVariations: [FontVariation.weight(900)],
    height: 1.1,
    fontFeatures: _tabular,
  );

  static const TextStyle figureM = TextStyle(
    fontFamily: _text,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    fontVariations: [FontVariation.weight(800)],
    height: 1.15,
    fontFeatures: _tabular,
  );

  static const TextStyle figureS = TextStyle(
    fontFamily: _text,
    fontSize: 17,
    fontWeight: FontWeight.w800,
    fontVariations: [FontVariation.weight(800)],
    height: 1.2,
    fontFeatures: _tabular,
  );

  static const TextStyle bodyL = TextStyle(
    fontFamily: _text,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation.weight(600)],
    height: 1.4,
  );

  static const TextStyle bodyM = TextStyle(
    fontFamily: _text,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation.weight(500)],
    height: 1.45,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _text,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation.weight(600)],
    height: 1.35,
    fontFeatures: _tabular,
  );
}
