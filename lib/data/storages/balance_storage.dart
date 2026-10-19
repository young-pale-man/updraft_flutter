abstract interface class BalanceStorage {
  int? read();

  Future<void> write(int balance);
}
