import 'package:MWPX/styles/mwp_colors.dart';
import 'package:MWPX/widgets/button/circlebutton.dart';
import 'package:MWPX/widgets/button/squarebutton.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<dynamic> errorDialog({
    context,
    Widget? content,
  }) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext buildContext) {
        return Theme(
          data: Theme.of(context).copyWith(
              dialogBackgroundColor: Colors.grey[800],
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                color: Colors.white,
              ))),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            actions: [
              Center(
                child: MWPCircleButton(
                  buttonChild: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
            content: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: content!,
            ),
          ),
        );
      },
    );
  }

  static Future<dynamic> infoDialog({
    context,
    String? title,
    Widget? content,
  }) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext buildContext) {
        return 
        // Theme(
        //   data: Theme.of(context).copyWith(
        //       // dialogBackgroundColor: Colors.white,
        //       textTheme: TextTheme(
        //           bodyText1: TextStyle(
        //         // color: Colors.black87,
        //       ))),
        //   child: 
          AlertDialog(
            title: Center(child: Text(title!)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            actions: [
              Container(
                color: MWPColors.mwpColorDark,
                child: Center(
                  child: MWPSquareButton(
                    'Закрыть',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
            content: Container(
              // width: 800,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: content!,
            ),
          // ),
        );
      },
    );
  }
}
