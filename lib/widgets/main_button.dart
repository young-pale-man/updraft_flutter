import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stroke_text/stroke_text.dart';

class MainButton extends StatefulWidget {
  const MainButton({
    super.key,
    this.title,
    this.onPressed,
    this.disabled = false,
  });

  final String? title;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> with SingleTickerProviderStateMixin {
  final double _buttonTobSideWidthCoef = 0.985;
  final double _buttonMovementCoef = 0.007;
  final double _topPaddingCoef = 0.004;

  final _disabledFilter = ColorFilter.mode(
    AppColors.shadow.buttonDisabled,
    BlendMode.srcATop,
  );

  late AnimationController _animate;

  VoidCallback? get onTap => widget.onPressed;
  String get title => widget.title ?? '';
  bool get disabled => widget.disabled;

  @override
  void initState() {
    _animate = AnimationController(
      vsync: this,
      duration: AppConst.bounceDuration ~/ 2,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..addListener(() {
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
              child: SvgPicture.asset(
                Assets.mainButtonBase,
                fit: BoxFit.fitWidth,
                colorFilter: disabled ? _disabledFilter : null,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: maxWidth * _topPaddingCoef),
              child: Transform.translate(
                offset: Offset(0, _animate.value * (maxWidth * _buttonMovementCoef)),
                child: GestureDetector(
                  onTap: disabled ? () {} : _onTap,
                  onTapDown: disabled ? (_) {} : _onTapDown,
                  onTapCancel: disabled ? () {} : _onTapCancel,
                  onTapUp: disabled ? (_) {} : (_) => _onTapCancel(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: maxWidth * _buttonTobSideWidthCoef,
                        child: SvgPicture.asset(
                          _animate.value >= (_animate.upperBound * 0.5)
                              ? Assets.mainButtonBodyPressed
                              : Assets.mainButtonBodyDefault,
                          fit: BoxFit.fitWidth,
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

  void _onTap() async {
    _animate.forward();

    onTap?.call();

    Future.delayed(AppConst.bounceDuration, () {
      _animate.reverse();
    });
  }

  void _onTapDown(_) async {
    _animate.forward();
  }

  void _onTapCancel() async {
    _animate.reverse();
  }

  @override
  void dispose() {
    _animate.dispose();
    super.dispose();
  }
}
