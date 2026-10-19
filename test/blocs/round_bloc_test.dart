import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_ticks.dart';
import '../support/fixed_random.dart';
import '../support/in_memory_storages.dart';

final now = DateTime(2026, 3, 14, 9, 26);

class Round {
  Round({int balance = 50000, List<double> draws = const [0.75]}) {
    balanceStorage = InMemoryBalanceStorage(balance);
    roundsStorage = InMemoryRoundsStorage();
    balanceBloc = BalanceBloc(storage: balanceStorage);
    statisticsBloc = StatisticsBloc(storage: roundsStorage);
    bloc = RoundBloc(
      balanceBloc: balanceBloc,
      statisticsBloc: statisticsBloc,
      random: FixedRandom(draws),
      ticks: ticks.call,
      clock: () => now,
    );
  }

  final ticks = FakeTicks();
  late final InMemoryBalanceStorage balanceStorage;
  late final InMemoryRoundsStorage roundsStorage;
  late final BalanceBloc balanceBloc;
  late final StatisticsBloc statisticsBloc;
  late final RoundBloc bloc;

  RoundState get state => bloc.state;

  int get balance => balanceBloc.state.balance;

  List<RoundRecord> get rounds => statisticsBloc.state.rounds;

  Future<void> send(RoundEvent event) async {
    bloc.add(event);
    await settle();
  }

  Future<void> takeOff({int entry = 1000}) async {
    await send(EntryChanged(entry));
    await send(const PlayPressed());
    await ticks.seconds(3);
  }

  Future<void> close() async {
    await bloc.close();
    await balanceBloc.close();
    await statisticsBloc.close();
  }
}

void main() {
  late Round round;

  tearDown(() => round.close());

  group('countdown', () {
    test('starts from three when play is pressed', () async {
      round = Round();

      await round.send(const PlayPressed());

      expect(round.state.phase, RoundPhase.countdown);
      expect(round.state.secondsLeft, 3);
    });

    test('counts down with the clock', () async {
      round = Round();
      await round.send(const PlayPressed());

      await round.ticks.seconds(0.4);
      expect(round.state.secondsLeft, 3);
      await round.ticks.seconds(1.2);
      expect(round.state.secondsLeft, 2);
      await round.ticks.seconds(2.9);
      expect(round.state.secondsLeft, 1);
      expect(round.balance, 50000);
    });

    test('can be cancelled without touching the balance', () async {
      round = Round();
      await round.send(const PlayPressed());
      await round.ticks.seconds(1);

      await round.send(const CountdownCancelled());
      await round.ticks.seconds(3);

      expect(round.state.phase, RoundPhase.ready);
      expect(round.balance, 50000);
      expect(round.state.takeOffRevision, 0);
    });

    test('does not start when the balance cannot cover the entry', () async {
      round = Round(balance: 50);

      await round.send(const PlayPressed());

      expect(round.state.phase, RoundPhase.ready);
      expect(round.ticks.subscriptions, 0);
      expect(round.balance, 50);
    });

    test('starts with the default entry, lowered to what the balance covers', () async {
      round = Round(balance: 700);

      expect(round.state.entry, 700);
      expect(Round().state.entry, 1000);
    });
  });

  group('take-off', () {
    test('takes the entry and starts the flight at one', () async {
      round = Round();

      await round.takeOff(entry: 2000);

      expect(round.state.phase, RoundPhase.flying);
      expect(round.state.multiplier, 100);
      expect(round.state.takeOffRevision, 1);
      expect(round.balance, 48000);
      expect(round.balanceStorage.balance, 48000);
    });

    test('drives the multiplier from flight time', () async {
      round = Round();
      await round.takeOff();

      await round.ticks.seconds(2);
      expect(round.state.multiplier, 141);
      await round.ticks.seconds(4);
      expect(round.state.multiplier, 200);
      expect(round.state.livePayout, 2000);
    });
  });

  group('jump', () {
    test('pays the entry times the multiplier on the button', () async {
      round = Round();
      await round.takeOff(entry: 2000);
      await round.ticks.seconds(3);

      await round.send(const JumpPressed());

      expect(round.state.phase, RoundPhase.cashedOut);
      expect(round.state.jumpRevision, 1);
      expect(round.state.result!.multiplier, 168);
      expect(round.state.result!.change, 1360);
      expect(round.balance, 48000 + 3360);
    });

    test('lets the plane fly on to its crash point, then records the jump', () async {
      round = Round();
      await round.takeOff(entry: 2000);
      await round.ticks.seconds(3);
      await round.send(const JumpPressed());

      await round.ticks.seconds(7);
      expect(round.state.phase, RoundPhase.cashedOut);
      expect(round.state.multiplier, 336);
      expect(round.rounds, isEmpty);

      await round.ticks.seconds(8);
      expect(round.state.phase, RoundPhase.crashed);
      expect(round.state.multiplier, 388);
      expect(round.state.crashRevision, 1);
      expect(round.rounds, [
        RoundRecord(time: now, entry: 2000, multiplier: 168, outcome: RoundOutcome.jumped, crash: 388),
      ]);
      expect(round.balance, 48000 + 3360);
    });

    test('pays only once', () async {
      round = Round();
      await round.takeOff(entry: 2000);
      await round.ticks.seconds(3);

      await round.send(const JumpPressed());
      await round.ticks.seconds(4);
      await round.send(const JumpPressed());

      expect(round.state.jumpRevision, 1);
      expect(round.balance, 48000 + 3360);
    });

    test('is ignored outside a flight', () async {
      round = Round();

      await round.send(const JumpPressed());
      await round.send(const PlayPressed());
      await round.send(const JumpPressed());

      expect(round.state.phase, RoundPhase.countdown);
      expect(round.state.jumpRevision, 0);
      expect(round.balance, 50000);
    });
  });

  group('crash', () {
    test('loses the entry when the plane flies away first', () async {
      round = Round(draws: [0.5]);
      await round.takeOff(entry: 2000);

      await round.ticks.seconds(3.5);
      expect(round.state.phase, RoundPhase.flying);
      await round.ticks.seconds(3.9);

      expect(round.state.phase, RoundPhase.crashed);
      expect(round.state.multiplier, 194);
      expect(round.state.result!.change, -2000);
      expect(round.balance, 48000);
      expect(round.rounds, [
        RoundRecord(time: now, entry: 2000, multiplier: 194, outcome: RoundOutcome.flewAway, crash: 194),
      ]);
    });

    test('can happen on the very first tick', () async {
      round = Round(draws: [0]);
      await round.takeOff();

      await round.ticks.seconds(0.016);

      expect(round.state.phase, RoundPhase.crashed);
      expect(round.state.multiplier, 100);
      expect(round.state.result!.outcome, RoundOutcome.flewAway);
    });

    test('shows the result for a beat, then returns to ready', () async {
      round = Round(draws: [0.5]);
      await round.takeOff();
      await round.ticks.seconds(4);

      await round.ticks.seconds(1.4);
      expect(round.state.phase, RoundPhase.crashed);
      await round.ticks.seconds(1.5);

      expect(round.state.phase, RoundPhase.ready);
      expect(round.state.result, isNull);
      expect(round.state.multiplier, 100);
    });
  });

  group('auto jump', () {
    test('pays exactly the target on the tick that reaches it', () async {
      round = Round();
      await round.send(const AutoJumpChanged(true));
      await round.send(const TargetChanged(150));
      await round.takeOff(entry: 1000);

      await round.ticks.seconds(2);
      expect(round.state.phase, RoundPhase.flying);
      await round.ticks.seconds(2.5);

      expect(round.state.phase, RoundPhase.cashedOut);
      expect(round.state.result!.multiplier, 150);
      expect(round.balance, 49000 + 1500);
    });

    test('loses when the plane flies away below the target', () async {
      round = Round(draws: [0.5]);
      await round.send(const AutoJumpChanged(true));
      await round.send(const TargetChanged(250));
      await round.takeOff(entry: 1000);

      await round.ticks.seconds(4);

      expect(round.state.phase, RoundPhase.crashed);
      expect(round.state.result!.outcome, RoundOutcome.flewAway);
      expect(round.balance, 49000);
    });

    test('jumps when the target equals the crash point', () async {
      round = Round(draws: [0.5]);
      await round.send(const AutoJumpChanged(true));
      await round.send(const TargetChanged(194));
      await round.takeOff(entry: 1000);

      await round.ticks.seconds(4);

      expect(round.state.phase, RoundPhase.crashed);
      expect(round.state.result!.outcome, RoundOutcome.jumped);
      expect(round.state.result!.multiplier, 194);
      expect(round.balance, 49000 + 1940);
    });

    test('keeps the target within its limits', () async {
      round = Round();

      await round.send(const TargetChanged(50));
      expect(round.state.target, 110);
      await round.send(const TargetChanged(20000));
      expect(round.state.target, 10000);
    });
  });

  group('leaving', () {
    test('during the countdown costs nothing', () async {
      round = Round();
      await round.send(const PlayPressed());

      await round.send(const RoundLeft());

      expect(round.state.phase, RoundPhase.ready);
      expect(round.balance, 50000);
      expect(round.rounds, isEmpty);
    });

    test('mid-flight forfeits the entry and records it at the current multiplier', () async {
      round = Round();
      await round.takeOff(entry: 2500);
      await round.ticks.seconds(2);

      await round.send(const RoundLeft());
      await round.ticks.seconds(10);

      expect(round.state.phase, RoundPhase.ready);
      expect(round.balance, 47500);
      expect(round.rounds, [RoundRecord(time: now, entry: 2500, multiplier: 141, outcome: RoundOutcome.left)]);
    });

    test('after a jump keeps the payout and records the jump', () async {
      round = Round();
      await round.takeOff(entry: 2000);
      await round.ticks.seconds(3);
      await round.send(const JumpPressed());

      await round.send(const RoundLeft());

      expect(round.state.phase, RoundPhase.ready);
      expect(round.balance, 48000 + 3360);
      expect(round.rounds.single.outcome, RoundOutcome.jumped);
    });
  });

  group('entry', () {
    test('stays within the limits and the balance', () async {
      round = Round(balance: 1500);

      await round.send(const EntryChanged(5000));
      expect(round.state.entry, 1500);
      await round.send(const EntryChanged(20));
      expect(round.state.entry, 100);
    });

    test('cannot change once the round has started', () async {
      round = Round();
      await round.takeOff(entry: 1000);

      await round.send(const EntryChanged(2000));

      expect(round.state.entry, 1000);
    });

    test('follows the balance down after a loss', () async {
      round = Round(balance: 2500, draws: [0]);
      await round.takeOff(entry: 2000);
      await round.ticks.seconds(0.02);
      await round.ticks.seconds(2);

      expect(round.balance, 500);
      expect(round.state.entry, 500);
    });
  });

  test('counts every take-off, jump and crash, even when rounds repeat', () async {
    round = Round(draws: [0.5]);
    for (var played = 1; played <= 3; played++) {
      await round.takeOff();
      await round.ticks.seconds(1);
      await round.send(const JumpPressed());
      await round.ticks.seconds(4);
      await round.ticks.seconds(6);

      expect(round.state.takeOffRevision, played);
      expect(round.state.jumpRevision, played);
      expect(round.state.crashRevision, played);
    }
    expect(round.rounds, hasLength(3));
    expect(round.rounds.toSet(), hasLength(1));
  });
}
