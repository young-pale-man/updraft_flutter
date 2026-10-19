import 'dart:math';

import 'package:updraft_flutter/data/storages/balance_storage.dart';
import 'package:updraft_flutter/data/storages/local_balance_storage.dart';
import 'package:updraft_flutter/data/storages/local_rounds_storage.dart';
import 'package:updraft_flutter/data/storages/rounds_storage.dart';
import 'package:updraft_flutter/utils/ticks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDependencies {
  const AppDependencies({
    required this.balanceStorage,
    required this.roundsStorage,
    required this.random,
    required this.ticks,
    required this.clock,
  });

  final BalanceStorage balanceStorage;
  final RoundsStorage roundsStorage;
  final Random random;
  final TickSource ticks;
  final DateTime Function() clock;
}

class DependencyInitializer {
  DependencyInitializer._();

  static Future<AppDependencies> initDependencies() async {
    final preferences = await SharedPreferences.getInstance();

    return AppDependencies(
      balanceStorage: LocalBalanceStorage(preferences),
      roundsStorage: LocalRoundsStorage(preferences),
      random: Random(),
      ticks: frameTicks,
      clock: DateTime.now,
    );
  }
}
