import 'package:updraft_flutter/widgets/machine/machine_shell.dart';
import 'package:flutter/material.dart';

abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  bool get topSafeArea => true;

  bool get bottomSafeArea => true;

  PreferredSizeWidget? get appBar => null;

  @override
  Widget build(BuildContext context) {
    return MachineShell(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        body: SafeArea(
          top: topSafeArea,
          bottom: bottomSafeArea,
          child: Builder(builder: pageBuilder),
        ),
      ),
    );
  }

  Widget pageBuilder(BuildContext context);
}
