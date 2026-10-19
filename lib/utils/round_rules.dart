import 'package:updraft_flutter/utils/crash_curve.dart';

class RoundRules {
  const RoundRules._();

  static const Duration countdown = Duration(seconds: 3);
  static const Duration resultPause = Duration(milliseconds: 1500);

  static const int defaultEntry = 1000;
  static const int entryStep = 100;

  static const int minTarget = 110;
  static const int maxTarget = CrashCurve.maxHundredths;
  static const int defaultTarget = 200;

  static int secondsLeft(Duration elapsed) {
    final remaining = countdown - elapsed;
    if (remaining <= Duration.zero) return 0;
    return (remaining.inMicroseconds / Duration.microsecondsPerSecond).ceil();
  }

  static int clampTarget(int target) => target.clamp(minTarget, maxTarget);

  static int stepTarget(int target, {required bool up}) {
    final step = _stepAt(up ? target : target - 1);
    final snapped = up ? (target ~/ step + 1) * step : ((target - 1) ~/ step) * step;
    return clampTarget(snapped);
  }

  static int _stepAt(int target) {
    if (target < 500) return 10;
    if (target < 2000) return 50;
    return 100;
  }
}
