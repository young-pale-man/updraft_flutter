import 'package:updraft_flutter/res/assets.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class MainIconButton extends StatefulWidget {
  const MainIconButton({
    super.key,
    required this.height,
    this.icon,
    this.onPressed,
    this.onTapDown,
    this.onRelease,
    this.disabled = false,
  });

  final double height;
  final String? icon;
  final VoidCallback? onPressed;
  final VoidCallback? onTapDown;
  final VoidCallback? onRelease;
  final bool disabled;

  @override
  State<MainIconButton> createState() => _MainIconButtonState();
}

class _MainIconButtonState extends State<MainIconButton> with SingleTickerProviderStateMixin {
  final _disabledFilter = ColorFilter.mode(
    AppColors.shadow.buttonDisabled,
    BlendMode.srcATop,
  );

  late final double _buttonHeight = widget.height;
  late final double _buttonWidth = widget.height * 0.96;
  late final double _buttonTopSideHeight = widget.height * 0.815;
  late final double _buttonTopSideWidth = widget.height * 0.876;
  late final double _buttonMoveHeight = widget.height * 0.05;
  late final double _buttonTopPadding = widget.height * 0.015;
  late final double _iconSize = widget.height * 0.64;

  late AnimationController _animate;

  VoidCallback? get onPressed => widget.onPressed;
  VoidCallback? get onTapDown => widget.onTapDown;
  VoidCallback? get onRelease => widget.onRelease;
  String? get icon => widget.icon;
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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: _buttonHeight,
          width: _buttonWidth,
          child: SvgPicture.asset(
            Assets.iconButtonBase,
            fit: BoxFit.fill,
            colorFilter: disabled ? _disabledFilter : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: _buttonTopPadding),
          child: Transform.translate(
            offset: Offset(0, _animate.value * _buttonMoveHeight),
            child: GestureDetector(
              onTap: _onTap,
              onTapDown: _onTapDown,
              onTapCancel: _onTapCancel,
              onTapUp: (_) => _onTapCancel(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: _buttonTopSideHeight,
                    width: _buttonTopSideWidth,
                    child: SvgPicture.asset(
                      _animate.value >= (_animate.upperBound * 0.5)
                          ? Assets.iconButtonBodyPressed
                          : Assets.iconButtonBodyDefault,
                      fit: BoxFit.fill,
                      colorFilter: disabled ? _disabledFilter : null,
                    ),
                  ),
                  if (icon != null)
                    SvgPicture.asset(
                      icon!,
                      height: _iconSize,
                      width: _iconSize,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onTap() async {
    _animate.forward();

    onPressed?.call();

    Future.delayed(AppConst.bounceDuration, () {
      _animate.reverse();
    });
  }

  void _onTapDown(_) async {
    onTapDown?.call();
    _animate.forward();
  }

  void _onTapCancel() async {
    onRelease?.call();
    _animate.reverse();
  }

  @override
  void dispose() {
    _animate.dispose();
    super.dispose();
  }
}
