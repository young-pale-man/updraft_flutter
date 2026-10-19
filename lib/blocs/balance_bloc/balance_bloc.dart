import 'package:updraft_flutter/data/storages/balance_storage.dart';
import 'package:updraft_flutter/utils/balance_rules.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  BalanceBloc({required BalanceStorage storage})
    : _storage = storage,
      super(BalanceState(balance: storage.read() ?? BalanceRules.startingBalance)) {
    on<EntryTaken>(_takeEntry);
    on<PayoutReceived>(_receivePayout);
    on<BalanceRefilled>(_refill);
  }

  final BalanceStorage _storage;

  Future<void> _takeEntry(EntryTaken event, Emitter<BalanceState> emit) async {
    if (!BalanceRules.canEnter(balance: state.balance, entry: event.entry)) return;
    await _save(emit, BalanceRules.takeEntry(balance: state.balance, entry: event.entry));
  }

  Future<void> _receivePayout(PayoutReceived event, Emitter<BalanceState> emit) async {
    if (event.payout <= 0) return;
    await _save(emit, state.balance + event.payout);
  }

  Future<void> _refill(BalanceRefilled event, Emitter<BalanceState> emit) async {
    if (!BalanceRules.needsRefill(state.balance)) return;
    await _save(emit, BalanceRules.refill(state.balance));
  }

  Future<void> _save(Emitter<BalanceState> emit, int balance) async {
    emit(BalanceState(balance: balance));
    await _storage.write(balance);
  }
}
