import 'dart:async';
import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:updraft_flutter/widgets/main_icon_button.dart';
import 'package:flutter/material.dart';

class ValuePicker extends StatefulWidget {
  const ValuePicker({
    super.key,
    required this.valueListenable,
    required this.minValue,
    required this.maxValue,
    required this.disabled,
    this.valueSuffix = '',
  });

  final ValueNotifier valueListenable;
  final double minValue;
  final double maxValue;
  final bool disabled;
  final String valueSuffix;

  @override
  State<ValuePicker> createState() => _ValuePickerState();
}

class _ValuePickerState extends State<ValuePicker> {
  Timer? _pickerTimer;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.valueListenable,
      builder: (_, _, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MainIconButton(
            height: 50,
            icon: Assets.minus,
            disabled: widget.valueListenable.value == widget.minValue || widget.disabled,
            onTapDown: widget.disabled ? () {} : () => _adjustValue(-1),
            onRelease: _stopAdjust,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
              decoration: BoxDecoration(
                color: widget.disabled ? Colors.transparent : AppColors.main.layer1,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  width: 2,
                  color: widget.disabled ? AppColors.tertiary.tertiary1 : AppColors.text.primary,
                ),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${widget.valueListenable.value.toStringAsFixed(1)}${widget.valueSuffix}',
                    style: AppStyles.header.headerS.copyWith(
                      color: widget.disabled ? AppColors.tertiary.tertiary1 : AppColors.text.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          MainIconButton(
            height: 50,
            icon: Assets.plus,
            disabled: widget.valueListenable.value == widget.maxValue || widget.disabled,
            onTapDown: widget.disabled ? () {} : () => _adjustValue(1),
            onRelease: _stopAdjust,
          ),
        ],
      ),
    );
  }

  void _adjustValue(int direction) {
    _pickerTimer?.cancel();

    double step = AppConst.valuePickerStep;
    int elapsedTicks = 0;

    _updateValue(direction);

    _pickerTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      elapsedTicks++;
      step = 0.1 + (elapsedTicks * 0.1).clamp(0.1, 0.7);
      _updateValue(direction, step);
    });
  }

  void _updateValue(int direction, [double step = AppConst.valuePickerStep]) {
    final currentValue = widget.valueListenable.value;
    final newValue = (currentValue + direction * step).clamp(widget.minValue, widget.maxValue);
    if (newValue != currentValue) {
      widget.valueListenable.value = newValue;
    }
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
