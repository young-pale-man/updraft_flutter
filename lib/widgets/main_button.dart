import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stroke_text/stroke_text.dart';

class MainButton extends StatefulWidget {
  const MainButton({super.key, this.title, this.onPressed, this.disabled = false});

  final String? title;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> with SingleTickerProviderStateMixin {
  static const double _buttonHeightToWidthCoef = 0.19;
  static const double _buttonTopSideWidthToWidthCoef = 0.987;
  static const double _buttonTopSideHeightToWidthCoef = 0.152;
  static const double _buttonMovementToWidthCoef = 0.007;
  static const double _topPaddingToWidthCoef = 0.005;

  final _disabledFilter = ColorFilter.mode(AppColors.shadow.buttonDisabled, BlendMode.srcATop);

  late AnimationController _animate;

  VoidCallback? get onTap => widget.onPressed;
  String get title => widget.title ?? '';
  bool get disabled => widget.disabled;

  @override
  void initState() {
    _animate =
        AnimationController(vsync: this, duration: AppConst.bounceDuration ~/ 2, lowerBound: 0.0, upperBound: 1.0)
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              width: maxWidth,
              height: maxWidth * _buttonHeightToWidthCoef,
              child: SvgPicture.asset(
                Assets.mainButtonBase,
                fit: BoxFit.cover,
                colorFilter: disabled ? _disabledFilter : null,
                clipBehavior: Clip.none,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: maxWidth * _topPaddingToWidthCoef),
              child: Transform.translate(
                offset: Offset(0, _animate.value * (maxWidth * _buttonMovementToWidthCoef)),
                child: GestureDetector(
                  onTap: disabled ? () {} : _onTap,
                  onTapDown: disabled ? (_) {} : _onTapDown,
                  onTapCancel: disabled ? () {} : _onTapCancel,
                  onTapUp: disabled ? (_) {} : (_) => _onTapCancel(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: maxWidth * _buttonTopSideWidthToWidthCoef,
                        height: maxWidth * _buttonTopSideHeightToWidthCoef,
                        child: SvgPicture.asset(
                          _animate.value >= (_animate.upperBound * 0.5)
                              ? Assets.mainButtonBodyPressed
                              : Assets.mainButtonBodyDefault,
                          fit: BoxFit.cover,
                          colorFilter: disabled ? _disabledFilter : null,
                        ),
                      ),
                      StrokeText(
                        text: title,
                        textStyle: AppStyles.header.headerM.copyWith(
                          color: disabled ? AppColors.tertiary.tertiary1 : AppColors.main.background,
                        ),
                        strokeWidth: 1.8,
                        strokeColor: AppColors.accent.primary2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onTap() {
    _animate.forward();
    onTap?.call();
    Future.delayed(AppConst.bounceDuration, () {
      _animate.reverse();
    });
  }

  void _onTapDown(_) {
    _animate.forward();
  }

  void _onTapCancel() {
    _animate.reverse();
  }

  @override
  void dispose() {
    _animate.dispose();
    super.dispose();
  }
}
