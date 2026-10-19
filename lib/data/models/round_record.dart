import 'package:updraft_flutter/utils/coins.dart';
import 'package:equatable/equatable.dart';

enum RoundOutcome { jumped, flewAway, left }

class RoundRecord extends Equatable {
  const RoundRecord({
    required this.time,
    required this.entry,
    required this.multiplier,
    required this.outcome,
    this.crash,
  });

  final DateTime time;
  final int entry;
  final int multiplier;
  final RoundOutcome outcome;
  final int? crash;

  bool get jumped => outcome == RoundOutcome.jumped;

  int get payout => jumped ? Coins.payout(entry, multiplier) : 0;

  int get change => payout - entry;

  Map<String, Object?> toJson() => {
    'time': time.toIso8601String(),
    'entry': entry,
    'multiplier': multiplier,
    'outcome': outcome.name,
    'crash': crash,
  };

  static RoundRecord? fromJson(Object? json) {
    if (json is! Map) return null;
    final time = json['time'] is String ? DateTime.tryParse(json['time'] as String) : null;
    final entry = json['entry'];
    final multiplier = json['multiplier'];
    final outcome = RoundOutcome.values.asNameMap()[json['outcome']];
    final crash = json['crash'];
    if (time == null || entry is! int || multiplier is! int || outcome == null) return null;
    if (crash != null && crash is! int) return null;
    final record = RoundRecord(
      time: time,
      entry: entry,
      multiplier: multiplier,
      outcome: outcome,
      crash: crash as int?,
    );
    return record._isConsistent ? record : null;
  }

  bool get _isConsistent {
    if (entry <= 0 || multiplier < 100) return false;
    return switch (outcome) {
      RoundOutcome.jumped => crash != null && crash! >= multiplier,
      RoundOutcome.flewAway => crash == multiplier,
      RoundOutcome.left => crash == null,
    };
  }

  @override
  List<Object?> get props => [time, entry, multiplier, outcome, crash];
}
