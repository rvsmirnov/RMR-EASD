import 'package:flutter/material.dart';

/// Прямоугольная кнопка для Нижней панели РМР
class MWPSquareButton extends StatelessWidget {
  ///Текст на кнопке
  final String _buttonTitle;
  final void Function()? onPressed;
  final Color? borderColor;
  final Color? textColor;

  ///Конструктор
  MWPSquareButton(this._buttonTitle, {this.onPressed, this.borderColor = Colors.white, this.textColor = Colors.white, });

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(7),
        child: OutlineButton(
          borderSide: BorderSide(
            color: borderColor!,
          ),
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          //splashColor: Colors.lightGreen,
          highlightedBorderColor: Colors.green,

          onPressed: onPressed,
          child: Text(
            _buttonTitle,
            style: TextStyle(color: textColor!),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
