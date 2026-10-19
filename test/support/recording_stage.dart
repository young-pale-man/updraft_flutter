import 'package:updraft_flutter/widgets/flight_scene.dart';
import 'package:flutter/widgets.dart';

class RecordingStage implements FlightStage {
  final List<String> cues = [];
  bool disposed = false;

  @override
  Widget build(BuildContext context) => const SizedBox.expand();

  @override
  void takeOff() => cues.add('takeOff');

  @override
  void crash() => cues.add('crash');

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void dispose() => disposed = true;
}
