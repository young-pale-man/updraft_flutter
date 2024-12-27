import 'package:updraft_flutter/data/storages/balance_storage.dart';

class BalanceProvider {
  final storage = BalanceStorage();

  double getBalance() => storage.getBalance();

  void updateBalance(double newBalance) => storage.updateBalance(newBalance);
}
