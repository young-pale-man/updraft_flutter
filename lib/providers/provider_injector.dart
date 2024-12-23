import 'package:updraft_flutter/providers/balance_provider.dart';
import 'package:updraft_flutter/providers/statistics_provider.dart';

class ProviderInjector {
  ProviderInjector._();
  static ProviderInjector instance = ProviderInjector._();

  final balanceProvider = BalanceProvider();
  final statisticsProvider = StatisticsProvider();
}
