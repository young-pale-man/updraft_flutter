import 'package:updraft_flutter/data/enums/statistics_parameter.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:flutter/cupertino.dart';

class StatisticsParameterPicker extends StatelessWidget {
  const StatisticsParameterPicker({
    super.key,
    required this.parameter,
    required this.changeParameter,
  });

  final StatisticsParameter parameter;
  final ValueChanged<int> changeParameter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MainIconButton(
          height: scaledSize(46),
          disabled: parameter.index == 0,
          onPressed: () => _changeParameter(-1),
          icon: Assets.arrowLeft,
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              parameter.title,
              style: AppStyles.header.headerXS.copyWith(color: AppColors.text.primary),
            ),
          ),
        ),
        MainIconButton(
          height: scaledSize(46),
          disabled: parameter.index == StatisticsParameter.values.last.index,
          onPressed: () => _changeParameter(1),
          icon: Assets.arrowRight,
        ),
      ],
    );
  }

  void _changeParameter(int value) {
    final newIndex = parameter.index + value;
    if (newIndex >= 0 && newIndex <= StatisticsParameter.values.last.index) {
      changeParameter(newIndex);
    }
  }
}
