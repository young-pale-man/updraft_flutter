import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/models/refill_record.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/in_memory_storages.dart';

final now = DateTime(2026, 3, 14, 10);

void main() {
  late StatisticsBloc statistics;

  setUp(() => statistics = StatisticsBloc(storage: InMemoryRoundsStorage(), refillsStorage: InMemoryRefillsStorage()));

  group('BalanceBloc', () {
    test('starts from the stored balance', () {
      expect(
        BalanceBloc(storage: InMemoryBalanceStorage(1234), statisticsBloc: statistics, clock: () => now).state.balance,
        1234,
      );
    });

    test('starts a first launch with five hundred coins', () {
      expect(
        BalanceBloc(storage: InMemoryBalanceStorage(), statisticsBloc: statistics, clock: () => now).state.balance,
        50000,
      );
    });

    late InMemoryBalanceStorage storage;

    blocTest<BalanceBloc, BalanceState>(
      'takes an entry and stores the new balance',
      setUp: () => storage = InMemoryBalanceStorage(5000),
      build: () => BalanceBloc(storage: storage, statisticsBloc: statistics, clock: () => now),
      act: (bloc) => bloc.add(const EntryTaken(2000)),
      expect: () => [const BalanceState(balance: 3000)],
      verify: (_) => expect(storage.balance, 3000),
    );

    blocTest<BalanceBloc, BalanceState>(
      'refuses an entry the balance cannot cover',
      setUp: () => storage = InMemoryBalanceStorage(1000),
      build: () => BalanceBloc(storage: storage, statisticsBloc: statistics, clock: () => now),
      act: (bloc) => bloc.add(const EntryTaken(2500)),
      expect: () => <BalanceState>[],
      verify: (bloc) {
        expect(bloc.state.balance, 1000);
        expect(storage.writes, 0);
      },
    );

    blocTest<BalanceBloc, BalanceState>(
      'adds a payout',
      setUp: () => storage = InMemoryBalanceStorage(3000),
      build: () => BalanceBloc(storage: storage, statisticsBloc: statistics, clock: () => now),
      act: (bloc) => bloc.add(const PayoutReceived(6840)),
      expect: () => [const BalanceState(balance: 9840)],
      verify: (_) => expect(storage.balance, 9840),
    );

    blocTest<BalanceBloc, BalanceState>(
      'emits every change, even when two in a row are equal',
      setUp: () => storage = InMemoryBalanceStorage(10000),
      build: () => BalanceBloc(storage: storage, statisticsBloc: statistics, clock: () => now),
      act: (bloc) => bloc
        ..add(const EntryTaken(1000))
        ..add(const EntryTaken(1000)),
      expect: () => [const BalanceState(balance: 9000), const BalanceState(balance: 8000)],
    );

    blocTest<BalanceBloc, BalanceState>(
      'refills an empty balance with a hundred coins and records it',
      setUp: () => storage = InMemoryBalanceStorage(40),
      build: () => BalanceBloc(storage: storage, statisticsBloc: statistics, clock: () => now),
      act: (bloc) => bloc.add(const BalanceRefilled()),
      expect: () => [const BalanceState(balance: 10040)],
      verify: (_) async {
        await Future<void>.delayed(Duration.zero);
        expect(storage.balance, 10040);
        expect(statistics.state.refills, [RefillRecord(time: now, amount: 10000)]);
      },
    );

    blocTest<BalanceBloc, BalanceState>(
      'does not refill a balance that still covers an entry',
      setUp: () => storage = InMemoryBalanceStorage(100),
      build: () => BalanceBloc(storage: storage, statisticsBloc: statistics, clock: () => now),
      act: (bloc) => bloc.add(const BalanceRefilled()),
      expect: () => <BalanceState>[],
      verify: (_) async {
        await Future<void>.delayed(Duration.zero);
        expect(statistics.state.refills, isEmpty);
      },
    );
  });
}
