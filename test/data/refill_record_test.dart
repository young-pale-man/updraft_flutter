import 'package:updraft_flutter/data/models/refill_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final time = DateTime(2026, 3, 14, 9, 26);

  test('survives the round trip through json', () {
    final record = RefillRecord(time: time, amount: 10000);

    expect(RefillRecord.fromJson(record.toJson()), record);
  });

  test('reads anything malformed as no record', () {
    final valid = RefillRecord(time: time, amount: 10000).toJson();
    final damaged = <Object?>[
      null,
      'text',
      const <String, Object?>{},
      {...valid, 'time': 'later'},
      {...valid, 'amount': '100'},
      {...valid, 'amount': 0},
      {...valid, 'amount': -100},
    ];

    for (final json in damaged) {
      expect(RefillRecord.fromJson(json), isNull, reason: '$json');
    }
  });
}
