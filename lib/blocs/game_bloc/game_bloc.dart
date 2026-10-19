import 'dart:math';

import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/crash_curve.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required BalanceBloc balanceBloc,
    required StatisticsBloc statisticsBloc,
    required Random random,
    required DateTime Function() clock,
  }) : _balance = balanceBloc,
       _statistics = statisticsBloc,
       _random = random,
       _clock = clock,
       super(BetST()) {
    on<BetEV>((event, emit) => emit(BetST()));
    on<StartCountDownEV>((event, emit) => emit(CountDownST()));
    on<StartGameEV>(_startGame);
    on<CashOutEV>(_cashOut);
    on<FinishGameEV>(_finishGame);
    on<CancelGameEV>(_cancelGame);
  }

  final BalanceBloc _balance;
  final StatisticsBloc _statistics;
  final Random _random;
  final DateTime Function() _clock;
  int _crash = 100;
  bool _wasWin = false;

  void _startGame(StartGameEV event, Emitter<GameState> emit) {
    _crash = const CrashCurve().draw(_random);
    _balance.add(EntryTaken(event.entry));
    emit(InGameST(deadline: _crash / 100));
  }

  void _cashOut(CashOutEV event, Emitter<GameState> emit) {
    _wasWin = true;
    _balance.add(PayoutReceived(Coins.payout(event.entry, event.multiplier)));
    _statistics.add(
      RoundRecorded(
        RoundRecord(
          time: _clock(),
          entry: event.entry,
          multiplier: event.multiplier,
          outcome: RoundOutcome.jumped,
          crash: _crash,
        ),
      ),
    );
    emit(CashOutST());
  }

  void _finishGame(FinishGameEV event, Emitter<GameState> emit) {
    if (!_wasWin) {
      _statistics.add(
        RoundRecorded(
          RoundRecord(
            time: _clock(),
            entry: event.entry,
            multiplier: _crash,
            outcome: RoundOutcome.flewAway,
            crash: _crash,
          ),
        ),
      );
    }
    _wasWin = false;
    emit(GameFinishedST());
  }

  void _cancelGame(CancelGameEV event, Emitter<GameState> emit) {
    if (state is! BetST && state is! CountDownST && state is! CashOutST) {
      _balance.add(PayoutReceived(event.entry));
    }
    emit(BetST());
  }
}
