import 'dart:convert';

import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/data/storages/local_balance_storage.dart';
import 'package:updraft_flutter/data/storages/local_rounds_storage.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<SharedPreferences> preferences([Map<String, Object> values = const {}]) {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferences.getInstance();
  }

  final jumped = RoundRecord(
    time: DateTime(2026, 3, 14, 9, 26),
    entry: 2000,
    multiplier: 342,
    outcome: RoundOutcome.jumped,
    crash: 510,
  );
  final flewAway = RoundRecord(
    time: DateTime(2026, 3, 14, 9, 27),
    entry: 1000,
    multiplier: 187,
    outcome: RoundOutcome.flewAway,
    crash: 187,
  );

  group('LocalBalanceStorage', () {
    test('reads nothing before anything was written', () async {
      expect(LocalBalanceStorage(await preferences()).read(), isNull);
    });

    test('reads back what it wrote', () async {
      final storage = LocalBalanceStorage(await preferences());

      await storage.write(48732);

      expect(storage.read(), 48732);
    });

    test('reads a damaged or negative balance as nothing', () async {
      for (final saved in <Object>['500', 12.5, true, -100]) {
        final storage = LocalBalanceStorage(await preferences({AppConst.balanceKey: saved}));

        expect(storage.read(), isNull, reason: '$saved');
      }
    });
  });

  group('LocalRoundsStorage', () {
    test('reads no rounds before anything was written', () async {
      expect(LocalRoundsStorage(await preferences()).read(), isEmpty);
    });

    test('reads back what it wrote, in order', () async {
      final storage = LocalRoundsStorage(await preferences());

      await storage.write([jumped, flewAway]);

      expect(storage.read(), [jumped, flewAway]);
    });

    test('forgets everything when cleared', () async {
      final storage = LocalRoundsStorage(await preferences());
      await storage.write([jumped]);

      await storage.clear();

      expect(storage.read(), isEmpty);
    });

    test('skips one damaged round instead of losing the rest', () async {
      final saved = json.encode([
        jumped.toJson(),
        {'entry': 'many'},
        7,
        flewAway.toJson(),
      ]);
      final storage = LocalRoundsStorage(await preferences({AppConst.roundsKey: saved}));

      expect(storage.read(), [jumped, flewAway]);
    });

    test('reads a damaged history as no rounds instead of failing', () async {
      for (final saved in <Object>['not json', '{"rounds": 1}', '"text"', '', 12]) {
        final storage = LocalRoundsStorage(await preferences({AppConst.roundsKey: saved}));

        expect(storage.read(), isEmpty, reason: '$saved');
      }
    });
  });
}
