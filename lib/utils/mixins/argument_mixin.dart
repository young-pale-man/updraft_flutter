import 'package:flutter/material.dart';

mixin ArgumentMixin<S extends StatefulWidget, Argument> on State<S> {
  late Argument argument;

  bool _isExtracted = false;

  @override
  void didChangeDependencies() {
    if (!_isExtracted) {
      _isExtracted = true;
      _extractArgument();
    }
    super.didChangeDependencies();
  }

  void _extractArgument() {
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is Argument) {
      this.argument = argument;
      onArgumentExtracted(argument);
    }
  }

  void onArgumentExtracted(Argument argument) {}
}
