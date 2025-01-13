import 'dart:async';
import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/game_bloc/game_bloc.dart';
import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/pages/home/widgets/home_appbar_content.dart';
import 'package:updraft_flutter/pages/home/widgets/home_pickers_layout.dart';
import 'package:updraft_flutter/pages/home/widgets/plane_display.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:updraft_flutter/utils/dialogs.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:updraft_flutter/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final _timerValue = ValueNotifier<int>(AppConst.startTimerSeconds);

  bool _autoMode = false;
  bool _buttonActive = true;
  double _coefDeadline = AppConst.minCoef;

  late StateMachineController? _controller;
  late SMITrigger? startTrigger;
  late SMITrigger? loseTrigger;

  Timer? _startTimer;
  Timer? _gameTimer;

  void onAnimationInit(Artboard artboard) async {
    _controller = StateMachineController.fromArtboard(
      artboard,
      AppConst.animationStateMachine,
    );

    if (_controller != null) {
      artboard.addController(_controller!);
      startTrigger = _controller!.getTriggerInput(AppConst.startAnimationTrigger);
      loseTrigger = _controller!.getTriggerInput(AppConst.loseAnimationTrigger);
    }
  }

  @override
  PreferredSizeWidget? get appBar => MainAppbar(
        currentPage: NavigationMenuItems.home,
        content: const HomeAppbarContent(),
        beforeMenuOpens: _cancelGame,
      );

  @override
  Widget pageBuilder(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<GameBloc, GameState>(
      listener: _gameStateListener,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenWidth < 580 ? screenWidth : 580,
                      maxWidth: 900,
                    ),
                    child: PlaneDisplay(
                      onInit: onAnimationInit,
                      coefDisplay: state is InGameST || state is CashOutST || state is GameFinishedST,
                      currentCoef: _currentCoef,
                      coefDeadline: _coefDeadline,
                      timerDisplay: state is BetST || state is CountDownST,
                      timerValue: _timerValue,
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
                disabled: state is! BetST,
              ),
              const SizedBox(height: 32),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: MainButton(
                    title: state is CountDownST
                        ? AppTexts.cancel
                        : state is BetST
                            ? AppTexts.play
                            : AppTexts.stop,
                    onPressed: _mainButtonAction,
                    disabled: state is CashOutST || !_buttonActive,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _switchAutoMode(bool value) => setState(() => _autoMode = value);

  void _mainButtonAction() {
    final bloc = context.read<GameBloc>();
    if (bloc.state is BetST) {
      if (injector<BalanceBloc>().state.balance < _betAmount.value) {
        _outOfCoins();
      } else {
        bloc.add(StartCountDownEV());
      }
    } else if (bloc.state is CountDownST) {
      bloc.add(BetEV());
    } else if (bloc.state is InGameST) {
      bloc.add(CashOutEV(
        bet: _betAmount.value,
        coef: _currentCoef.value,
      ));
    }
  }

  void _gameStateListener(BuildContext context, GameState state) {
    if (state is CountDownST) {
      _startCountdown();
    } else if (state is InGameST) {
      _coefDeadline = state.deadline;
      _runGame(state.deadline);
    } else if (state is GameFinishedST) {
      context.read<GameBloc>().add(BetEV());
    } else if (state is BetST) {
      _buttonActive = true;
      _startTimer?.cancel();
      _timerValue.value = AppConst.startTimerSeconds;
    }
  }

  void _startCountdown() async {
    _startTimer?.cancel();
    _timerValue.value = 3;
    _startTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_timerValue.value > 1) {
          _timerValue.value -= 1;
        } else {
          timer.cancel();
          context.read<GameBloc>().add(StartGameEV(bet: _betAmount.value));
        }
      },
    );
  }

  void _runGame(double deadline) async {
    final gameBloc = context.read<GameBloc>();
    _currentCoef.value = AppConst.minCoef;

    if (_controller != null && _controller?.artboard != null) {
      startTrigger?.value = true;
      await Future.delayed(AppConst.startGameDelay);

      _autoCashOut();

      if (gameBloc.state is InGameST) {
        _gameTimer = Timer.periodic(AppConst.increasingValueDelay, (timer) {
          if (_currentCoef.value < deadline) {
            _currentCoef.value += AppConst.coefIncreasingStep;
            _autoCashOut();
          } else {
            loseTrigger?.value = true;
            timer.cancel();
            _gameTimer = null;
            if (mounted) {
              setState(() => _buttonActive = false);
            }

            Future.delayed(AppConst.finishGameDelay, () {
              if (mounted) {
                gameBloc.add(FinishGameEV(
                  bet: _betAmount.value,
                  coef: _currentCoef.value,
                ));
                onAnimationInit(_controller!.artboard!);
              }
            });
          }
        });
      }
    }
  }

  void _autoCashOut() {
    final gameBloc = context.read<GameBloc>();
    if (_autoMode && _autoModeCoef.value <= _currentCoef.value && gameBloc.state is InGameST && mounted) {
      gameBloc.add(
        CashOutEV(
          bet: _betAmount.value,
          coef: _currentCoef.value,
        ),
      );
    }
  }

  void _cancelGame() {
    _gameTimer?.cancel();
    _gameTimer = null;

    loseTrigger?.value = true;

    context.read<GameBloc>().add(CancelGameEV(bet: _betAmount.value));
    onAnimationInit(_controller!.artboard!);
  }

  void _outOfCoins() async {
    await AppDialogs.showMainDialog(
      context,
      title: AppTexts.outOfCoins,
      content: AppTexts.youDontHaveEnoughCoins,
      cancelIconTitle: AppTexts.cancel,
    );
  }
}
