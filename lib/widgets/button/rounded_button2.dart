import 'package:MWPX/styles/mwp_colors.dart';
import 'package:flutter/material.dart';

/// Квадратная кнопка с округленными краями
class RoundedButton2 extends StatelessWidget {
  final Widget? child;
  final void Function()? onPressed;
  final Color? color;
  final double width;
  final double height;

  RoundedButton2({
    this.child,
    this.onPressed,
    this.color = MWPColors.mwpButtonCardBackground,
    this.height = 40,
    this.width = 30,
  });

  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: color,
          width: width,
          height: height,
          child: child,
        ),
      ),
    );
  }
}
