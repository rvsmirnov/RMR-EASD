import 'package:flutter/material.dart';

/// Круглая кнопка-иконка для Нижней панели РМР
class MWPCircleButton extends StatelessWidget {
  final Widget? buttonChild;
  final Function()? onPressed;
  final double? borderWidth;
  final Color? borderColor;
  final Color? backgroundColor;
  // индекс 2 это разворот на 180%
  final int? rotationIndex;

  MWPCircleButton({
    this.buttonChild,
    this.onPressed,
    this.borderWidth = 2,
    this.borderColor = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.rotationIndex = 0,
  });

  Widget build(BuildContext context) {
    return OutlinedButton(
      child: RotatedBox(
        quarterTurns: rotationIndex!,
        child: buttonChild!,
      ),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: CircleBorder(),
        side: BorderSide(width: borderWidth!, color: borderColor!),
      ),
    );
  }
}
