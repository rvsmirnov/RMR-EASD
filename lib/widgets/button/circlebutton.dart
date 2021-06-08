import 'package:flutter/material.dart';

/// Круглая кнопка-иконка для Нижней панели РМР
class MWPCircleButton extends StatelessWidget {
  final Widget? buttonChild;
  final Function()? onPressed;

  MWPCircleButton({this.buttonChild, this.onPressed});

  Widget build(BuildContext context) {
    return OutlinedButton(
      child: buttonChild!,
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        side: BorderSide(width: 2, color: Colors.white),
      ),
    );
  }
}
