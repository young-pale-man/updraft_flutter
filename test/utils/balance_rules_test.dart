import 'package:updraft_flutter/utils/balance_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('entry', () {
    test('is allowed between the minimum and the maximum when the balance covers it', () {
      expect(BalanceRules.canEnter(balance: 50000, entry: 100), isTrue);
      expect(BalanceRules.canEnter(balance: 50000, entry: 2500), isTrue);
      expect(BalanceRules.canEnter(balance: 2500, entry: 2500), isTrue);
    });

    test('is refused below the minimum, above the maximum or above the balance', () {
      expect(BalanceRules.canEnter(balance: 50000, entry: 99), isFalse);
      expect(BalanceRules.canEnter(balance: 50000, entry: 2510), isFalse);
      expect(BalanceRules.canEnter(balance: 1999, entry: 2000), isFalse);
      expect(BalanceRules.canEnter(balance: 0, entry: 100), isFalse);
    });

    test('is clamped into what the balance and the limits allow', () {
      expect(BalanceRules.clampEntry(entry: 5000, balance: 50000), 2500);
      expect(BalanceRules.clampEntry(entry: 50, balance: 50000), 100);
      expect(BalanceRules.clampEntry(entry: 2000, balance: 730), 730);
      expect(BalanceRules.clampEntry(entry: 2000, balance: 40), 100);
    });
  });

  group('balance', () {
    test('loses exactly the entry at take-off', () {
      expect(BalanceRules.takeEntry(balance: 50000, entry: 2000), 48000);
      expect(BalanceRules.takeEntry(balance: 2000, entry: 2000), 0);
    });

    test('never goes negative', () {
      expect(() => BalanceRules.takeEntry(balance: 1999, entry: 2000), throwsArgumentError);
      expect(() => BalanceRules.takeEntry(balance: 0, entry: 100), throwsArgumentError);
    });

    test('needs a refill only when it cannot cover the minimum entry', () {
      expect(BalanceRules.needsRefill(99), isTrue);
      expect(BalanceRules.needsRefill(0), isTrue);
      expect(BalanceRules.needsRefill(100), isFalse);
    });

    test('starts at five hundred coins', () {
      expect(BalanceRules.startingBalance, 50000);
    });

    test('refills by a hundred coins on top of what is left', () {
      expect(BalanceRules.refillAmount, 10000);
      expect(BalanceRules.refill(37), 10037);
      expect(BalanceRules.refill(0), 10000);
    });

    test('is not refilled while it can still cover an entry', () {
      expect(() => BalanceRules.refill(100), throwsStateError);
    });
  });
}
