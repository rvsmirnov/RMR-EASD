import 'package:flutter/material.dart';

/// Атрибут командировки(Название-Значение)
class MWPAttribute extends StatelessWidget {
  final String _labelAttr;
  final String _valueAttr;

  MWPAttribute(this._labelAttr, this._valueAttr);

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(7),
        child: Row(
          children: <Widget>[
            Text(
              _labelAttr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            Container(
              width: 20,
            ),
            Text(_valueAttr,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
          ],
        ));
  }
}