
import 'package:flutter/material.dart';

/// Прямоугольная кнопка для Нижней панели РМР
class MWPSquareButton extends StatelessWidget {

  ///Текст на кнопке
  final String _buttonTitle;

  ///Конструктор
  MWPSquareButton(this._buttonTitle);

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(7),
        child: OutlineButton(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          //splashColor: Colors.lightGreen,
          highlightedBorderColor: Colors.green,

          onPressed: () {},
          child: Text(
            _buttonTitle,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ));
  }
}