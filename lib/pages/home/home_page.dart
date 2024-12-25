import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/pages/home/widgets/home_appbar_content.dart';
import 'package:updraft_flutter/pages/home/widgets/home_pickers_layout.dart';
import 'package:updraft_flutter/pages/home/widgets/plane_display.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:updraft_flutter/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  final _betAmount = ValueNotifier<double>(AppConst.minBetAmount);
  final _autoModeCoef = ValueNotifier<double>(AppConst.minCoef);
  final _currentCoef = ValueNotifier<double>(AppConst.minCoef);

  bool _autoMode = false;
  double _coefDeadline = AppConst.minCoef;

  late StateMachineController? _controller;

  void onAnimationInit(Artboard artboard) async {
    _controller = StateMachineController.fromArtboard(
      artboard,
      AppConst.animationStateMachine,
    );
    if (_controller != null) {
      artboard.addController(_controller!);

      // _isBigInput = _controller!.findInput<double>('isBig');

      // if (_isBigInput != null) {
      //   _isBigInput!.value = 0;
      // }
    }
  }

  @override
  PreferredSizeWidget? get appBar => const MainAppbar(
        currentPage: NavigationMenuItems.home,
        content: HomeAppbarContent(),
      );

  @override
  Widget pageBuilder(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 580,
                  maxWidth: 900,
                ),
                child: PlaneDisplay(
                  onInit: onAnimationInit,
                  coefDisplay: true,
                  currentCoef: _currentCoef,
                  coefDeadline: _coefDeadline,
                  timerDisplay: false,
                  timerValue: 5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          HomePickersLayout(
            isPortrait: isPortrait,
            betAmount: _betAmount,
            autoMode: _autoMode,
            autoModeCoef: _autoModeCoef,
            switchAutoMode: _switchAutoMode,
          ),
          const SizedBox(height: 32),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: MainButton(
                title: AppTexts.play,
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _switchAutoMode(bool value) => setState(() => _autoMode = value);
}
