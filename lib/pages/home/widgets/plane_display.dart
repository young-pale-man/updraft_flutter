import 'package:updraft_flutter/pages/home/widgets/coef_display.dart';
import 'package:updraft_flutter/pages/home/widgets/timer_display.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class PlaneDisplay extends StatefulWidget {
  const PlaneDisplay({
    super.key,
    required this.onInit,
    required this.coefDisplay,
    required this.currentCoef,
    required this.coefDeadline,
    required this.timerDisplay,
    required this.timerValue,
  });

  final ValueChanged<StateMachine> onInit;
  final bool coefDisplay;
  final ValueNotifier currentCoef;
  final double coefDeadline;
  final bool timerDisplay;
  final ValueNotifier<int> timerValue;

  @override
  State<PlaneDisplay> createState() => _PlaneDisplayState();
}

class _PlaneDisplayState extends State<PlaneDisplay> {
  final _fileLoader = FileLoader.fromAsset(Assets.plane, riveFactory: Factory.rive);

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              border: Border.all(width: 2, color: AppColors.text.primary),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(42),
              child: RiveWidgetBuilder(
                fileLoader: _fileLoader,
                stateMachineSelector: StateMachineSelector.byName(AppConst.animationStateMachine),
                onLoaded: (state) => widget.onInit(state.controller.stateMachine),
                builder: (context, state) => switch (state) {
                  RiveLoaded() => RiveWidget(
                    controller: state.controller,
                    fit: Fit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
          ),
        ),
        if (widget.coefDisplay)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ValueListenableBuilder(
                valueListenable: widget.currentCoef,
                builder: (_, _, _) =>
                    CoefDisplay(currentCoef: widget.currentCoef.value, coefDeadline: widget.coefDeadline),
              ),
            ),
          ),
        if (widget.timerDisplay)
          Center(
            child: ValueListenableBuilder(
              valueListenable: widget.timerValue,
              builder: (_, _, _) => TimerDisplay(timerValue: widget.timerValue.value),
            ),
          ),
      ],
    );
  }
}
