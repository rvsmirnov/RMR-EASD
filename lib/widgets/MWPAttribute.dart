import 'package:flutter/material.dart';

/// Атрибут командировки(Название-Значение)
class MWPAttribute extends StatelessWidget {
  final String _labelAttr;
  final String _valueAttr;
  // final double? leftSplitterWidth;
  final double? containerWidth;

  MWPAttribute(this._labelAttr, this._valueAttr, {this.containerWidth});

  Widget build(BuildContext context) {
    // print('leftSplitterWidth in MWPAttribute $leftSplitterWidth');
    return Container(
      // color: Colors.yellow,
      // padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      // height: 60,
      child: Container(
        width: containerWidth!,
        // width:
        //     MediaQuery.of(context).size.width / 2 * leftSplitterWidth! - 50 >= 0
        //         ? MediaQuery.of(context).size.width / 2 * leftSplitterWidth! -
        //             50
        //         : 0,
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
          // overflow: TextOverflow.visible,
          maxLines: 2,
        ),
      ),
    );
  }
}
