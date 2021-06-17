import 'package:flutter/material.dart';

/// Атрибут командировки(Название-Значение)
class MWPAttribute extends StatelessWidget {
  final String _labelAttr;
  final String _valueAttr;
  final double? leftSplitterWidth;

  MWPAttribute(this._labelAttr, this._valueAttr, {this.leftSplitterWidth});

  Widget build(BuildContext context) {
    // print('leftSplitterWidth in MWPAttribute $leftSplitterWidth');
    return Container(
        // width: 200,
        height: 40,
        // child: Expanded(
        // decoration: BoxDecoration(border: Border.all(width: 2)),
        // width: MediaQuery.of(context).size.width/2-100,
        // width: 70,
        // margin: EdgeInsets.all(7),
        child:
            // Expanded(
            //   child:

            Container(
          width: MediaQuery.of(context).size.width / 2 * leftSplitterWidth! -
                      50 >=
                  0
              ? MediaQuery.of(context).size.width / 2 * leftSplitterWidth! - 50
              : 0,
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: '$_labelAttr  ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: _valueAttr,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.visible,
            maxLines: 1,
          ),
        )

        // Container(
        //   // padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
        //     width: MediaQuery.of(context).size.width/2 * leftSplitterWidth! - 50 >= 0 ? MediaQuery.of(context).size.width/2 * leftSplitterWidth! - 50 : 0,
        //     child: Text(

        //       'Очень очень очень длинный текст',

        //       // 'eee',
        //       overflow: TextOverflow.visible,
        //       maxLines: 1,
        //     ),

        // ),
        // )
        // Row(
        //   children: <Widget>[
        //     // width: MediaQuery.of(context).size.width/2 - 30,

        //     // Expanded(
        //     // child:
        //     Container(
        //       // width: 150,
        //       child: Text(
        //         _labelAttr,
        //         style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.normal,
        //         ),
        //         // overflow: TextOverflow.visible,
        //         // maxLines: 1,
        //       ),
        //       // ),
        //     ),
        //     // Container(
        //     //   width: 20,
        //     // ),
        //     // Container(
        //     // width: MediaQuery.of(context).size.width/2 - 30,
        //     // width: 150,
        //     // child:
        //     // Expanded(
        //     //   child:
        //     Container(
        //       // width: 120,
        //       child: Text(
        //         _valueAttr,
        //         style: TextStyle(
        //           fontSize: 22,
        //           fontWeight: FontWeight.bold,
        //         ),
        //         // overflow: TextOverflow.visible,
        //         // maxLines: 1,
        //       ),
        //     ),
        //     // ),
        //     // ),
        //     // Expanded(
        //     //   child: SizedBox(),
        //     // ),
        //   ],
        // ),

        // ),
        );
  }
}
