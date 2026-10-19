import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/models/refill_record.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/in_memory_storages.dart';

RoundRecord round({int minute = 0, RoundOutcome outcome = RoundOutcome.flewAway, int multiplier = 187, int? crash}) {
  return RoundRecord(
    time: DateTime(2026, 3, 14, 9, minute),
    entry: 1000,
    multiplier: multiplier,
    outcome: outcome,
    crash: outcome == RoundOutcome.left ? null : (crash ?? multiplier),
  );
}

void main() {
  group('StatisticsBloc', () {
    late InMemoryRoundsStorage storage;
    late InMemoryRefillsStorage refills;

    setUp(() => refills = InMemoryRefillsStorage());

    test('starts from the stored rounds', () {
      final bloc = StatisticsBloc(
        storage: InMemoryRoundsStorage([round(), round(minute: 1)]),
        refillsStorage: InMemoryRefillsStorage(),
      );

      expect(bloc.state.rounds, [round(), round(minute: 1)]);
    });

    blocTest<StatisticsBloc, StatisticsState>(
      'emits for every recorded round, even two identical ones',
      setUp: () => storage = InMemoryRoundsStorage(),
      build: () => StatisticsBloc(storage: storage, refillsStorage: refills),
      act: (bloc) => bloc
        ..add(RoundRecorded(round()))
        ..add(RoundRecorded(round())),
      expect: () => [
        StatisticsState(rounds: [round()]),
        StatisticsState(rounds: [round(), round()]),
      ],
      verify: (_) => expect(storage.rounds, [round(), round()]),
    );

    blocTest<StatisticsBloc, StatisticsState>(
      'never changes a list it has already emitted',
      setUp: () => storage = InMemoryRoundsStorage([round()]),
      build: () => StatisticsBloc(storage: storage, refillsStorage: refills),
      act: (bloc) => bloc.add(RoundRecorded(round(minute: 1))),
      verify: (bloc) {
        expect(() => bloc.state.rounds.add(round()), throwsUnsupportedError);
      },
    );

    blocTest<StatisticsBloc, StatisticsState>(
      'records a refill next to the rounds',
      setUp: () => storage = InMemoryRoundsStorage([round()]),
      build: () => StatisticsBloc(storage: storage, refillsStorage: refills),
      act: (bloc) => bloc.add(RefillRecorded(RefillRecord(time: DateTime(2026, 3, 14, 10), amount: 10000))),
      expect: () => [
        StatisticsState(
          rounds: [round()],
          refills: [RefillRecord(time: DateTime(2026, 3, 14, 10), amount: 10000)],
        ),
      ],
      verify: (_) => expect(refills.refills, hasLength(1)),
    );

    blocTest<StatisticsBloc, StatisticsState>(
      'clears the rounds, the refills and the storage',
      setUp: () {
        storage = InMemoryRoundsStorage([round(), round(minute: 1)]);
        refills = InMemoryRefillsStorage([RefillRecord(time: DateTime(2026, 3, 14, 10), amount: 10000)]);
      },
      build: () => StatisticsBloc(storage: storage, refillsStorage: refills),
      act: (bloc) => bloc.add(const StatisticsCleared()),
      expect: () => [const StatisticsState(rounds: [], refills: [])],
      verify: (_) {
        expect(storage.rounds, isEmpty);
        expect(refills.refills, isEmpty);
      },
    );

    test('lists the most recent flights first and skips rounds left mid-flight', () {
      final rounds = [
        round(minute: 0, multiplier: 120),
        round(minute: 1, outcome: RoundOutcome.jumped, multiplier: 150, crash: 412),
        round(minute: 2, outcome: RoundOutcome.left, multiplier: 130),
        round(minute: 3, multiplier: 100),
      ];
      final state = StatisticsState(rounds: rounds);

      expect(state.recentFlights, [rounds[3], rounds[1], rounds[0]]);
      expect(state.recentFlights.map((flight) => flight.crash), [100, 412, 120]);
    });

    test('keeps only the last fifteen flights', () {
      final state = StatisticsState(
        rounds: [for (var i = 0; i < 20; i++) round(minute: i, multiplier: 100 + i)],
      );

      expect(state.recentFlights, hasLength(15));
      expect(state.recentFlights.first.crash, 119);
      expect(state.recentFlights.last.crash, 105);
    });
  });
}
