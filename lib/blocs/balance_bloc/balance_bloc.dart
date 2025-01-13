import 'package:updraft_flutter/providers/provider_injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  BalanceBloc() : super(BalanceState.initial()) {
    on<InitializeBalanceEV>(_initializeBalance);
    on<UpdateBalanceEV>(_updateBalance);
    _initialize();
  }

  final _balanceStorage = ProviderInjector.instance.balanceProvider;

  _initialize() => add(InitializeBalanceEV());

  Future<void> _initializeBalance(
    InitializeBalanceEV event,
    Emitter<BalanceState> emit,
  ) async {
    final userBalance = _balanceStorage.getBalance();
    emit(state.copyWith(balance: userBalance));
  }

  Future<void> _updateBalance(
    UpdateBalanceEV event,
    Emitter<BalanceState> emit,
  ) async {
    double userBalance = state.balance;
    userBalance += event.difference;
    _balanceStorage.updateBalance(userBalance);
    emit(state.copyWith(
      balance: userBalance,
      addedDifference: event.difference,
    ));
  }
}
