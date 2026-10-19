import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:flutter/cupertino.dart';

class ChartRow extends StatelessWidget {
  const ChartRow({super.key, required this.isWin, required this.value});

  final bool isWin;
  final int value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scaledSize(96),
      child: Row(
        children: [
          Container(
            height: scaledSize(14),
            width: scaledSize(14),
            decoration: BoxDecoration(
              color: isWin ? AppColors.system.positive : AppColors.system.negative,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                isWin ? AppTexts.wins : AppTexts.loses,
                style: AppStyles.body.body2.copyWith(color: AppColors.text.primary),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text('${value.toString()}%', style: AppStyles.body.body1.copyWith(color: AppColors.text.primary)),
        ],
      ),
    );
  }
}
