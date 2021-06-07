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
              content: content,
            ));
      },
    );
  }
}
