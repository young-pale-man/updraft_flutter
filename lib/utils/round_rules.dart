import 'package:updraft_flutter/utils/crash_curve.dart';

class RoundRules {
  const RoundRules._();

  static const Duration countdown = Duration(seconds: 3);
  static const Duration resultPause = Duration(milliseconds: 1500);

  static const int defaultEntry = 1000;
  static const int entryStep = 10;

  static const int minTarget = 110;
  static const int maxTarget = CrashCurve.maxHundredths;
  static const int defaultTarget = 200;
  static const int targetStep = 10;

  static int secondsLeft(Duration elapsed) {
    final remaining = countdown - elapsed;
    if (remaining <= Duration.zero) return 0;
    return (remaining.inMicroseconds / Duration.microsecondsPerSecond).ceil();
  }

  static int clampTarget(int target) => target.clamp(minTarget, maxTarget);
}
