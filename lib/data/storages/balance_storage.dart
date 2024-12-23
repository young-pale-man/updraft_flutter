import 'package:updraft_flutter/utils/constants.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';

class BalanceStorage {
  int getBalance() {
    final balance = sharedPreferences.getInt(AppConst.balanceStorageKey);

    if (balance != null) {
      return balance;
    } else {
      sharedPreferences.setInt(
        AppConst.balanceStorageKey,
        AppConst.defaultBalance,
      );
      return AppConst.defaultBalance;
    }
  }

  void updateBalance(int newBalance) {
    sharedPreferences.setInt(AppConst.balanceStorageKey, newBalance);
  }
}
