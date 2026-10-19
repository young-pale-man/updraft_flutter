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
      expect(RoundPeriod.allTime.select(rounds, now), rounds);
    });

    test('today keeps only this calendar day', () {
      expect(RoundPeriod.today.select(rounds, now), rounds.sublist(6));
    });

    test('a week keeps today and the six days before it', () {
      expect(RoundPeriod.week.select(rounds, now), rounds.sublist(4));
    });

    test('a month keeps today and the twenty-nine days before it', () {
      expect(RoundPeriod.month.select(rounds, now), rounds.sublist(2));
    });
  });

  group('days', () {
    test('groups rounds by calendar day, newest day and newest round first', () {
      final days = RoundDays.of(rounds.sublist(4));

      expect(days.map((day) => day.date), [DateTime(2026, 3, 14), DateTime(2026, 3, 13), DateTime(2026, 3, 8)]);
      expect(days.first.rounds, [rounds[7], rounds[6]]);
    });

    test('has no days without rounds', () {
      expect(RoundDays.of(const []), isEmpty);
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
