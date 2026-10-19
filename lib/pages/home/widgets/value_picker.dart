import 'dart:async';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:flutter/material.dart';

class ValuePicker extends StatefulWidget {
  const ValuePicker({
    super.key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.step,
    required this.format,
    required this.onChanged,
    required this.disabled,
  });

  final int value;
  final int minValue;
  final int maxValue;
  final int step;
  final String Function(int value) format;
  final ValueChanged<int> onChanged;
  final bool disabled;

  @override
  State<ValuePicker> createState() => _ValuePickerState();
}

class _ValuePickerState extends State<ValuePicker> {
  Timer? _pickerTimer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MainIconButton(
          height: 50,
          icon: Assets.minus,
          disabled: widget.value <= widget.minValue || widget.disabled,
          onTapDown: widget.disabled ? () {} : () => _adjustValue(-1),
          onRelease: _stopAdjust,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
            decoration: BoxDecoration(
              color: widget.disabled ? Colors.transparent : AppColors.cap,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 2, color: widget.disabled ? AppColors.textDisabled : AppColors.ink),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.format(widget.value),
                  style: AppStyles.figureM.copyWith(color: widget.disabled ? AppColors.textDisabled : AppColors.ink),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        MainIconButton(
          height: 50,
          icon: Assets.plus,
          disabled: widget.value >= widget.maxValue || widget.disabled,
          onTapDown: widget.disabled ? () {} : () => _adjustValue(1),
          onRelease: _stopAdjust,
        ),
      ],
    );
  }

  void _adjustValue(int direction) {
    _pickerTimer?.cancel();
    var held = 0;
    _updateValue(direction, 1);
    _pickerTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      held++;
      _updateValue(direction, 1 + held.clamp(1, 7));
    });
  }

  void _updateValue(int direction, int steps) {
    final next = (widget.value + direction * steps * widget.step).clamp(widget.minValue, widget.maxValue);
    if (next != widget.value) widget.onChanged(next);
  }

  void _stopAdjust() {
    _pickerTimer?.cancel();
    _pickerTimer = null;
  }

  @override
  void dispose() {
    _pickerTimer?.cancel();
    super.dispose();
  }
}
