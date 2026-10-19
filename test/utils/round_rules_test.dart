import 'package:updraft_flutter/utils/round_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('countdown', () {
    test('shows whole seconds left, rounded up', () {
      expect(RoundRules.secondsLeft(Duration.zero), 3);
      expect(RoundRules.secondsLeft(const Duration(milliseconds: 999)), 3);
      expect(RoundRules.secondsLeft(const Duration(milliseconds: 1000)), 2);
      expect(RoundRules.secondsLeft(const Duration(milliseconds: 2001)), 1);
      expect(RoundRules.secondsLeft(const Duration(seconds: 3)), 0);
      expect(RoundRules.secondsLeft(const Duration(seconds: 5)), 0);
    });
  });

  group('target steps', () {
    test('move by a tenth below five', () {
      expect(RoundRules.stepTarget(200, up: true), 210);
      expect(RoundRules.stepTarget(200, up: false), 190);
      expect(RoundRules.stepTarget(490, up: true), 500);
    });

    test('move by a half from five to twenty', () {
      expect(RoundRules.stepTarget(500, up: true), 550);
      expect(RoundRules.stepTarget(500, up: false), 490);
      expect(RoundRules.stepTarget(1950, up: true), 2000);
    });

    test('move by a whole above twenty', () {
      expect(RoundRules.stepTarget(2000, up: true), 2100);
      expect(RoundRules.stepTarget(2000, up: false), 1950);
      expect(RoundRules.stepTarget(2100, up: false), 2000);
    });

    test('snap a value between steps onto the grid', () {
      expect(RoundRules.stepTarget(523, up: true), 550);
      expect(RoundRules.stepTarget(523, up: false), 500);
      expect(RoundRules.stepTarget(2040, up: true), 2100);
    });

    test('stay within the limits', () {
      expect(RoundRules.stepTarget(110, up: false), 110);
      expect(RoundRules.stepTarget(10000, up: true), 10000);
    });
  });
}
