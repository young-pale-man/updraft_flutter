import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final time = DateTime(2026, 3, 14, 9, 26);

  group('outcome', () {
    test('a jump pays the entry times the multiplier', () {
      final record = RoundRecord(time: time, entry: 2000, multiplier: 342, outcome: RoundOutcome.jumped, crash: 510);

      expect(record.payout, 6840);
      expect(record.change, 4840);
    });

    test('a plane that flew away loses the entry', () {
      final record = RoundRecord(time: time, entry: 2000, multiplier: 187, outcome: RoundOutcome.flewAway, crash: 187);

      expect(record.payout, 0);
      expect(record.change, -2000);
    });

    test('leaving mid-flight loses the entry and hides the crash point', () {
      final record = RoundRecord(time: time, entry: 500, multiplier: 140, outcome: RoundOutcome.left);

      expect(record.payout, 0);
      expect(record.change, -500);
      expect(record.crash, isNull);
    });
  });

  group('json', () {
    test('survives the round trip', () {
      final records = [
        RoundRecord(time: time, entry: 2000, multiplier: 342, outcome: RoundOutcome.jumped, crash: 510),
        RoundRecord(time: time, entry: 150, multiplier: 100, outcome: RoundOutcome.flewAway, crash: 100),
        RoundRecord(time: time, entry: 500, multiplier: 140, outcome: RoundOutcome.left),
      ];

      for (final record in records) {
        expect(RoundRecord.fromJson(record.toJson()), record);
      }
    });

    test('reads anything malformed as no record', () {
      final valid = RoundRecord(
        time: time,
        entry: 2000,
        multiplier: 342,
        outcome: RoundOutcome.jumped,
        crash: 510,
      ).toJson();
      final damaged = <Object?>[
        null,
        'text',
        42,
        const <String, Object?>{},
        {...valid, 'time': 'yesterday'},
        {...valid, 'time': null},
        {...valid, 'entry': 20.5},
        {...valid, 'entry': '2000'},
        {...valid, 'entry': 0},
        {...valid, 'multiplier': 99},
        {...valid, 'multiplier': null},
        {...valid, 'outcome': 'won'},
        {...valid, 'outcome': 3},
        {...valid, 'crash': 'high'},
        {...valid, 'crash': 50},
        {...valid, 'crash': 300},
        {...valid, 'outcome': 'flewAway', 'crash': null},
      ];

      for (final json in damaged) {
        expect(RoundRecord.fromJson(json), isNull, reason: '$json');
      }
    });
  });
}
