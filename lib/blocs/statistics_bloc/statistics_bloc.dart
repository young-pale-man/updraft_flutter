import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/data/storages/rounds_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc({required RoundsStorage storage})
    : _storage = storage,
      super(StatisticsState(rounds: List.unmodifiable(storage.read()))) {
    on<RoundRecorded>(_record);
    on<StatisticsCleared>(_clear);
  }

  final RoundsStorage _storage;

  Future<void> _record(RoundRecorded event, Emitter<StatisticsState> emit) async {
    final rounds = List<RoundRecord>.unmodifiable([...state.rounds, event.round]);
    emit(StatisticsState(rounds: rounds));
    await _storage.write(rounds);
  }

  Future<void> _clear(StatisticsCleared event, Emitter<StatisticsState> emit) async {
    emit(const StatisticsState(rounds: []));
    await _storage.clear();
  }
}
