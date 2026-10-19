import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/pages/game/widgets/control_deck.dart';
import 'package:updraft_flutter/pages/game/widgets/flight_screen.dart';
import 'package:updraft_flutter/pages/game/widgets/history_strip.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/dialogs.dart';
import 'package:updraft_flutter/widgets/machine/readout.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends BasePageState<GamePage> {
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(onHide: _pauseInFlight);

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _pauseInFlight() {
    final bloc = context.read<RoundBloc>();
    if (bloc.state.phase == RoundPhase.countdown || bloc.state.phase == RoundPhase.flying) {
      bloc.add(const RoundPaused());
    }
  }

  @override
  PreferredSizeWidget? get appBar => const MainAppbar(trailing: _BalanceReadout());

  @override
  Widget pageBuilder(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (await _leaveRound()) navigator.pop();
      },
      child: MultiBlocListener(
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
        child: const Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.md),
          child: Column(
            children: [
              HistoryStrip(),
              SizedBox(height: AppSpacing.md),
              Expanded(
                child: Center(child: AspectRatio(aspectRatio: 0.92, child: FlightScreen())),
              ),
              SizedBox(height: AppSpacing.lg + AppSizes.dropShadow),
              ControlDeck(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _leaveRound() async {
    final bloc = context.read<RoundBloc>();
    if (bloc.state.phase == RoundPhase.flying) {
      final wasPaused = bloc.state.paused;
      bloc.add(const RoundPaused());
      final confirmed = await AppDialogs.showMainDialog(
        context,
        title: AppTexts.leaveFlight,
        content: AppTexts.leaveFlightContent,
        cancelTitle: AppTexts.stay,
        actionTitle: AppTexts.leave,
        destructive: true,
      );
      if (confirmed != true) {
        if (!wasPaused) bloc.add(const RoundResumed());
        return false;
      }
    }
    bloc.add(const RoundLeft());
    return true;
  }
}

class _BalanceReadout extends StatelessWidget {
  const _BalanceReadout();

  @override
  Widget build(BuildContext context) {
    final balance = context.select((BalanceBloc bloc) => bloc.state.balance);
    return Readout(label: AppTexts.balance, value: Coins.format(balance), alignEnd: true);
  }
}
