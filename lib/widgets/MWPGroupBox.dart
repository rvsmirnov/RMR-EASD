import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';

/// Рамка для групп элементов экрана Командировок
class MWPGroupBox extends StatelessWidget {
  final String _frameName;
  final Widget? _contentWidget;
  final EdgeInsetsGeometry? contentPadding;
  final bool? titleDecorationOn;
  final bool? infoDialogIconOn;
  final List<Widget>? buttonsList;
  // Отдельный контент для диалога для случая с динамической шириной виджетов,
  // Чтобы в диалоге показывался полный размер
  final Widget? contentWidgetForDialog;

  MWPGroupBox(
    this._frameName,
    this._contentWidget, {
    this.contentPadding = const EdgeInsets.all(7),
    this.titleDecorationOn = true,
    this.infoDialogIconOn = true,
    this.contentWidgetForDialog,
    this.buttonsList = const <Widget>[],
  });

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      // height: 40,
                      padding: EdgeInsets.all(7),
                      decoration: titleDecorationOn!
                          ? BoxDecoration(
                              color: Color.fromARGB(255, 226, 226, 226),
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7),
                              ),
                            )
                          : BoxDecoration(),
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
                  infoDialogIconOn!
                      ? Container(
                          height: 30,
                          child: IconButton(
                            onPressed: () {
                              Dialogs.infoDialog(
                                context: context,
                                title: _frameName,
                                content: contentWidgetForDialog,
                              );
                            },
                            icon: Icon(Icons.search),
                            color: Colors.black87,
                          ),
                        )
                      : SizedBox(),
                  ...buttonsList!,
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 250, 250, 250),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                padding: contentPadding,
                child: _contentWidget,
              ),
            )
          ],
        ),
      ),
    );
  }
}
