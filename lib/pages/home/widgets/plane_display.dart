import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class PlaneDisplay extends StatefulWidget {
  const PlaneDisplay({super.key, required this.onInit, required this.overlay});

  final ValueChanged<StateMachine> onInit;
  final Widget overlay;

  @override
  State<PlaneDisplay> createState() => _PlaneDisplayState();
}

class _PlaneDisplayState extends State<PlaneDisplay> {
  final _fileLoader = FileLoader.fromAsset(Assets.plane, riveFactory: Factory.rive);

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              border: Border.all(width: 2, color: AppColors.text.primary),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(42),
              child: RiveWidgetBuilder(
                fileLoader: _fileLoader,
                stateMachineSelector: StateMachineSelector.byName(AppConst.animationStateMachine),
                onLoaded: (state) => widget.onInit(state.controller.stateMachine),
                builder: (context, state) => switch (state) {
                  RiveLoaded() => RiveWidget(
                    controller: state.controller,
                    fit: Fit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
          ),
        ),
        Positioned.fill(child: widget.overlay),
      ],
    );
  }
}
