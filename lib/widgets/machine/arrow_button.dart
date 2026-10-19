import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/widgets/machine/pressable.dart';
import 'package:flutter/widgets.dart';

class ArrowButton extends StatelessWidget {
  const ArrowButton({
    super.key,
    required this.direction,
    required this.label,
    this.onStep,
    this.enabled = true,
    this.size = AppSizes.arrowButton,
  });

  final AxisDirection direction;
  final String label;
  final VoidCallback? onStep;
  final bool enabled;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      label: label,
      onPressed: onStep,
      enabled: enabled,
      repeats: true,
      builder: (context, pressed) => CustomPaint(
        size: Size(size * 0.82, size + AppSizes.capTravel),
        painter: _ArrowPainter(direction: direction, pressed: pressed, enabled: enabled),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({required this.direction, required this.pressed, required this.enabled});

  final AxisDirection direction;
  final bool pressed;
  final bool enabled;

  Path _triangle(Size size, double top) {
    const inset = AppSizes.outline;
    final height = size.height - AppSizes.capTravel;
    final left = direction == AxisDirection.left;
    final tipX = left ? inset : size.width - inset;
    final baseX = left ? size.width - inset : inset;
    return Path()
      ..moveTo(tipX, top + height / 2)
      ..lineTo(baseX, top + inset)
      ..lineTo(baseX, top + height - inset)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.outline
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.ink;
    final shade = _triangle(size, AppSizes.capTravel);
    canvas.drawPath(shade, Paint()..color = enabled ? AppColors.capShade : AppColors.capShadeDisabled);
    canvas.drawPath(shade, outline);
    final cap = _triangle(size, pressed ? AppSizes.capTravel : 0);
    canvas.drawPath(cap, Paint()..color = enabled ? AppColors.cap : AppColors.capDisabled);
    canvas.drawPath(cap, outline);
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) =>
      oldDelegate.pressed != pressed || oldDelegate.enabled != enabled || oldDelegate.direction != direction;
}
