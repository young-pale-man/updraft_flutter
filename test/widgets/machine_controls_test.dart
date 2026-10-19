import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/widgets/machine/action_button.dart';
import 'package:updraft_flutter/widgets/machine/arrow_button.dart';
import 'package:updraft_flutter/widgets/machine/outlined_text.dart';
import 'package:updraft_flutter/widgets/machine/slab_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> show(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('ActionButton', () {
    testWidgets('fires once per tap', (tester) async {
      var presses = 0;
      await show(tester, ActionButton(title: 'Play', onPressed: () => presses++));

      await tester.tap(find.byType(ActionButton));
      await tester.pump();

      expect(presses, 1);
    });

    testWidgets('does nothing while disabled and says so to screen readers', (tester) async {
      var presses = 0;
      await show(tester, ActionButton(title: 'Play', onPressed: () => presses++, enabled: false));

      await tester.tap(find.byType(ActionButton));
      await tester.pump();

      expect(presses, 0);
      expect(
        tester.getSemantics(find.byType(ActionButton)),
        matchesSemantics(label: 'Play', isButton: true, hasEnabledState: true, isEnabled: false),
      );
    });

    testWidgets('sinks its cap while pressed and lifts it on release', (tester) async {
      await show(tester, ActionButton(title: 'Play', onPressed: () {}));
      double capTop() => tester.getTopLeft(find.byKey(ActionButton.capKey)).dy;
      final resting = capTop();

      final gesture = await tester.startGesture(tester.getCenter(find.byType(ActionButton)));
      await tester.pump();
      expect(capTop(), greaterThan(resting));

      await gesture.up();
      await tester.pump();
      expect(capTop(), resting);
    });

    testWidgets('shows a second line under the title', (tester) async {
      await show(tester, ActionButton(title: 'Jump', detail: '24.50', onPressed: () {}));

      expect(find.text('Jump'), findsOneWidget);
      expect(find.text('24.50'), findsOneWidget);
    });
  });

  group('ArrowButton', () {
    testWidgets('steps once per tap', (tester) async {
      var steps = 0;
      await show(tester, ArrowButton(direction: AxisDirection.right, label: 'More', onStep: () => steps++));

      await tester.tap(find.byType(ArrowButton));
      await tester.pump(const Duration(seconds: 1));

      expect(steps, 1);
    });

    testWidgets('keeps stepping while held and stops on release', (tester) async {
      var steps = 0;
      await show(tester, ArrowButton(direction: AxisDirection.left, label: 'Less', onStep: () => steps++));

      final gesture = await tester.startGesture(tester.getCenter(find.byType(ArrowButton)));
      await tester.pump(const Duration(milliseconds: 1500));
      final whileHeld = steps;
      await gesture.up();
      await tester.pump(const Duration(seconds: 1));

      expect(whileHeld, greaterThan(5));
      expect(steps, whileHeld);
    });

    testWidgets('does nothing while disabled', (tester) async {
      var steps = 0;
      await show(
        tester,
        ArrowButton(direction: AxisDirection.left, label: 'Less', onStep: () => steps++, enabled: false),
      );

      final gesture = await tester.startGesture(tester.getCenter(find.byType(ArrowButton)));
      await tester.pump(const Duration(seconds: 1));
      await gesture.up();

      expect(steps, 0);
    });
  });

  group('SlabButton', () {
    testWidgets('marks the selected item with chevrons', (tester) async {
      await show(
        tester,
        Column(
          children: [
            SlabButton(title: 'Play', selected: true, onPressed: () {}),
            SlabButton(title: 'Settings', onPressed: () {}),
          ],
        ),
      );

      expect(find.text('>'), findsOneWidget);
      expect(find.text('<'), findsOneWidget);
    });

    testWidgets('turns its title white while pressed, selected or not', (tester) async {
      for (final selected in [true, false]) {
        await show(tester, SlabButton(title: 'Play', selected: selected, onPressed: () {}));
        Color? fill() => tester
            .widgetList<Text>(find.text('Play'))
            .map((text) => text.style?.color)
            .lastWhere((color) => color != null);
        final resting = fill();
        expect(resting, isNot(AppColors.figure));

        final gesture = await tester.startGesture(tester.getCenter(find.byType(SlabButton)));
        await tester.pump();
        expect(fill(), AppColors.figure);

        await gesture.up();
        await tester.pump();
        expect(fill(), resting);
      }
    });

    testWidgets('fires on tap', (tester) async {
      var presses = 0;
      await show(tester, SlabButton(title: 'Settings', onPressed: () => presses++));

      await tester.tap(find.byType(SlabButton));
      await tester.pump();

      expect(presses, 1);
    });
  });

  testWidgets('outlined text reads once to screen readers', (tester) async {
    await show(tester, const OutlinedText('3.42×', style: TextStyle(fontSize: 40)));

    expect(find.bySemanticsLabel('3.42×'), findsOneWidget);
  });
}
