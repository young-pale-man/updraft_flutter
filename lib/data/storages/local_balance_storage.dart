import 'package:updraft_flutter/data/storages/balance_storage.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalBalanceStorage implements BalanceStorage {
  const LocalBalanceStorage(this._preferences);

  final SharedPreferences _preferences;

  @override
  int? read() {
    final stored = _preferences.get(AppConst.balanceKey);
    return stored is int && stored >= 0 ? stored : null;
  }

  @override
  Future<void> write(int balance) async {
    await _preferences.setInt(AppConst.balanceKey, balance);
  }
}
