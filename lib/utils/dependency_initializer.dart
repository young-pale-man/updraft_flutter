import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final injector = GetIt.instance;
late final SharedPreferences sharedPreferences;

class DependencyInitializer {
  DependencyInitializer._();

  static Future<void> initDependencies() async {
    sharedPreferences = await SharedPreferences.getInstance();

    injector.registerSingleton(BalanceBloc());
    injector.registerSingleton(StatisticsBloc());
  }
}
