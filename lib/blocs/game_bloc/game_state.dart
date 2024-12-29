part of 'game_bloc.dart';

final class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

final class BetST extends GameState {}

final class CountDownST extends GameState {}

final class InGameST extends GameState {
  const InGameST({required this.deadline});

  final double deadline;
}

final class CashOutST extends GameState {}

final class GameFinishedST extends GameState {}
