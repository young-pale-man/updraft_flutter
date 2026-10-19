import 'package:updraft_flutter/data/models/round_record.dart';

abstract interface class RoundsStorage {
  List<RoundRecord> read();

  Future<void> write(List<RoundRecord> rounds);

  Future<void> clear();
}
