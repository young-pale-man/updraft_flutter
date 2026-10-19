part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class BetEV extends GameEvent {}

class StartCountDownEV extends GameEvent {}

class StartGameEV extends GameEvent {
  const StartGameEV({required this.entry});

  final int entry;
}

class CashOutEV extends GameEvent {
  const CashOutEV({required this.entry, required this.multiplier});

  final int entry;
  final int multiplier;
}

class FinishGameEV extends GameEvent {
  const FinishGameEV({required this.entry});

  final int entry;
}

class CancelGameEV extends GameEvent {
  const CancelGameEV({required this.entry});

  final int entry;
}
