import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:updraft_flutter/pages/statistics/widgets/day_panel.dart';
import 'package:updraft_flutter/pages/statistics/widgets/summary_panel.dart';

import '../support/app_harness.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('opens on the menu with five hundred coins and no best jump yet', (tester) async {
    final app = AppHarness();
    await app.launch(tester);

    expect(find.text('500.00'), findsWidgets);
    expect(find.text(AppTexts.noJumpYet), findsWidgets);
    expect(find.bySemanticsLabel(AppTexts.play), findsOneWidget);
  });

  testWidgets('the menu shows the best jump so far', (tester) async {
    final app = AppHarness(
      rounds: [
        RoundRecord(time: AppHarness.now, entry: 1000, multiplier: 210, outcome: RoundOutcome.jumped, crash: 388),
        RoundRecord(time: AppHarness.now, entry: 1000, multiplier: 450, outcome: RoundOutcome.flewAway, crash: 450),
      ],
    );
    await app.launch(tester);

    expect(find.text('2.10×'), findsWidgets);
  });

  testWidgets('a round counts down, takes off, shows the payout and pays the jump', (tester) async {
    final app = AppHarness();
    await app.launch(tester);
    await tester.openFromMenu(AppTexts.play);

    await tester.tapMainButton();
    expect(tester.mainButtonTitle, AppTexts.cancel);
    await tester.clockAt(app, 1.2);
    expect(find.bySemanticsLabel('2'), findsOneWidget);

    await tester.clockAt(app, 3);
    expect(find.bySemanticsLabel('490.00'), findsOneWidget);
    expect(app.stage.cues, ['takeOff']);

    await tester.clockAt(app, 3);
    expect(find.bySemanticsLabel('1.68×'), findsOneWidget);
    expect(tester.mainButtonTitle, '${AppTexts.jump} 16.80');

    await tester.tapMainButton();
    expect(find.bySemanticsLabel('506.80'), findsOneWidget);
    expect(find.text(AppTexts.jumped), findsOneWidget);
    expect(find.text(AppTexts.flewAway), findsNothing);
    expect(find.text('${AppTexts.jumpedAt} 1.68×'), findsOneWidget);
    expect(find.bySemanticsLabel('+6.80'), findsOneWidget);
    expect(app.balanceStorage.balance, 50680);
    expect(app.stage.cues, ['takeOff', 'exit']);
    expect(app.roundsStorage.rounds.single.outcome, RoundOutcome.jumped);

    await tester.clockAt(app, 1);
    expect(find.bySemanticsLabel('1.68×'), findsWidgets);
    expect(find.text(AppTexts.flewAway), findsNothing);

    await tester.clockAt(app, 2);
    expect(tester.mainButtonTitle, '${AppTexts.play} 10.00');
  });

  testWidgets('a plane that flies away takes the entry', (tester) async {
    final app = AppHarness(draws: [0.5]);
    await app.launch(tester);
    await tester.openFromMenu(AppTexts.play);

    await tester.tapMainButton();
    await tester.clockAt(app, 3);
    await tester.clockAt(app, 4);

    expect(find.bySemanticsLabel('1.94×'), findsWidgets);
    expect(find.text(AppTexts.flewAway), findsOneWidget);
    expect(find.text('${AppTexts.flewAwayAt} 1.94×'), findsOneWidget);
    expect(find.bySemanticsLabel('−10.00'), findsOneWidget);
    expect(find.bySemanticsLabel('490.00'), findsOneWidget);
    expect(app.roundsStorage.rounds.single.change, -1000);
  });

  testWidgets('leaving mid-flight asks first and then gives up the entry', (tester) async {
    final app = AppHarness();
    await app.launch(tester);
    await tester.openFromMenu(AppTexts.play);
    await tester.tapMainButton();
    await tester.clockAt(app, 3);
    await tester.clockAt(app, 2);

    await tester.goBack();
    expect(find.text(AppTexts.leaveFlight), findsOneWidget);
    await tester.tapText(AppTexts.stay);
    expect(tester.mainButtonTitle, '${AppTexts.jump} 14.10');

    await tester.goBack();
    await tester.tapText(AppTexts.leave);

    expect(app.balanceStorage.balance, 49000);
    expect(app.roundsStorage.rounds.single.outcome, RoundOutcome.left);
    expect(find.bySemanticsLabel(AppTexts.play), findsOneWidget);
  });

  testWidgets('the flight holds still while leaving is being decided', (tester) async {
    final app = AppHarness();
    await app.launch(tester);
    await tester.openFromMenu(AppTexts.play);
    await tester.tapMainButton();
    await tester.clockAt(app, 3);
    await tester.clockAt(app, 2);

    await tester.goBack();
    expect(find.text(AppTexts.leaveFlight), findsOneWidget);
    await tester.clockAt(app, 20);
    expect(find.bySemanticsLabel('1.41×'), findsWidgets);
    expect(app.stage.cues, ['takeOff', 'hold']);

    await tester.tapText(AppTexts.stay);
    expect(app.stage.cues, ['takeOff', 'hold', 'release']);
    await tester.clockAt(app, 2);
    expect(find.bySemanticsLabel('2.00×'), findsWidgets);
    expect(tester.mainButtonTitle, '${AppTexts.jump} 20.00');
  });

  testWidgets('a flight pauses when the app goes to the background and waits for resume', (tester) async {
    final app = AppHarness();
    await app.launch(tester);
    await tester.openFromMenu(AppTexts.play);
    await tester.tapMainButton();
    await tester.clockAt(app, 3);
    await tester.clockAt(app, 2);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(find.text(AppTexts.paused), findsOneWidget);
    expect(tester.mainButtonTitle, AppTexts.resume);
    await tester.clockAt(app, 30);
    expect(find.bySemanticsLabel('1.41×'), findsWidgets);

    await tester.tapMainButton();
    await tester.clockAt(app, 2);
    expect(find.text(AppTexts.paused), findsNothing);
    expect(find.bySemanticsLabel('2.00×'), findsWidgets);
  });

  testWidgets('an empty balance offers a refill instead of a round', (tester) async {
    final app = AppHarness(balance: 40);
    await app.launch(tester);
    await tester.openFromMenu(AppTexts.play);

    expect(tester.mainButtonTitle, AppTexts.refill);
    await tester.tapMainButton();

    expect(find.bySemanticsLabel('500.00'), findsOneWidget);
    expect(tester.mainButtonTitle, '${AppTexts.play} 1.00');
  });

  testWidgets('statistics sum up and list the rounds that were played', (tester) async {
    final app = AppHarness(
      rounds: [
        RoundRecord(time: AppHarness.now, entry: 2000, multiplier: 342, outcome: RoundOutcome.jumped, crash: 510),
        RoundRecord(time: AppHarness.now, entry: 1000, multiplier: 187, outcome: RoundOutcome.flewAway, crash: 187),
      ],
    );
    await app.launch(tester);

    await tester.openFromMenu(AppTexts.statistics);

    final summary = find.byType(SummaryPanel);
    expect(find.descendant(of: summary, matching: find.text('2')), findsOneWidget);
    expect(find.descendant(of: summary, matching: find.text('50%')), findsOneWidget);
    expect(find.descendant(of: summary, matching: find.text('3.42×')), findsOneWidget);
    expect(find.descendant(of: summary, matching: find.text('+38.40')), findsOneWidget);

    final today = find.byType(DayPanel);
    expect(find.descendant(of: today, matching: find.text(AppTexts.today)), findsOneWidget);
    expect(find.descendant(of: today, matching: find.text('+48.40')), findsOneWidget);
    expect(find.descendant(of: today, matching: find.text('−10.00')), findsOneWidget);
  });

  testWidgets('statistics narrow down to a period', (tester) async {
    final app = AppHarness(
      rounds: [
        RoundRecord(
          time: DateTime(2026, 2, 1, 12),
          entry: 1000,
          multiplier: 150,
          outcome: RoundOutcome.flewAway,
          crash: 150,
        ),
        RoundRecord(time: AppHarness.now, entry: 2000, multiplier: 342, outcome: RoundOutcome.jumped, crash: 510),
      ],
    );
    await app.launch(tester);
    await tester.openFromMenu(AppTexts.statistics);
    expect(find.byType(DayPanel), findsNWidgets(2));

    await tester.tap(find.bySemanticsLabel(AppTexts.periodWeek));
    await tester.pumpAndSettle();

    expect(find.byType(DayPanel), findsOneWidget);
    expect(find.descendant(of: find.byType(SummaryPanel), matching: find.text('1')), findsOneWidget);
  });

  testWidgets('statistics say so when there is nothing to show', (tester) async {
    final app = AppHarness();
    await app.launch(tester);

    await tester.openFromMenu(AppTexts.statistics);

    expect(find.text(AppTexts.noFlightsYet), findsOneWidget);
    expect(find.byType(DayPanel), findsNothing);
  });

  testWidgets('clearing statistics asks first and empties the history but keeps the balance', (tester) async {
    final app = AppHarness(
      balance: 61200,
      rounds: [
        RoundRecord(time: AppHarness.now, entry: 2000, multiplier: 342, outcome: RoundOutcome.jumped, crash: 510),
      ],
    );
    await app.launch(tester);
    await tester.openFromMenu(AppTexts.settings);

    await tester.tap(find.bySemanticsLabel(AppTexts.clearStatistics));
    await tester.pumpAndSettle();
    await tester.tapText(AppTexts.cancel);
    expect(app.roundsStorage.rounds, hasLength(1));

    await tester.tap(find.bySemanticsLabel(AppTexts.clearStatistics));
    await tester.pumpAndSettle();
    await tester.tapText(AppTexts.clear);
    expect(app.roundsStorage.rounds, isEmpty);

    await tester.goBack();
    expect(find.text(AppTexts.noJumpYet), findsWidgets);
    expect(find.bySemanticsLabel('612.00'), findsOneWidget);
  });

  testWidgets('how to play shows examples worked out by the game itself', (tester) async {
    final app = AppHarness();
    await app.launch(tester);

    await tester.openFromMenu(AppTexts.howToPlay);

    expect(find.text('15.00'), findsOneWidget);
    expect(find.text('34.20'), findsOneWidget);
    expect(find.text('48.5%'), findsOneWidget);
    await tester.dragUntilVisible(find.text('9.7%'), find.byType(ListView), const Offset(0, -200));
    expect(find.text('97.0%'), findsNWidgets(4));
  });

  testWidgets('fits a small phone without overflowing', (tester) async {
    final app = AppHarness();
    await app.launch(tester, size: const Size(320, 568));
    expect(tester.takeException(), isNull);

    await tester.openFromMenu(AppTexts.play);
    expect(tester.takeException(), isNull);
    await tester.tapMainButton();
    await tester.clockAt(app, 3);
    await tester.clockAt(app, 3);
    expect(tester.takeException(), isNull);
  });
}
