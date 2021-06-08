import 'package:MWPX/widgets/button/circlebutton.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<dynamic> infoDialog({
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
}
