import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/svg.dart';

class ParameterTile extends StatelessWidget {
  const ParameterTile({super.key, required this.title, required this.icon, required this.onPressed});

  final String title;
  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: onPressed,
      duration: AppConst.bounceDuration,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.cap,
          borderRadius: BorderRadius.circular(39),
          border: Border.all(width: 2, color: AppColors.ink),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, height: 24, width: 24),
            const SizedBox(width: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(title, style: AppStyles.titleS.copyWith(color: AppColors.ink)),
            ),
          ],
        ),
      ),
    );
  }
}
