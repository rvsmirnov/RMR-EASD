import 'package:flutter/material.dart';

/// Круглая кнопка-иконка для Нижней панели РМР
class MWPCircleButton extends StatelessWidget {

  final IconData _buttonIcon;

  MWPCircleButton(this._buttonIcon);

  Widget build(BuildContext context) {
    return OutlineButton(
        child: Icon(_buttonIcon, color: Colors.white),
        onPressed: () {},
        borderSide: BorderSide(width: 2, color: Colors.white),
        shape: CircleBorder());
  }
}
