import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:flutter/cupertino.dart';

class ChartRow extends StatelessWidget {
  const ChartRow({super.key, required this.isWin, required this.value});

  final bool isWin;
  final int value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Row(
        children: [
          Container(
            height: 14,
            width: 14,
            decoration: BoxDecoration(color: isWin ? AppColors.positive : AppColors.negative, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                isWin ? AppTexts.wins : AppTexts.loses,
                style: AppStyles.bodyL.copyWith(color: AppColors.ink),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text('${value.toString()}%', style: AppStyles.titleS.copyWith(color: AppColors.ink)),
        ],
      ),
    );
  }
}
