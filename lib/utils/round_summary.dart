import 'package:updraft_flutter/data/models/round_record.dart';

class RoundSummary {
  const RoundSummary._({required this.rounds, required this.jumps, required this.bestJump, required this.change});

  factory RoundSummary.of(List<RoundRecord> records) {
    final jumped = records.where((record) => record.jumped);
    return RoundSummary._(
      rounds: records.length,
      jumps: jumped.length,
      bestJump: jumped.isEmpty ? null : jumped.map((record) => record.multiplier).reduce((a, b) => a > b ? a : b),
      change: records.fold(0, (sum, record) => sum + record.change),
    );
  }

  final int rounds;
  final int jumps;
  final int? bestJump;
  final int change;

  int get jumpRate => rounds == 0 ? 0 : (jumps * 100 / rounds).round();
}
