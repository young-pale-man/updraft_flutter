import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/pages/game/widgets/flight_hud.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:updraft_flutter/widgets/flight_scene.dart';
import 'package:updraft_flutter/widgets/machine/screen_panel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlightScreen extends StatelessWidget {
  const FlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPanel(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.slab),
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.ink, width: AppSizes.hairline),
            borderRadius: BorderRadius.circular(AppRadii.slab),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: FlightScene(
                  takeOffRevision: context.select((RoundBloc bloc) => bloc.state.takeOffRevision),
                  crashRevision: context.select((RoundBloc bloc) => bloc.state.crashRevision),
                  stage: context.read<AppDependencies>().flightStage,
                ),
              ),
              const Positioned.fill(child: FlightHud()),
            ],
          ),
        ),
      ),
    );
  }
}
