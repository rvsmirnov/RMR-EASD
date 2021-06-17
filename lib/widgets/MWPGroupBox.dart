import 'package:flutter/material.dart';

/// Рамка для групп элементов экрана Командировок
class MWPGroupBox extends StatelessWidget {
  final String _frameName;
  final Widget _contentWidget;
  final EdgeInsetsGeometry? contentPadding;

  MWPGroupBox(
    this._frameName,
    this._contentWidget, {
    this.contentPadding = const EdgeInsets.all(7),
  });
  //  : this.contentPadding = EdgeInsets.all(7);

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // height: 50,
      // margin: EdgeInsets.all(7),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                // height: 40,
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 226, 226),
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7))),
                child: Container(
                  child: Text(
                    _frameName,
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              ),
            ),

            //Expanded(
            //    child:
            Expanded(
              child: Container(
                // width: 700,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 250, 250, 250),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                padding: contentPadding,
                child: _contentWidget,
              ),
            )
            //)
          ],
        ),
      ),
    );
  }
}
