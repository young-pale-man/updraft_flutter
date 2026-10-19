import 'package:updraft_flutter/data/models/refill_record.dart';

abstract interface class RefillsStorage {
  List<RefillRecord> read();

  Future<void> write(List<RefillRecord> refills);

  Future<void> clear();
}
