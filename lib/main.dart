import 'package:updraft_flutter/application.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveNative.init();
  final dependencies = await DependencyInitializer.initDependencies();

  runApp(Application(dependencies: dependencies));
}
