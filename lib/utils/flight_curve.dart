import 'dart:math';

class FlightCurve {
  const FlightCurve._();

  static const Duration doublingTime = Duration(seconds: 4);

  static int multiplierAt(Duration elapsed) {
    final doublings = elapsed.inMicroseconds / doublingTime.inMicroseconds;
    return (100 * pow(2, doublings)).floor();
  }
}
