import 'package:flutter/material.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import '../widgets/app_bar/appbar.dart';
import 'package:MWPX/constants.dart' as Constants;

class SettingsView extends StatelessWidget {
  Set<String> comments = {'com1', 'com2', 'com3', 'com4', 'com'};

  Widget build(BuildContext context) {
    List<Widget> commentWidgets = [];
    for (var comment in comments) {
      commentWidgets
          // ignore: todo
          .add(Text(comment)); //TODO: Whatever layout you need for each widget.
    }

    var appBar = new MWPMainAppBar();
    var buttonBar = new MWPButtonBar();

    appBar.configureAppBar('Настройки', false, true);
    buttonBar.configureButtonBar(Constants.viewNameSettings);

    return Scaffold(
      appBar: appBar,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Экран настроек',
                    style: TextStyle(fontSize: 40),
                  )
                ],
              ),
            ),
            buttonBar
          ]),
    );
  }
}
