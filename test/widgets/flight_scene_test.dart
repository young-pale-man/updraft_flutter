import 'package:updraft_flutter/widgets/flight_scene.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/recording_stage.dart';

void main() {
  late RecordingStage stage;
  late int stagesCreated;

  Future<void> show(WidgetTester tester, {int takeOff = 0, int crash = 0, Key? key}) {
    return tester.pumpWidget(
      FlightScene(
        key: key,
        takeOffRevision: takeOff,
        crashRevision: crash,
        stage: () {
          stagesCreated++;
          return stage = RecordingStage();
        },
      ),
    );
  }

  setUp(() => stagesCreated = 0);

  testWidgets('creates one stage and fires nothing until a revision changes', (tester) async {
    await show(tester, takeOff: 4, crash: 3);
    await show(tester, takeOff: 4, crash: 3);
    await show(tester, takeOff: 4, crash: 3);

    expect(stagesCreated, 1);
    expect(stage.cues, isEmpty);
  });

  testWidgets('takes off once per take-off revision and crashes once per crash revision', (tester) async {
    await show(tester);

    await show(tester, takeOff: 1);
    await show(tester, takeOff: 1);
    await show(tester, takeOff: 1, crash: 1);
    await show(tester, takeOff: 2, crash: 1);
    await show(tester, takeOff: 2, crash: 2);

    expect(stagesCreated, 1);
    expect(stage.cues, ['takeOff', 'crash', 'takeOff', 'crash']);
  });

  testWidgets('replays identical rounds because it counts revisions, not outcomes', (tester) async {
    await show(tester);
    for (var round = 1; round <= 3; round++) {
      await show(tester, takeOff: round, crash: round - 1);
      await show(tester, takeOff: round, crash: round);
    }

    expect(stage.cues, ['takeOff', 'crash', 'takeOff', 'crash', 'takeOff', 'crash']);
  });

  testWidgets('disposes its stage with the scene', (tester) async {
    await show(tester);
    final shown = stage;

    await tester.pumpWidget(const SizedBox.shrink());

    expect(shown.disposed, isTrue);
  });
}
