import 'dart:math';

import 'package:updraft_flutter/utils/crash_curve.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixed_random.dart';

void main() {
  const curve = CrashCurve();

  group('crash point', () {
    test('turns a uniform draw into hundredths of the multiplier', () {
      expect(curve.draw(FixedRandom([0.5])), 194);
      expect(curve.draw(FixedRandom([0.75])), 388);
      expect(curve.draw(FixedRandom([0.9])), 970);
      expect(curve.draw(FixedRandom([0.96875])), 3104);
    });

    test('never falls below one', () {
      expect(curve.draw(FixedRandom([0])), 100);
      expect(curve.draw(FixedRandom([0.02])), 100);
    });

    test('is capped at the maximum', () {
      expect(curve.draw(FixedRandom([0.9999])), CrashCurve.maxHundredths);
      expect(curve.draw(FixedRandom([0.999999])), CrashCurve.maxHundredths);
    });

    test('stays within its bounds for every seed', () {
      final random = Random(7);
      for (var round = 0; round < 100000; round++) {
        expect(curve.draw(random), inInclusiveRange(100, CrashCurve.maxHundredths));
      }
    });

    test('repeats for the same seed', () {
      final first = Random(42);
      final second = Random(42);
      for (var round = 0; round < 1000; round++) {
        expect(curve.draw(first), curve.draw(second));
      }
    });
  });

  group('fairness', () {
    const rounds = 1000000;
    const targets = [150, 200, 500, 1000];

    late List<int> crashes;

    setUpAll(() {
      final random = Random(2024);
      crashes = List.generate(rounds, (_) => curve.draw(random));
    });

    test('reaches each target with probability 0.97 over the target', () {
      for (final target in targets) {
        final expected = 97 / target;
        final reached = crashes.where((crash) => crash >= target).length / rounds;
        final error = 4 * sqrt(expected * (1 - expected) / rounds);

        expect(reached, closeTo(expected, error), reason: 'target $target');
      }
    });

    test('states the chance to reach a target that the draws actually show', () {
      for (final target in targets) {
        final sampled = crashes.where((crash) => crash >= target).length / rounds;
        final stated = CrashCurve.chanceToReach(target);
        final error = 4 * sqrt(stated * (1 - stated) / rounds);

        expect(sampled, closeTo(stated, error), reason: 'target $target');
      }
      expect(CrashCurve.chanceToReach(100), 1);
      expect(CrashCurve.chanceToReach(200), closeTo(0.485, 1e-12));
    });

    test('returns 97% of the entry at every target, within one point', () {
      for (final target in targets) {
        final returned = crashes.where((crash) => crash >= target).length * target / 100 / rounds;

        expect(returned, closeTo(0.97, 0.01), reason: 'target $target');
      }
    });
  });
}
