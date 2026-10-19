import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/utils/round_summary.dart';
import 'package:flutter_test/flutter_test.dart';

final time = DateTime(2026, 3, 14, 9);

RoundRecord jumped(int entry, int at, int crash) =>
    RoundRecord(time: time, entry: entry, multiplier: at, outcome: RoundOutcome.jumped, crash: crash);

RoundRecord flew(int entry, int crash) =>
    RoundRecord(time: time, entry: entry, multiplier: crash, outcome: RoundOutcome.flewAway, crash: crash);

RoundRecord left(int entry, int at) =>
    RoundRecord(time: time, entry: entry, multiplier: at, outcome: RoundOutcome.left);

void main() {
  test('an empty history has no best jump and no change', () {
    final summary = RoundSummary.of(const []);

    expect(summary.rounds, 0);
    expect(summary.jumps, 0);
    expect(summary.bestJump, isNull);
    expect(summary.change, 0);
    expect(summary.jumpRate, 0);
  });

  test('counts rounds and jumps, and finds the highest jump', () {
    final summary = RoundSummary.of([jumped(1000, 342, 514), flew(1000, 187), jumped(2000, 150, 162), left(500, 130)]);

    expect(summary.rounds, 4);
    expect(summary.jumps, 2);
    expect(summary.bestJump, 342);
  });

  test('adds up the change in whole cents', () {
    final summary = RoundSummary.of([jumped(1000, 342, 514), flew(1000, 187), jumped(2000, 150, 162), left(500, 130)]);

    expect(summary.change, 2420 - 1000 + 1000 - 500);
  });

  test('rounds the jump rate to a whole percent', () {
    expect(RoundSummary.of([jumped(100, 150, 200), flew(100, 120), flew(100, 110)]).jumpRate, 33);
    expect(RoundSummary.of([jumped(100, 150, 200), jumped(100, 150, 200), flew(100, 110)]).jumpRate, 67);
  });

  test('a plane that flew away high is not a jump', () {
    expect(RoundSummary.of([flew(1000, 9000), jumped(1000, 120, 130)]).bestJump, 120);
  });
}
