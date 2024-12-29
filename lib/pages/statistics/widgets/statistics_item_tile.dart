import 'package:updraft_flutter/data/models/statistics_item_model.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/extensions/date_format_ext.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class StatisticsItemTile extends StatelessWidget {
  const StatisticsItemTile({
    super.key,
    required this.statisticsItem,
  });

  final StatisticsItemModel statisticsItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(statisticsItem.id),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.main.layer1,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          width: 2,
          color: AppColors.main.layer2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            statisticsItem.date?.formatStatisticsTime() ?? '',
            style: AppStyles.body.body2.copyWith(color: AppColors.text.secondary),
          ),
          const SizedBox(width: 6),
          Text(
            '${statisticsItem.coef?.toStringAsFixed(1) ?? ''}x',
            style: AppStyles.body.body1.copyWith(color: AppColors.text.primary),
          ),
          const SizedBox(width: 6),
          Text(
            '${AppTexts.bet}: ${statisticsItem.bet?.toStringAsFixed(1) ?? ''}',
            style: AppStyles.body.body2.copyWith(color: AppColors.text.primary),
          ),
          const SizedBox(width: 6),
          if (statisticsItem.isWin != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  statisticsItem.result?.toStringAsFixed(1) ?? '',
                  style: AppStyles.body.body1.copyWith(
                    color: statisticsItem.isWin! ? AppColors.system.positive : AppColors.system.negative,
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  statisticsItem.isWin! ? Assets.statisticsWin : Assets.statisticsLose,
                  height: scaledSize(24),
                  width: scaledSize(24),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
