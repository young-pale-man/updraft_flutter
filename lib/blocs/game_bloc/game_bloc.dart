import 'dart:math';

import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/models/statistics_item_model.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
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
    on<FinishGameEV>(_finishGame);
    on<CancelGameEV>(_cancelGame);
  }

  final balance = injector<BalanceBloc>();
  final statistics = injector<StatisticsBloc>();

  bool wasWin = false;

  Future<void> _startGame(StartGameEV event, Emitter<GameState> emit) async {
    final double deadline = AppConst.minCoef + (Random().nextDouble() * (AppConst.maxCoef - AppConst.minCoef));

    balance.add(UpdateBalanceEV(difference: -event.bet));
    emit(InGameST(deadline: deadline));
  }

  Future<void> _cashOut(CashOutEV event, Emitter<GameState> emit) async {
    final winAmount = event.bet * event.coef;
    wasWin = true;

    final stat = _getGameStat(event.bet, event.coef);

    balance.add(UpdateBalanceEV(difference: winAmount));
    statistics.add(UpdateStatisticsEV(statisticsItem: stat));
    emit(CashOutST());
  }

  Future<void> _finishGame(FinishGameEV event, Emitter<GameState> emit) async {
    if (!wasWin) {
      final stat = _getGameStat(event.bet, event.coef);
      statistics.add(UpdateStatisticsEV(statisticsItem: stat));
    }

    wasWin = false;
    emit(GameFinishedST());
  }

  Future<void> _cancelGame(CancelGameEV event, Emitter<GameState> emit) async {
    if (state is! BetST && state is! CountDownST && state is! CashOutST) {
      balance.add(UpdateBalanceEV(difference: event.bet));
    }

    emit(BetST());
  }

  StatisticsItemModel _getGameStat(double bet, double coef) => StatisticsItemModel(
    bet: bet,
    coef: coef,
    date: DateTime.now(),
    isWin: wasWin,
    result: wasWin ? (bet * coef) : bet,
  );
}
