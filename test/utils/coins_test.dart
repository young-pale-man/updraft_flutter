import 'package:updraft_flutter/utils/coins.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('payout', () {
    test('multiplies the entry by the multiplier in whole cents', () {
      expect(Coins.payout(1000, 342), 3420);
      expect(Coins.payout(2000, 100), 2000);
      expect(Coins.payout(2500, 10000), 250000);
    });

    test('rounds a fraction of a cent down', () {
      expect(Coins.payout(333, 150), 499);
      expect(Coins.payout(101, 199), 200);
    });
  });

  group('format', () {
    test('writes cents as coins with two decimals', () {
      expect(Coins.format(0), '0.00');
      expect(Coins.format(5), '0.05');
      expect(Coins.format(2450), '24.50');
      expect(Coins.format(123456), '1234.56');
    });

    test('signs a change in balance', () {
      expect(Coins.formatChange(6840), '+68.40');
      expect(Coins.formatChange(-2000), '−20.00');
      expect(Coins.formatChange(-5), '−0.05');
      expect(Coins.formatChange(0), '0.00');
    });

    test('writes a multiplier from hundredths', () {
      expect(Coins.formatMultiplier(100), '1.00×');
      expect(Coins.formatMultiplier(342), '3.42×');
      expect(Coins.formatMultiplier(10000), '100.00×');
    });
  });

  test('writes a share as a percent', () {
    expect(Coins.formatPercent(0.6), '60%');
    expect(Coins.formatPercent(1), '100%');
    expect(Coins.formatPercent(0.485, decimals: 1), '48.5%');
    expect(Coins.formatPercent(0.97000000001, decimals: 1), '97.0%');
    expect(Coins.formatPercent(0), '0%');
  });
}
