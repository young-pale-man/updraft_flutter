import 'dart:convert';

import 'package:updraft_flutter/data/models/refill_record.dart';
import 'package:updraft_flutter/data/storages/refills_storage.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRefillsStorage implements RefillsStorage {
  const LocalRefillsStorage(this._preferences);

  final SharedPreferences _preferences;

  @override
  List<RefillRecord> read() {
    final stored = _preferences.get(AppConst.refillsKey);
    if (stored is! String) return const [];
    try {
      final decoded = json.decode(stored);
      if (decoded is! List) return const [];
      return decoded.map(RefillRecord.fromJson).nonNulls.toList();
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> write(List<RefillRecord> refills) async {
    await _preferences.setString(AppConst.refillsKey, json.encode([for (final refill in refills) refill.toJson()]));
  }

  @override
  Future<void> clear() async {
    await _preferences.remove(AppConst.refillsKey);
  }
}
