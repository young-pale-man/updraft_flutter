import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.label,
    required this.builder,
    this.onPressed,
    this.enabled = true,
    this.repeats = false,
  });

  final String label;
  final Widget Function(BuildContext context, bool pressed) builder;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool repeats;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  static const Duration _holdDelay = Duration(milliseconds: 350);

  bool _pressed = false;
  Timer? _repeater;
  int _repeated = 0;

  bool get _active => widget.enabled && widget.onPressed != null;

  void _down() {
    if (!_active) return;
    setState(() => _pressed = true);
    HapticFeedback.selectionClick();
    if (widget.repeats) {
      _repeated = 0;
      _repeater = Timer(_holdDelay, _repeat);
    }
  }

  void _repeat() {
    _repeated++;
    widget.onPressed?.call();
    final interval = Duration(milliseconds: (140 - _repeated * 10).clamp(45, 140));
    _repeater = Timer(interval, _repeat);
  }

  void _release({required bool fire}) {
    _repeater?.cancel();
    _repeater = null;
    if (!_pressed) return;
    setState(() => _pressed = false);
    if (fire && _active && _repeated == 0) widget.onPressed?.call();
  }

  @override
  void didUpdateWidget(Pressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_active && _pressed) _release(fire: false);
  }

  @override
  void dispose() {
    _repeater?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: _active,
      label: widget.label,
      excludeSemantics: true,
      onTap: _active ? widget.onPressed : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _down(),
        onTapUp: (_) => _release(fire: true),
        onTapCancel: () => _release(fire: false),
        child: widget.builder(context, _pressed),
      ),
    );
  }
}
