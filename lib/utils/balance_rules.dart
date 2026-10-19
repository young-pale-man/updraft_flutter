class BalanceRules {
  const BalanceRules._();

  static const int startingBalance = 50000;
  static const int refillAmount = 10000;
  static const int minEntry = 100;
  static const int maxEntry = 2500;

  static bool canEnter({required int balance, required int entry}) =>
      entry >= minEntry && entry <= maxEntry && entry <= balance;

  static int clampEntry({required int entry, required int balance}) {
    final ceiling = balance.clamp(minEntry, maxEntry);
    return entry.clamp(minEntry, ceiling);
  }

  static int takeEntry({required int balance, required int entry}) {
    if (!canEnter(balance: balance, entry: entry)) {
      throw ArgumentError.value(entry, 'entry', 'not covered by a balance of $balance');
    }
    return balance - entry;
  }

  static bool needsRefill(int balance) => balance < minEntry;

  static int refill(int balance) {
    if (!needsRefill(balance)) throw StateError('balance of $balance still covers an entry');
    return balance + refillAmount;
  }
}
