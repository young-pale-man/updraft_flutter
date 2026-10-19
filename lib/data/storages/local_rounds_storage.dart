import 'dart:convert';

import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/data/storages/rounds_storage.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRoundsStorage implements RoundsStorage {
  const LocalRoundsStorage(this._preferences);

  final SharedPreferences _preferences;

  @override
  List<RoundRecord> read() {
    final stored = _preferences.get(AppConst.roundsKey);
    if (stored is! String) return const [];
    try {
      final decoded = json.decode(stored);
      if (decoded is! List) return const [];
      return decoded.map(RoundRecord.fromJson).nonNulls.toList();
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> write(List<RoundRecord> rounds) async {
    await _preferences.setString(AppConst.roundsKey, json.encode([for (final round in rounds) round.toJson()]));
  }

  @override
  Future<void> clear() async {
    await _preferences.remove(AppConst.roundsKey);
  }
}
