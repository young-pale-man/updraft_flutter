import 'package:updraft_flutter/pages/home/widgets/value_picker.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:flutter/cupertino.dart';

class AutoModeDisplay extends StatelessWidget {
  const AutoModeDisplay({
    super.key,
    required this.autoMode,
    required this.autoModeCoef,
    required this.switchAutoMode,
  });

  final bool autoMode;
  final ValueNotifier<double> autoModeCoef;
  final ValueChanged<bool> switchAutoMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppTexts.autoMode,
                style: AppStyles.body.body1.copyWith(color: AppColors.text.primary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: scaledSize(35),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: CupertinoSwitch(
                  value: autoMode,
                  onChanged: switchAutoMode,
                  trackColor: AppColors.main.layer4,
                  activeColor: AppColors.system.positive,
                  thumbColor: AppColors.main.background,
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
                valueListenable: autoModeCoef,
                minValue: AppConst.minCoef,
                maxValue: AppConst.maxCoef,
                disabled: !autoMode,
                valueSuffix: 'x',
              ),
            ),
            const SizedBox(width: 12),
            MainIconButton(
              height: scaledSize(50),
              icon: Assets.reset,
              onPressed: _resetAutoModeCoef,
              disabled: !autoMode,
            ),
          ],
        ),
      ],
    );
  }

  void _resetAutoModeCoef() => autoModeCoef.value = AppConst.minCoef;
}
