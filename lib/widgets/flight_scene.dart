import 'package:flutter/widgets.dart';

abstract interface class FlightStage implements Listenable {
  Widget build(BuildContext context);

  void takeOff();

  void crash();

  void dispose();
}

class FlightScene extends StatefulWidget {
  const FlightScene({super.key, required this.takeOffRevision, required this.crashRevision, required this.stage});

  final int takeOffRevision;
  final int crashRevision;
  final FlightStage Function() stage;

  @override
  State<FlightScene> createState() => _FlightSceneState();
}

class _FlightSceneState extends State<FlightScene> {
  late final FlightStage _stage = widget.stage();

  @override
  void didUpdateWidget(FlightScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.takeOffRevision != oldWidget.takeOffRevision) _stage.takeOff();
    if (widget.crashRevision != oldWidget.crashRevision) _stage.crash();
  }

  @override
  void dispose() {
    _stage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: _stage, builder: (context, _) => _stage.build(context));
}
