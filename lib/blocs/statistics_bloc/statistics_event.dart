part of 'statistics_bloc.dart';

sealed class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object?> get props => [];
}

final class RoundRecorded extends StatisticsEvent {
  const RoundRecorded(this.round);

  final RoundRecord round;

  @override
  List<Object?> get props => [round];
}

final class StatisticsCleared extends StatisticsEvent {
  const StatisticsCleared();
}
