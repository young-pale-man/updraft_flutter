import 'dart:io';

import 'package:updraft_flutter/application.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:updraft_flutter/widgets/main_button.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_ticks.dart';
import 'fixed_random.dart';
import 'in_memory_storages.dart';
import 'recording_stage.dart';

Future<void> loadAppFonts() async {
  final loader = FontLoader('Kanit');
  for (final file in Directory('fonts').listSync().whereType<File>().where((file) => file.path.endsWith('.ttf'))) {
    final bytes = await file.readAsBytes();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

class AppHarness {
  AppHarness({int? balance, List<RoundRecord> rounds = const [], List<double> draws = const [0.75]})
    : balanceStorage = InMemoryBalanceStorage(balance),
      roundsStorage = InMemoryRoundsStorage(rounds),
      _random = FixedRandom(draws);

  static final DateTime now = DateTime(2026, 3, 14, 9, 26);

  final InMemoryBalanceStorage balanceStorage;
  final InMemoryRoundsStorage roundsStorage;
  final FakeTicks ticks = FakeTicks();
  final List<RecordingStage> stages = [];
  final FixedRandom _random;

  RecordingStage get stage => stages.single;

  Future<void> launch(WidgetTester tester, {Size size = const Size(390, 844)}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      Application(
        dependencies: AppDependencies(
          balanceStorage: balanceStorage,
          roundsStorage: roundsStorage,
          random: _random,
          ticks: ticks.call,
          clock: () => now,
          flightStage: () {
            final stage = RecordingStage();
            stages.add(stage);
            return stage;
          },
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }
}

extension AppGestures on WidgetTester {
  Finder get mainButton => find.byType(MainButton);

  String get mainButtonTitle => widget<MainButton>(mainButton).title ?? '';

  Future<void> tapMainButton() async {
    await tap(mainButton);
    await pump();
    await pump(const Duration(milliseconds: 200));
  }

  Future<void> tapText(String text) async {
    await tap(find.text(text).hitTestable().last);
    await pumpAndSettle();
  }

  Future<void> openMenu() async {
    await tap(find.byWidgetPredicate((widget) => widget is MainIconButton && widget.icon == Assets.menu));
    await pump();
    await pumpAndSettle();
  }

  Future<void> openMenuItem(String title) async {
    await tap(find.descendant(of: find.widgetWithText(Row, title), matching: find.byType(MainIconButton)));
    await pump();
    await pumpAndSettle();
  }

  Future<void> clockAt(AppHarness app, double seconds) async {
    app.ticks.push(Duration(microseconds: (seconds * 1000000).round()));
    await pump();
    await pump();
  }
}
