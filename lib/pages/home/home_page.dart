import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/data/enums/navigation_menu_items.dart';
import 'package:updraft_flutter/pages/home/widgets/coef_display.dart';
import 'package:updraft_flutter/pages/home/widgets/home_appbar_content.dart';
import 'package:updraft_flutter/pages/home/widgets/home_pickers_layout.dart';
import 'package:updraft_flutter/pages/home/widgets/plane_display.dart';
import 'package:updraft_flutter/pages/home/widgets/timer_display.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/balance_rules.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:updraft_flutter/utils/dialogs.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:updraft_flutter/widgets/flight_scene.dart';
import 'package:updraft_flutter/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  @override
  PreferredSizeWidget? get appBar =>
      MainAppbar(currentPage: NavigationMenuItems.home, content: const HomeAppbarContent(), canOpenMenu: _leaveRound);

  @override
  Widget pageBuilder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocListener(
      listeners: [
        BlocListener<RoundBloc, RoundState>(
          listenWhen: (previous, current) => previous.takeOffRevision != current.takeOffRevision,
          listener: (context, state) => HapticFeedback.lightImpact(),
        ),
        BlocListener<RoundBloc, RoundState>(
          listenWhen: (previous, current) => previous.jumpRevision != current.jumpRevision,
          listener: (context, state) => HapticFeedback.mediumImpact(),
        ),
        BlocListener<RoundBloc, RoundState>(
          listenWhen: (previous, current) => previous.crashRevision != current.crashRevision,
          listener: (context, state) => HapticFeedback.heavyImpact(),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: screenWidth < 580 ? screenWidth : 580, maxWidth: 900),
                  child: PlaneDisplay(
                    scene: FlightScene(
                      takeOffRevision: context.select((RoundBloc bloc) => bloc.state.takeOffRevision),
                      crashRevision: context.select((RoundBloc bloc) => bloc.state.crashRevision),
                      stage: context.read<AppDependencies>().flightStage,
                    ),
                    overlay: const _FlightOverlay(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 11),
            const HomePickersLayout(),
            const SizedBox(height: 32),
            Center(
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 580), child: const _RoundButton()),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<bool> _leaveRound() async {
    final bloc = context.read<RoundBloc>();
    if (bloc.state.phase == RoundPhase.flying) {
      final confirmed = await AppDialogs.showMainDialog(
        context,
        title: AppTexts.leaveFlight,
        content: AppTexts.leaveFlightContent,
        cancelIconTitle: AppTexts.stay,
        actionButtonTitle: AppTexts.leave,
        isActionDestructive: true,
      );
      if (confirmed != true) return false;
    }
    bloc.add(const RoundLeft());
    return true;
  }
}

class _FlightOverlay extends StatelessWidget {
  const _FlightOverlay();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RoundBloc>().state;
    return switch (state.phase) {
      RoundPhase.ready => const SizedBox.shrink(),
      RoundPhase.countdown => Center(child: TimerDisplay(timerValue: state.secondsLeft)),
      _ => Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CoefDisplay(multiplier: state.multiplier, flewAway: state.phase == RoundPhase.crashed),
        ),
      ),
    };
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RoundBloc>().state;
    final balance = context.select((BalanceBloc bloc) => bloc.state.balance);
    final round = context.read<RoundBloc>();
    return switch (state.phase) {
      RoundPhase.ready when BalanceRules.needsRefill(balance) => MainButton(
        title: AppTexts.refill,
        onPressed: () => context.read<BalanceBloc>().add(const BalanceRefilled()),
      ),
      RoundPhase.ready => MainButton(
        title: AppTexts.play,
        onPressed: () => round.add(const PlayPressed()),
        disabled: !BalanceRules.canEnter(balance: balance, entry: state.entry),
      ),
      RoundPhase.countdown => MainButton(
        title: AppTexts.cancel,
        onPressed: () => round.add(const CountdownCancelled()),
      ),
      RoundPhase.flying => MainButton(
        title: '${AppTexts.jump} · ${Coins.format(state.livePayout)}',
        onPressed: () => round.add(const JumpPressed()),
      ),
      _ => const MainButton(title: AppTexts.jump, disabled: true),
    };
  }
}
