import 'package:updraft_flutter/res/colors.dart';
import 'package:flutter/material.dart';

abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  bool get topSafeArea => true;

  bool get bottomSafeArea => true;

  PreferredSizeWidget? get appBar => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.shell,
      child: Scaffold(
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
