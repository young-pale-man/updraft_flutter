import 'package:updraft_flutter/data/models/statistics_item_model.dart';
import 'package:updraft_flutter/providers/provider_injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc() : super(StatisticsState.initial()) {
    on<InitializeStatisticsEV>(_initializeStatistics);
    on<UpdateStatisticsEV>(_updateStatistics);
    _initialize();
  }

  final _statisticsStorage = ProviderInjector.instance.statisticsProvider;

  void _initialize() => add(InitializeStatisticsEV());

  Future<void> _initializeStatistics(
    InitializeStatisticsEV event,
    Emitter<StatisticsState> emit,
  ) async {
    final statisticsItemsList = _statisticsStorage.getStatistics();

    emit(state.copyWith(statisticsItemsList: statisticsItemsList));
  }

  Future<void> _updateStatistics(
    UpdateStatisticsEV event,
    Emitter<StatisticsState> emit,
  ) async {
    List<StatisticsItemModel> statisticsItemsList = state.statisticsItemsList;

    statisticsItemsList.add(event.statisticsItem);

    _statisticsStorage.saveStatistics(statisticsItemsList);
    emit(state.copyWith(statisticsItemsList: statisticsItemsList));
  }
}
