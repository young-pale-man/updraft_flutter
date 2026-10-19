import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/utils/extensions/date_format_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class StatisticsItemTile extends StatelessWidget {
  const StatisticsItemTile({super.key, required this.statisticsItem});

  final RoundRecord statisticsItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.main.layer1,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(width: 2, color: AppColors.main.layer2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            statisticsItem.time.formatStatisticsTime(),
            style: AppStyles.body.body2.copyWith(color: AppColors.text.secondary),
          ),
          const SizedBox(width: 6),
          Text(
            Coins.formatMultiplier(statisticsItem.multiplier),
            style: AppStyles.body.body1.copyWith(color: AppColors.text.primary),
          ),
          const SizedBox(width: 6),
          Text(Coins.format(statisticsItem.entry), style: AppStyles.body.body2.copyWith(color: AppColors.text.primary)),
          const SizedBox(width: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                Coins.formatChange(statisticsItem.change),
                style: AppStyles.body.body1.copyWith(
                  color: statisticsItem.jumped ? AppColors.system.positive : AppColors.system.negative,
                ),
              ),
              const SizedBox(width: 4),
              SvgPicture.asset(
                statisticsItem.jumped ? Assets.statisticsWin : Assets.statisticsLose,
                height: 24,
                width: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
