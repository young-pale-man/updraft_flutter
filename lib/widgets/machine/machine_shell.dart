import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:flutter/widgets.dart';

class MachineShell extends StatelessWidget {
  const MachineShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: const _CheckerPainter(), child: child);
  }
}

class _CheckerPainter extends CustomPainter {
  const _CheckerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.shell);
    final alt = Paint()..color = AppColors.shellAlt;
    const cell = AppSizes.checker;
    for (var row = 0; row * cell < size.height; row++) {
      for (var column = row.isEven ? 1 : 0; column * cell < size.width; column += 2) {
        canvas.drawRect(Rect.fromLTWH(column * cell, row * cell, cell, cell), alt);
      }
    }
  }

  @override
  bool shouldRepaint(_CheckerPainter oldDelegate) => false;
}
