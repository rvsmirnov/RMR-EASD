import 'package:flutter/material.dart';
import 'package:MWPX/controls/buttonbar.dart';
import '../controls/appbar.dart';
import 'package:MWPX/constants.dart' as Constants;

class SettingsView extends StatelessWidget {
  Set<String> comments = {'com1', 'com2', 'com3', 'com4', 'com'};

  Widget build(BuildContext context) {
    List<Widget> commentWidgets = [];
    for (var comment in comments) {
      commentWidgets.add(
          Text(comment)); // TODO: Whatever layout you need for each widget.
    }

    var app_bar = new MWPMainAppBar();
    var button_bar = new MWPButtonBar();

    app_bar.configureAppBar('Настройки', false, true);
    button_bar.configureButtonBar(Constants.viewNameSettings);

    return Scaffold(
      appBar: app_bar,
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
            button_bar
          ]),
    );
  }
}
