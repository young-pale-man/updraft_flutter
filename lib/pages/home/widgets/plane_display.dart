import 'package:updraft_flutter/pages/home/widgets/coef_display.dart';
import 'package:updraft_flutter/pages/home/widgets/timer_display.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class PlaneDisplay extends StatelessWidget {
  const PlaneDisplay({
    super.key,
    required this.onInit,
    required this.coefDisplay,
    required this.currentCoef,
    required this.coefDeadline,
    required this.timerDisplay,
    required this.timerValue,
  });

  final ValueChanged<Artboard> onInit;
  final bool coefDisplay;
  final ValueNotifier currentCoef;
  final double coefDeadline;
  final bool timerDisplay;
  final int timerValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              border: Border.all(
                width: 2,
                color: AppColors.text.primary,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(42),
              child: RiveAnimation.asset(
                Assets.plane,
                fit: BoxFit.cover,
                onInit: onInit,
              ),
            ),
          ),
        ),
        if (coefDisplay)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ValueListenableBuilder(
                valueListenable: currentCoef,
                builder: (_, __, ____) => CoefDisplay(
                  currentCoef: currentCoef.value,
                  coefDeadline: coefDeadline,
                ),
              ),
            ),
          ),
        if (timerDisplay)
          Center(
            child: TimerDisplay(timerValue: timerValue),
          ),
      ],
    );
  }
}
