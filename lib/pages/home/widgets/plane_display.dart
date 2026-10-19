import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/widgets.dart';

class PlaneDisplay extends StatelessWidget {
  const PlaneDisplay({super.key, required this.scene, required this.overlay});

  final Widget scene;
  final Widget overlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44),
        border: Border.all(width: 2, color: AppColors.text.primary),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(42),
        child: Stack(
          children: [
            Positioned.fill(child: scene),
            Positioned.fill(child: overlay),
          ],
        ),
      ),
    );
  }
}
