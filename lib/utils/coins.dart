class Coins {
  const Coins._();

  static int payout(int entry, int multiplier) => entry * multiplier ~/ 100;

  static String format(int cents) {
    final whole = cents.abs() ~/ 100;
    final fraction = (cents.abs() % 100).toString().padLeft(2, '0');
    return '$whole.$fraction';
  }

  static String formatChange(int cents) {
    if (cents > 0) return '+${format(cents)}';
    if (cents < 0) return '−${format(cents)}';
    return format(cents);
  }

  static String formatMultiplier(int hundredths) => '${format(hundredths)}×';

  static String formatPercent(double fraction, {int decimals = 0}) => '${(fraction * 100).toStringAsFixed(decimals)}%';
}
