import 'package:updraft_flutter/pages/home/widgets/auto_mode_display.dart';
import 'package:updraft_flutter/pages/home/widgets/bet_amount_picker.dart';
import 'package:flutter/widgets.dart';

class HomePickersLayout extends StatelessWidget {
  const HomePickersLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [BetAmountPicker(), SizedBox(height: 12), AutoModeDisplay()],
    );
  }
}
