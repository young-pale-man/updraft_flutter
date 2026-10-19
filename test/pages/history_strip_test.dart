import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_harness.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('the last flights strip slides as one row and colours each flight by how it ended', (tester) async {
    final app = AppHarness(
      rounds: [
        RoundRecord(time: AppHarness.now, entry: 1000, multiplier: 187, outcome: RoundOutcome.flewAway, crash: 187),
        RoundRecord(time: AppHarness.now, entry: 1000, multiplier: 210, outcome: RoundOutcome.jumped, crash: 412),
        RoundRecord(time: AppHarness.now, entry: 1000, multiplier: 320, outcome: RoundOutcome.flewAway, crash: 320),
      ],
    );
    await app.launch(tester);
    await tester.openFromMenu(AppTexts.play);

    final strip = find.byType(ListView);
    expect(find.descendant(of: strip, matching: find.text(AppTexts.lastFlights)), findsOneWidget);

    Color colorOf(String text) =>
        tester.widget<Text>(find.descendant(of: strip, matching: find.text(text))).style!.color!;
    expect(colorOf('4.12×'), AppColors.positive);
    expect(colorOf('1.87×'), AppColors.negative);
    expect(colorOf('3.20×'), AppColors.negative);
  });
}
