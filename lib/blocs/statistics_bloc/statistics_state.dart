part of 'statistics_bloc.dart';

final class StatisticsState extends Equatable {
  const StatisticsState({required this.rounds});

  static const int historyLength = 15;

  final List<RoundRecord> rounds;

  List<RoundRecord> get recentFlights =>
      rounds.reversed.where((round) => round.crash != null).take(historyLength).toList(growable: false);

  @override
  List<Object?> get props => [rounds];
}
