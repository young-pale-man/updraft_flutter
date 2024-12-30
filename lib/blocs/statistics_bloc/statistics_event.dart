part of 'statistics_bloc.dart';

sealed class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object?> get props => [];
}

class InitializeStatisticsEV extends StatisticsEvent {}

class UpdateStatisticsEV extends StatisticsEvent {
  const UpdateStatisticsEV({required this.statisticsItem});

  final StatisticsItemModel statisticsItem;

  @override
  List<Object> get props => [statisticsItem];
}

class ClearStatisticsEV extends StatisticsEvent {}
