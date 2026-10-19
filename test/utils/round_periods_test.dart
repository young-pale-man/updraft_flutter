import 'package:updraft_flutter/data/models/refill_record.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/utils/round_periods.dart';
import 'package:flutter_test/flutter_test.dart';

RoundRecord at(DateTime time) =>
    RoundRecord(time: time, entry: 1000, multiplier: 150, outcome: RoundOutcome.flewAway, crash: 150);

void main() {
  final now = DateTime(2026, 3, 14, 9, 30);
  final rounds = [
    at(DateTime(2026, 1, 2, 12)),
    at(DateTime(2026, 2, 12, 23, 59)),
    at(DateTime(2026, 2, 13, 0, 1)),
    at(DateTime(2026, 3, 7, 23, 59)),
    at(DateTime(2026, 3, 8, 0, 0)),
    at(DateTime(2026, 3, 13, 22)),
    at(DateTime(2026, 3, 14, 0, 0)),
    at(DateTime(2026, 3, 14, 9, 10)),
  ];

  group('period', () {
    test('all time keeps everything', () {
      expect(RoundPeriod.allTime.select(rounds, now, timeOfRound), rounds);
    });

    test('today keeps only this calendar day', () {
      expect(RoundPeriod.today.select(rounds, now, timeOfRound), rounds.sublist(6));
    });

    test('a week keeps today and the six days before it', () {
      expect(RoundPeriod.week.select(rounds, now, timeOfRound), rounds.sublist(4));
    });

    test('a month keeps today and the twenty-nine days before it', () {
      expect(RoundPeriod.month.select(rounds, now, timeOfRound), rounds.sublist(2));
    });
  });

  group('days', () {
    test('groups rounds by calendar day, newest day and newest round first', () {
      final days = RoundDays.of(rounds.sublist(4), const []);

      expect(days.map((day) => day.date), [DateTime(2026, 3, 14), DateTime(2026, 3, 13), DateTime(2026, 3, 8)]);
      expect(days.first.entries, [RoundEntry(rounds[7]), RoundEntry(rounds[6])]);
    });

    test('has no days without rounds', () {
      expect(RoundDays.of(const [], const []), isEmpty);
    });

    test('places a refill among the rounds of its day by time', () {
      final refill = RefillRecord(time: DateTime(2026, 3, 14, 5), amount: 10000);
      final days = RoundDays.of(rounds.sublist(5), [refill]);

      expect(days.first.entries, [RoundEntry(rounds[7]), RefillEntry(refill), RoundEntry(rounds[6])]);
    });

    test('gives a refill on a day without rounds a day of its own', () {
      final refill = RefillRecord(time: DateTime(2026, 3, 10, 12), amount: 10000);

      final days = RoundDays.of(const [], [refill]);

      expect(days.single.date, DateTime(2026, 3, 10));
      expect(days.single.entries, [RefillEntry(refill)]);
    });
  });

  group('labels', () {
    test('write a clock time with two digits', () {
      expect(RoundDays.time(DateTime(2026, 3, 14, 9, 5)), '09:05');
      expect(RoundDays.time(DateTime(2026, 3, 14, 23, 59)), '23:59');
    });

    test('call today and yesterday by name and other days by date', () {
      expect(RoundDays.label(DateTime(2026, 3, 14), now), 'Today');
      expect(RoundDays.label(DateTime(2026, 3, 13), now), 'Yesterday');
      expect(RoundDays.label(DateTime(2026, 3, 8), now), '8 Mar 2026');
      expect(RoundDays.label(DateTime(2025, 12, 31), now), '31 Dec 2025');
    });
  });
}
