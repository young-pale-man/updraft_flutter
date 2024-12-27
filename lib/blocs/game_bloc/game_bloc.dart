import 'dart:math';

import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(BetST()) {
    on<BetEV>((event, emit) => emit(BetST()));
    on<StartCountDownEV>((event, emit) => emit(CountDownST()));
    on<StartGameEV>(_startGame);
    on<CashOutEV>(_cashOut);
    on<FinishGameEV>((event, emit) => emit(GameFinishedST()));
  }

  Future<void> _startGame(
    StartGameEV event,
    Emitter<GameState> emit,
  ) async {
    final double deadline = 1.0 + (Random().nextDouble() * (AppConst.maxCoef - 1));
    emit(InGameST(deadline: deadline));
  }

  Future<void> _cashOut(
    CashOutEV event,
    Emitter<GameState> emit,
  ) async {
    final winAmount = event.bet * event.coef;
    emit(CashOutST(winAmount: winAmount));
  }
}
