import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/data/storages/balance_storage.dart';
import 'package:updraft_flutter/data/storages/rounds_storage.dart';

class InMemoryBalanceStorage implements BalanceStorage {
  InMemoryBalanceStorage([this.balance]);

  int? balance;
  int writes = 0;

  @override
  int? read() => balance;

  @override
  Future<void> write(int balance) async {
    this.balance = balance;
    writes++;
  }
}

class InMemoryRoundsStorage implements RoundsStorage {
  InMemoryRoundsStorage([List<RoundRecord> rounds = const []]) : rounds = List.of(rounds);

  List<RoundRecord> rounds;

  @override
  List<RoundRecord> read() => List.of(rounds);

  @override
  Future<void> write(List<RoundRecord> rounds) async => this.rounds = List.of(rounds);

  @override
  Future<void> clear() async => rounds = [];
}
