import 'dart:math';

class CrashCurve {
  const CrashCurve();

  static const int returnPercent = 97;
  static const int maxHundredths = 10000;

  int draw(Random random) {
    final hundredths = (returnPercent / (1 - random.nextDouble())).floor();
    return hundredths.clamp(100, maxHundredths);
  }
}
