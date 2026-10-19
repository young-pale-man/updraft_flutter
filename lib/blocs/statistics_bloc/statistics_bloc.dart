import 'package:updraft_flutter/data/models/refill_record.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/data/storages/refills_storage.dart';
import 'package:updraft_flutter/data/storages/rounds_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc({required RoundsStorage storage, required RefillsStorage refillsStorage})
    : _storage = storage,
      _refillsStorage = refillsStorage,
      super(
        StatisticsState(rounds: List.unmodifiable(storage.read()), refills: List.unmodifiable(refillsStorage.read())),
      ) {
    on<RoundRecorded>(_record);
    on<RefillRecorded>(_recordRefill);
    on<StatisticsCleared>(_clear);
  }

  final RoundsStorage _storage;
  final RefillsStorage _refillsStorage;

  Future<void> _record(RoundRecorded event, Emitter<StatisticsState> emit) async {
    final rounds = List<RoundRecord>.unmodifiable([...state.rounds, event.round]);
    emit(StatisticsState(rounds: rounds, refills: state.refills));
    await _storage.write(rounds);
  }

  Future<void> _recordRefill(RefillRecorded event, Emitter<StatisticsState> emit) async {
    final refills = List<RefillRecord>.unmodifiable([...state.refills, event.refill]);
    emit(StatisticsState(rounds: state.rounds, refills: refills));
    await _refillsStorage.write(refills);
  }

  Future<void> _clear(StatisticsCleared event, Emitter<StatisticsState> emit) async {
    emit(const StatisticsState(rounds: [], refills: []));
    await _storage.clear();
    await _refillsStorage.clear();
  }
}
