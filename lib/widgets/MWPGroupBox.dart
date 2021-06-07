import 'package:flutter/material.dart';

/// Рамка для групп элементов экрана Командировок
class MWPGroupBox extends StatelessWidget {
  final String _frameName;
  final Widget _contentWidget;

  MWPGroupBox(this._frameName, this._contentWidget);

  Widget build(BuildContext context)
  {
    return Container(
      margin: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 226, 226),
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(7),topRight: Radius.circular(7))),
                child: Text(_frameName,style: TextStyle(fontSize: 20),),
              )
          ),
          //Expanded(
          //    child:
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              border: Border.all(color: Colors.black, width: 1),
            ),
            padding: EdgeInsets.all(7),
            child: _contentWidget,
          )
          //)
        ],
      ),
    );
  }
}