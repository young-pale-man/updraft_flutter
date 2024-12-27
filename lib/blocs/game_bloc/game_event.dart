part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class BetEV extends GameEvent {}

class StartCountDownEV extends GameEvent {}

class StartGameEV extends GameEvent {}

class CashOutEV extends GameEvent {
  const CashOutEV({required this.bet, required this.coef});
  final double bet;
  final double coef;
}

class FinishGameEV extends GameEvent {}
