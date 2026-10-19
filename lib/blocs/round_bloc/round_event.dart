part of 'round_bloc.dart';

sealed class RoundEvent extends Equatable {
  const RoundEvent();

  @override
  List<Object?> get props => [];
}

final class EntryChanged extends RoundEvent {
  const EntryChanged(this.entry);

  final int entry;

  @override
  List<Object?> get props => [entry];
}

final class AutoJumpChanged extends RoundEvent {
  const AutoJumpChanged(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class TargetChanged extends RoundEvent {
  const TargetChanged(this.target);

  final int target;

  @override
  List<Object?> get props => [target];
}

final class PlayPressed extends RoundEvent {
  const PlayPressed();
}

final class CountdownCancelled extends RoundEvent {
  const CountdownCancelled();
}

final class JumpPressed extends RoundEvent {
  const JumpPressed();
}

final class RoundLeft extends RoundEvent {
  const RoundLeft();
}

final class _CountdownTicked extends RoundEvent {
  const _CountdownTicked(this.elapsed);

  final Duration elapsed;

  @override
  List<Object?> get props => [elapsed];
}

final class _FlightTicked extends RoundEvent {
  const _FlightTicked(this.elapsed);

  final Duration elapsed;

  @override
  List<Object?> get props => [elapsed];
}

final class _ResultTicked extends RoundEvent {
  const _ResultTicked(this.elapsed);

  final Duration elapsed;

  @override
  List<Object?> get props => [elapsed];
}
