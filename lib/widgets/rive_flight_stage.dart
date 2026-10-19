import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:updraft_flutter/widgets/flight_scene.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class RiveFlightStage extends ChangeNotifier implements FlightStage {
  RiveFlightStage() {
    _load();
  }

  final FileLoader _loader = FileLoader.fromAsset(Assets.plane, riveFactory: Factory.rive);
  RiveWidgetController? _controller;
  final List<RiveWidgetController> _retired = [];
  bool _takeOffPending = false;
  bool _disposed = false;

  Future<void> _load() async {
    final File file;
    try {
      file = await _loader.file();
    } on RiveFileLoaderException {
      return;
    }
    if (_disposed) return;
    _replaceController(file);
    if (_takeOffPending) takeOff();
  }

  void _replaceController(File file) {
    final previous = _controller;
    _controller = RiveWidgetController(
      file,
      stateMachineSelector: StateMachineSelector.byName(AppConst.animationStateMachine),
    );
    notifyListeners();
    if (previous == null) return;
    _retired.add(previous);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_retired.remove(previous)) previous.dispose();
    });
  }

  void _fire(String trigger) => _controller?.stateMachine.trigger(trigger)?.fire();

  @override
  void takeOff() {
    final file = _loader.fileSync;
    if (file == null || _controller == null) {
      _takeOffPending = true;
      return;
    }
    _takeOffPending = false;
    _replaceController(file);
    _fire(AppConst.startAnimationTrigger);
  }

  @override
  void exit() => _fire(AppConst.finishAnimationTrigger);

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.expand();
    return RiveWidget(
      key: ObjectKey(controller),
      controller: controller,
      fit: Fit.cover,
      alignment: Alignment.centerLeft,
    );
  }

  @override
  void dispose() {
    _disposed = true;
    for (final controller in _retired) {
      controller.dispose();
    }
    _retired.clear();
    _controller?.dispose();
    _loader.dispose();
    super.dispose();
  }
}
