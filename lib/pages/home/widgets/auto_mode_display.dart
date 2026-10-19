import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/pages/home/widgets/value_picker.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/round_rules.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoModeDisplay extends StatelessWidget {
  const AutoModeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RoundBloc>();
    final disabled = context.select((RoundBloc bloc) => !bloc.state.isReady);
    final autoJump = context.select((RoundBloc bloc) => bloc.state.autoJump);
    final target = context.select((RoundBloc bloc) => bloc.state.target);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppTexts.autoMode,
                style: AppStyles.titleS.copyWith(color: AppColors.ink),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 35,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: CupertinoSwitch(
                  value: autoJump,
                  onChanged: disabled ? null : (value) => bloc.add(AutoJumpChanged(value)),
                  inactiveTrackColor: AppColors.textDisabled,
                  activeTrackColor: AppColors.positive,
                  thumbColor: AppColors.shell,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: ValuePicker(
                value: target,
                minValue: RoundRules.minTarget,
                maxValue: RoundRules.maxTarget,
                step: RoundRules.targetStep,
                format: Coins.formatMultiplier,
                onChanged: (value) => bloc.add(TargetChanged(value)),
                disabled: disabled || !autoJump,
              ),
            ),
            const SizedBox(width: 12),
            MainIconButton(
              height: 50,
              icon: Assets.reset,
              onPressed: () => bloc.add(const TargetChanged(RoundRules.defaultTarget)),
              disabled: disabled || !autoJump,
            ),
          ],
        ),
      ],
    );
  }
}
