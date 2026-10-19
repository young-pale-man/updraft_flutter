import 'package:updraft_flutter/utils/constants.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';

class BalanceStorage {
  double getBalance() {
    final balance = sharedPreferences.getDouble(AppConst.balanceStorageKey);

    if (balance != null) {
      return balance;
    } else {
      sharedPreferences.setDouble(AppConst.balanceStorageKey, AppConst.defaultBalance);
      return AppConst.defaultBalance;
    }
  }

  void updateBalance(double newBalance) {
    sharedPreferences.setDouble(AppConst.balanceStorageKey, newBalance);
  }
}
