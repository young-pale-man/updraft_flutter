import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/widgets.dart';

class OutlinedText extends StatelessWidget {
  const OutlinedText(
    this.text, {
    super.key,
    required this.style,
    this.fill = AppColors.figure,
    this.outline = AppColors.ink,
    this.width = 5,
    this.shadows = const [],
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final Color fill;
  final Color outline;
  final double width;
  final List<Shadow> shadows;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeJoin = StrokeJoin.round
      ..color = outline;
    return Stack(
      children: [
        ExcludeSemantics(
          child: Text(
            text,
            textAlign: textAlign,
            style: style.copyWith(foreground: stroke, shadows: shadows),
          ),
        ),
        Text(
          text,
          textAlign: textAlign,
          style: style.copyWith(color: fill),
        ),
      ],
    );
  }
}
