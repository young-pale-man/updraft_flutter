import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/in_memory_storages.dart';

void main() {
  group('BalanceBloc', () {
    test('starts from the stored balance', () {
      expect(BalanceBloc(storage: InMemoryBalanceStorage(1234)).state.balance, 1234);
    });

    test('starts a first launch with five hundred coins', () {
      expect(BalanceBloc(storage: InMemoryBalanceStorage()).state.balance, 50000);
    });

    late InMemoryBalanceStorage storage;

    blocTest<BalanceBloc, BalanceState>(
      'takes an entry and stores the new balance',
      setUp: () => storage = InMemoryBalanceStorage(5000),
      build: () => BalanceBloc(storage: storage),
      act: (bloc) => bloc.add(const EntryTaken(2000)),
      expect: () => [const BalanceState(balance: 3000)],
      verify: (_) => expect(storage.balance, 3000),
    );

    blocTest<BalanceBloc, BalanceState>(
      'refuses an entry the balance cannot cover',
      setUp: () => storage = InMemoryBalanceStorage(1000),
      build: () => BalanceBloc(storage: storage),
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
      build: () => BalanceBloc(storage: storage),
      act: (bloc) => bloc.add(const PayoutReceived(6840)),
      expect: () => [const BalanceState(balance: 9840)],
      verify: (_) => expect(storage.balance, 9840),
    );

    blocTest<BalanceBloc, BalanceState>(
      'emits every change, even when two in a row are equal',
      setUp: () => storage = InMemoryBalanceStorage(10000),
      build: () => BalanceBloc(storage: storage),
      act: (bloc) => bloc
        ..add(const EntryTaken(1000))
        ..add(const EntryTaken(1000)),
      expect: () => [const BalanceState(balance: 9000), const BalanceState(balance: 8000)],
    );

    blocTest<BalanceBloc, BalanceState>(
      'refills an empty balance to the starting amount',
      setUp: () => storage = InMemoryBalanceStorage(40),
      build: () => BalanceBloc(storage: storage),
      act: (bloc) => bloc.add(const BalanceRefilled()),
      expect: () => [const BalanceState(balance: 50000)],
      verify: (_) => expect(storage.balance, 50000),
    );

    blocTest<BalanceBloc, BalanceState>(
      'does not refill a balance that still covers an entry',
      setUp: () => storage = InMemoryBalanceStorage(100),
      build: () => BalanceBloc(storage: storage),
      act: (bloc) => bloc.add(const BalanceRefilled()),
      expect: () => <BalanceState>[],
    );
  });
}
