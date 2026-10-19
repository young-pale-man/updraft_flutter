import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomChart extends StatelessWidget {
  const CustomChart({super.key, required this.radius, required this.percentValue, this.chartColor, this.child});

  final double radius;
  final double percentValue;
  final Color? chartColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: 8,
      percent: percentValue * 0.01,
      arcBackgroundColor: AppColors.ink,
      backgroundColor: AppColors.ink,
      progressColor: chartColor,
      circularStrokeCap: CircularStrokeCap.round,
      arcType: ArcType.FULL,
      center: child,
    );
  }
}
