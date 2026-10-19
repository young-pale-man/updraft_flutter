import 'dart:async';
import 'dart:math';

import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/utils/balance_rules.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/crash_curve.dart';
import 'package:updraft_flutter/utils/flight_curve.dart';
import 'package:updraft_flutter/utils/round_rules.dart';
import 'package:updraft_flutter/utils/ticks.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'round_event.dart';
part 'round_state.dart';

class RoundBloc extends Bloc<RoundEvent, RoundState> {
  RoundBloc({
    required BalanceBloc balanceBloc,
    required StatisticsBloc statisticsBloc,
    required Random random,
    required TickSource ticks,
    required DateTime Function() clock,
  }) : _balance = balanceBloc,
       _statistics = statisticsBloc,
       _random = random,
       _ticks = ticks,
       _clock = clock,
       super(
         RoundState(
           entry: BalanceRules.clampEntry(entry: RoundRules.defaultEntry, balance: balanceBloc.state.balance),
         ),
       ) {
    on<EntryChanged>(_changeEntry);
    on<AutoJumpChanged>(_changeAutoJump);
    on<TargetChanged>(_changeTarget);
    on<PlayPressed>(_play);
    on<CountdownCancelled>(_cancelCountdown);
    on<JumpPressed>(_jumpPressed);
    on<RoundLeft>(_leave);
    on<_CountdownTicked>(_countdownTicked);
    on<_FlightTicked>(_flightTicked);
    on<_ResultTicked>(_resultTicked);
  }

  final BalanceBloc _balance;
  final StatisticsBloc _statistics;
  final Random _random;
  final TickSource _ticks;
  final DateTime Function() _clock;

  StreamSubscription<Duration>? _clockSubscription;
  int _crash = 100;

  int get _balanceNow => _balance.state.balance;

  void _changeEntry(EntryChanged event, Emitter<RoundState> emit) {
    if (!state.isReady) return;
    emit(
      state.copyWith(
        entry: BalanceRules.clampEntry(entry: event.entry, balance: _balanceNow),
      ),
    );
  }

  void _changeAutoJump(AutoJumpChanged event, Emitter<RoundState> emit) {
    if (!state.isReady) return;
    emit(state.copyWith(autoJump: event.enabled));
  }

  void _changeTarget(TargetChanged event, Emitter<RoundState> emit) {
    if (!state.isReady) return;
    emit(state.copyWith(target: RoundRules.clampTarget(event.target)));
  }

  void _play(PlayPressed event, Emitter<RoundState> emit) {
    if (!state.isReady || !BalanceRules.canEnter(balance: _balanceNow, entry: state.entry)) return;
    emit(state.copyWith(phase: RoundPhase.countdown, secondsLeft: RoundRules.secondsLeft(Duration.zero)));
    _listen((elapsed) => add(_CountdownTicked(elapsed)));
  }

  void _cancelCountdown(CountdownCancelled event, Emitter<RoundState> emit) {
    if (state.phase != RoundPhase.countdown) return;
    _stopClock();
    emit(_ready());
  }

  void _countdownTicked(_CountdownTicked event, Emitter<RoundState> emit) {
    if (state.phase != RoundPhase.countdown) return;
    final secondsLeft = RoundRules.secondsLeft(event.elapsed);
    if (secondsLeft > 0) {
      emit(state.copyWith(secondsLeft: secondsLeft));
      return;
    }
    _stopClock();
    if (!BalanceRules.canEnter(balance: _balanceNow, entry: state.entry)) {
      emit(_ready());
      return;
    }
    _crash = const CrashCurve().draw(_random);
    _balance.add(EntryTaken(state.entry));
    emit(
      state.copyWith(
        phase: RoundPhase.flying,
        secondsLeft: 0,
        multiplier: 100,
        takeOffRevision: state.takeOffRevision + 1,
      ),
    );
    _listen((elapsed) => add(_FlightTicked(elapsed)));
  }

  void _flightTicked(_FlightTicked event, Emitter<RoundState> emit) {
    if (state.phase != RoundPhase.flying) return;
    final multiplier = FlightCurve.multiplierAt(event.elapsed);
    final target = state.target;
    if (state.autoJump && multiplier >= target && target <= _crash) {
      _jump(emit, target);
    } else if (multiplier >= _crash) {
      _crashed(emit);
    } else if (multiplier != state.multiplier) {
      emit(state.copyWith(multiplier: multiplier));
    }
  }

  void _jumpPressed(JumpPressed event, Emitter<RoundState> emit) {
    if (state.phase != RoundPhase.flying) return;
    _jump(emit, state.multiplier);
  }

  void _jump(Emitter<RoundState> emit, int multiplier) {
    final record = RoundRecord(
      time: _clock(),
      entry: state.entry,
      multiplier: multiplier,
      outcome: RoundOutcome.jumped,
      crash: _crash,
    );
    _balance.add(PayoutReceived(record.payout));
    _finish(
      emit,
      record,
      state.copyWith(phase: RoundPhase.jumped, multiplier: multiplier, jumpRevision: state.jumpRevision + 1),
    );
  }

  void _crashed(Emitter<RoundState> emit) {
    final record = RoundRecord(
      time: _clock(),
      entry: state.entry,
      multiplier: _crash,
      outcome: RoundOutcome.flewAway,
      crash: _crash,
    );
    _finish(
      emit,
      record,
      state.copyWith(phase: RoundPhase.crashed, multiplier: _crash, crashRevision: state.crashRevision + 1),
    );
  }

  void _finish(Emitter<RoundState> emit, RoundRecord record, RoundState finished) {
    _stopClock();
    _statistics.add(RoundRecorded(record));
    emit(finished.copyWith(result: () => record));
    _listen((elapsed) => add(_ResultTicked(elapsed)));
  }

  void _resultTicked(_ResultTicked event, Emitter<RoundState> emit) {
    if (!state.isFinished || event.elapsed < RoundRules.resultPause) return;
    _stopClock();
    emit(_ready());
  }

  void _leave(RoundLeft event, Emitter<RoundState> emit) {
    if (state.isReady) return;
    if (state.phase == RoundPhase.flying) {
      _statistics.add(
        RoundRecorded(
          RoundRecord(time: _clock(), entry: state.entry, multiplier: state.multiplier, outcome: RoundOutcome.left),
        ),
      );
    }
    _stopClock();
    emit(_ready());
  }

  RoundState _ready() {
    return state.copyWith(
      phase: RoundPhase.ready,
      entry: BalanceRules.clampEntry(entry: state.entry, balance: _balanceNow),
      multiplier: 100,
      secondsLeft: 0,
      result: () => null,
    );
  }

  void _listen(void Function(Duration elapsed) onTick) {
    _stopClock();
    _clockSubscription = _ticks().listen(onTick);
  }

  void _stopClock() {
    unawaited(_clockSubscription?.cancel());
    _clockSubscription = null;
  }

  @override
  Future<void> close() async {
    await _clockSubscription?.cancel();
    return super.close();
  }
}
