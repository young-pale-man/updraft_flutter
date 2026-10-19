import 'package:updraft_flutter/utils/flight_curve.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('multiplier', () {
    test('starts at one', () {
      expect(FlightCurve.multiplierAt(Duration.zero), 100);
    });

    test('doubles every four seconds and passes a hundred before half a minute', () {
      expect(FlightCurve.multiplierAt(const Duration(seconds: 4)), 200);
      expect(FlightCurve.multiplierAt(const Duration(seconds: 8)), 400);
      expect(FlightCurve.multiplierAt(const Duration(seconds: 12)), 800);
      expect(FlightCurve.multiplierAt(const Duration(seconds: 27)), greaterThan(10000));
    });

    test('floors between whole hundredths', () {
      expect(FlightCurve.multiplierAt(const Duration(seconds: 2)), 141);
      expect(FlightCurve.multiplierAt(const Duration(seconds: 1)), 118);
      expect(FlightCurve.multiplierAt(const Duration(milliseconds: 57)), 100);
      expect(FlightCurve.multiplierAt(const Duration(milliseconds: 58)), 101);
    });

    test('never decreases as time passes', () {
      var previous = 0;
      for (var ms = 0; ms <= 30000; ms += 7) {
        final current = FlightCurve.multiplierAt(Duration(milliseconds: ms));
        expect(current, greaterThanOrEqualTo(previous));
        previous = current;
      }
    });

    test('depends only on elapsed time, not on how often it is sampled', () {
      const elapsed = Duration(milliseconds: 9137);
      final sampledOnce = FlightCurve.multiplierAt(elapsed);
      var sampledOften = 0;
      for (var ms = 0; ms <= elapsed.inMilliseconds; ms++) {
        sampledOften = FlightCurve.multiplierAt(Duration(milliseconds: ms));
      }
      expect(sampledOften, sampledOnce);
    });
  });
}
