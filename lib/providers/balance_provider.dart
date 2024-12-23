import 'package:updraft_flutter/data/storages/balance_storage.dart';

class BalanceProvider {
  final storage = BalanceStorage();

  int getBalance() => storage.getBalance();

  void updateBalance(int newBalance) => storage.updateBalance(newBalance);
}
