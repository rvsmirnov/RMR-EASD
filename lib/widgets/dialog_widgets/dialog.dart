import 'package:MWPX/styles/mwp_colors.dart';
import 'package:MWPX/widgets/button/circlebutton.dart';
import 'package:MWPX/widgets/button/elevated_button.dart';
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

  static Future<dynamic> inputDialog({
    context,
    String? title,
    String? content,
    Function? onPressed,
  }) {
    TextEditingController controller = TextEditingController(
      text: content,
    );
    return showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 250, 250),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: TextField(
                    minLines: 3,
                    autofocus: true,
                    controller: controller,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(7, 0, 7, 3),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MWPElevatedButton(
                      onPressed: () {
                        onPressed!(controller.text);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 60,
                        child: Center(
                          child: Text(
                            'Ok',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    MWPElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 60,
                        child: Center(
                          child: Text(
                            'Отмена',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<dynamic> infoDialogRK({
    context,
    Widget? titleWidget,
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
          scrollable: true,
          title:
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child:
              titleWidget,
          // ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          actions: [
            Center(
              child: MWPSquareButton(
                'Закрыть',
                borderColor: Colors.black,
                textColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
          content:
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child:
              Container(
            decoration: BoxDecoration(
                // border: Border(
                //   top: BorderSide(
                //     width: 1,
                //     color: Colors.black,
                //   ),
                // ),
                ),
            // width: 800,
            // width: MediaQuery.of(context).size.width * 0.8,
            // width: MediaQuery.of(context).size.width * leftSplitterWidth!,
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: content!,
          ),
          // ),
          // ),
        );
      },
    );
  }

  static Future<dynamic> infoDialogDark({
    context,
    // String? title,
    Widget? content,
    void Function()? buttonFunction,
    String? buttonName = '',
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
          backgroundColor: MWPColors.mwpColorDark,
          // title: Center(child: Text(title!)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          actions: [
            Container(
              color: MWPColors.mwpColorDark,
              child: Center(
                child: MWPSquareButton(
                  buttonName!,
                  onPressed: () {
                    buttonFunction!;
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

  static Future<dynamic> infoDialogDarkWithRoundButton({
    context,
    // String? title,
    Widget? content,
    void Function()? buttonFunction,
    String? buttonName = '',
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
          backgroundColor: MWPColors.mwpColorDark,
          // title: Center(child: Text(title!)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          actions: [
            Center(
              child: MWPCircleButton(
                backgroundColor: Colors.transparent,
                buttonChild: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                borderWidth: 2,
                borderColor: Colors.white,
              ),
            ),
          ],
          content: Container(
            // width: 800,
            width: MediaQuery.of(context).size.width * 0.4,
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: content!,
          ),

          // ),
        );
      },
    );
  }

  static Future<dynamic> infoDialogDarkWithChoice({
    context,
    // String? title,
    Widget? content,
    void Function()? buttonFunction,
    String? buttonName = '',
  }) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          backgroundColor: MWPColors.mwpColorDark,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MWPCircleButton(
                  backgroundColor: Colors.transparent,
                  buttonChild: Text(
                    'Да',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  borderWidth: 2,
                  borderColor: Colors.white,
                ),
                MWPCircleButton(
                  backgroundColor: Colors.transparent,
                  buttonChild: Text(
                    'Нет',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  borderWidth: 2,
                  borderColor: Colors.white,
                ),
              ],
            ),
          ],
          content: Container(
            // width: 800,
            width: MediaQuery.of(context).size.width * 0.4,
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: content!,
          ),
          // ),
        );
      },
    );
  }
}
