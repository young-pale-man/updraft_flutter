import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/device_info.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class BalanceBar extends StatelessWidget {
  const BalanceBar({
    super.key,
    required this.balance,
  });

  final int balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.main.layer1,
        borderRadius: BorderRadius.circular(isTablet ? 50 : 25),
        border: Border.all(
          width: 2,
          color: AppColors.text.primary,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.coins,
            height: scaledSize(32),
            width: scaledSize(32),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$balance.00',
                  style: AppStyles.header.headerS.copyWith(color: AppColors.text.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
