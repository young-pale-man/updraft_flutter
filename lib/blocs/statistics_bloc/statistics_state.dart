part of 'statistics_bloc.dart';

final class StatisticsState extends Equatable {
  const StatisticsState({required this.rounds, this.refills = const []});

  static const int historyLength = 15;

  final List<RoundRecord> rounds;
  final List<RefillRecord> refills;

  List<RoundRecord> get recentFlights =>
      rounds.reversed.where((round) => round.crash != null).take(historyLength).toList(growable: false);

  @override
  List<Object?> get props => [rounds, refills];
}
