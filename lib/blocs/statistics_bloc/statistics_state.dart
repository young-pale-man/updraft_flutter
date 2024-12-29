part of 'statistics_bloc.dart';

final class StatisticsState extends Equatable {
  const StatisticsState({
    this.statisticsItemsList = const [],
  });

  final List<StatisticsItemModel> statisticsItemsList;

  StatisticsState copyWith({
    List<StatisticsItemModel>? statisticsItemsList,
  }) {
    return StatisticsState(
      statisticsItemsList: statisticsItemsList ?? this.statisticsItemsList,
    );
  }

  factory StatisticsState.initial() {
    return const StatisticsState();
  }

  @override
  List<Object?> get props => [statisticsItemsList];
}
