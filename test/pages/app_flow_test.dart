import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_harness.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('opens on the game with five hundred coins', (tester) async {
    final app = AppHarness();
    await app.launch(tester);

    expect(find.text('500.00'), findsOneWidget);
    expect(tester.mainButtonTitle, AppTexts.play);
  });

  testWidgets('a round counts down, takes off, shows the payout and pays the jump', (tester) async {
    final app = AppHarness();
    await app.launch(tester);

    await tester.tapMainButton();
    expect(tester.mainButtonTitle, AppTexts.cancel);
    await tester.clockAt(app, 1.2);
    expect(find.text('2'), findsOneWidget);

    await tester.clockAt(app, 3);
    expect(find.text('490.00'), findsOneWidget);
    expect(app.stage.cues, ['takeOff']);

    await tester.clockAt(app, 3);
    expect(find.text('1.68×'), findsOneWidget);
    expect(tester.mainButtonTitle, '${AppTexts.jump} · 16.80');

    await tester.tapMainButton();
    expect(find.text('506.80'), findsOneWidget);
    expect(app.balanceStorage.balance, 50680);

    await tester.clockAt(app, 8);
    expect(find.text(AppTexts.flewAway), findsOneWidget);
    expect(app.stage.cues, ['takeOff', 'crash']);
    expect(app.roundsStorage.rounds.single.outcome, RoundOutcome.jumped);

    await tester.clockAt(app, 2);
    expect(tester.mainButtonTitle, AppTexts.play);
  });

  testWidgets('a plane that flies away takes the entry', (tester) async {
    final app = AppHarness(draws: [0.5]);
    await app.launch(tester);

    await tester.tapMainButton();
    await tester.clockAt(app, 3);
    await tester.clockAt(app, 4);

    expect(find.text('1.94×'), findsOneWidget);
    expect(find.text(AppTexts.flewAway), findsOneWidget);
    expect(find.text('490.00'), findsOneWidget);
    expect(app.roundsStorage.rounds.single.change, -1000);
  });

  testWidgets('leaving mid-flight asks first and then gives up the entry', (tester) async {
    final app = AppHarness();
    await app.launch(tester);
    await tester.tapMainButton();
    await tester.clockAt(app, 3);
    await tester.clockAt(app, 2);

    await tester.openMenu();
    expect(find.text(AppTexts.leaveFlight), findsOneWidget);
    await tester.tapText(AppTexts.stay);
    expect(tester.mainButtonTitle, '${AppTexts.jump} · 14.10');

    await tester.openMenu();
    await tester.tapText(AppTexts.leave);

    expect(app.balanceStorage.balance, 49000);
    expect(app.roundsStorage.rounds.single.outcome, RoundOutcome.left);
    expect(find.text(AppTexts.statistics), findsOneWidget);
  });

  testWidgets('an empty balance offers a refill instead of a round', (tester) async {
    final app = AppHarness(balance: 40);
    await app.launch(tester);

    expect(tester.mainButtonTitle, AppTexts.refill);
    await tester.tapMainButton();

    expect(find.text('500.00'), findsOneWidget);
    expect(tester.mainButtonTitle, AppTexts.play);
  });

  testWidgets('statistics list the rounds that were played', (tester) async {
    final app = AppHarness(
      rounds: [
        RoundRecord(time: AppHarness.now, entry: 2000, multiplier: 342, outcome: RoundOutcome.jumped, crash: 510),
      ],
    );
    await app.launch(tester);

    await tester.openMenu();
    await tester.openMenuItem(AppTexts.statistics);

    expect(find.text('3.42×'), findsOneWidget);
    expect(find.text('+48.40'), findsOneWidget);
  });

  testWidgets('fits a small phone without overflowing', (tester) async {
    final app = AppHarness();
    await app.launch(tester, size: const Size(320, 568));

    expect(tester.takeException(), isNull);
    await tester.tapMainButton();
    await tester.clockAt(app, 3);
    await tester.clockAt(app, 3);
    expect(tester.takeException(), isNull);
  });
}
