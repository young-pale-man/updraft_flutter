part of 'round_bloc.dart';

enum RoundPhase { ready, countdown, flying, jumped, crashed }

final class RoundState extends Equatable {
  const RoundState({
    this.phase = RoundPhase.ready,
    this.entry = RoundRules.defaultEntry,
    this.autoJump = false,
    this.target = RoundRules.defaultTarget,
    this.multiplier = 100,
    this.secondsLeft = 0,
    this.result,
    this.takeOffRevision = 0,
    this.jumpRevision = 0,
    this.crashRevision = 0,
  });

  final RoundPhase phase;
  final int entry;
  final bool autoJump;
  final int target;
  final int multiplier;
  final int secondsLeft;
  final RoundRecord? result;
  final int takeOffRevision;
  final int jumpRevision;
  final int crashRevision;

  bool get isReady => phase == RoundPhase.ready;

  bool get isFinished => phase == RoundPhase.jumped || phase == RoundPhase.crashed;

  int get exitRevision => jumpRevision + crashRevision;

  int get livePayout => Coins.payout(entry, multiplier);

  RoundState copyWith({
    RoundPhase? phase,
    int? entry,
    bool? autoJump,
    int? target,
    int? multiplier,
    int? secondsLeft,
    RoundRecord? Function()? result,
    int? takeOffRevision,
    int? jumpRevision,
    int? crashRevision,
  }) {
    return RoundState(
      phase: phase ?? this.phase,
      entry: entry ?? this.entry,
      autoJump: autoJump ?? this.autoJump,
      target: target ?? this.target,
      multiplier: multiplier ?? this.multiplier,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      result: result != null ? result() : this.result,
      takeOffRevision: takeOffRevision ?? this.takeOffRevision,
      jumpRevision: jumpRevision ?? this.jumpRevision,
      crashRevision: crashRevision ?? this.crashRevision,
    );
  }

  @override
  List<Object?> get props => [
    phase,
    entry,
    autoJump,
    target,
    multiplier,
    secondsLeft,
    result,
    takeOffRevision,
    jumpRevision,
    crashRevision,
  ];
}
