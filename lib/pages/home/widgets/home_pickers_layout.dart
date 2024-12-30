import 'package:updraft_flutter/pages/home/widgets/auto_mode_display.dart';
import 'package:updraft_flutter/pages/home/widgets/bet_amount_picker.dart';
import 'package:flutter/material.dart';

class HomePickersLayout extends StatelessWidget {
  const HomePickersLayout({
    super.key,
    required this.isPortrait,
    required this.betAmount,
    required this.autoMode,
    required this.autoModeCoef,
    required this.switchAutoMode,
    required this.disabled,
  });

  final bool isPortrait;
  final ValueNotifier<double> betAmount;
  final bool autoMode;
  final ValueNotifier<double> autoModeCoef;
  final ValueChanged<bool> switchAutoMode;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return isPortrait
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BetAmountPicker(
                betAmount: betAmount,
                disabled: disabled,
              ),
              const SizedBox(height: 12),
              AutoModeDisplay(
                autoMode: autoMode,
                autoModeCoef: autoModeCoef,
                switchAutoMode: switchAutoMode,
                disabled: disabled,
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: BetAmountPicker(
                  betAmount: betAmount,
                  disabled: disabled,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AutoModeDisplay(
                  autoMode: autoMode,
                  autoModeCoef: autoModeCoef,
                  switchAutoMode: switchAutoMode,
                  disabled: disabled,
                ),
              ),
            ],
          );
  }
}
