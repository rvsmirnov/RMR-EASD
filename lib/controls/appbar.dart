import 'package:flutter/material.dart';
import 'package:MWPX/mwpcolors.dart' as mwpColors;

class MWPMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  MWPMainAppBar({Key key})
      : preferredSize = Size.fromHeight(40.0),
        super(key: key);

  @override
  final Size preferredSize;

  String _titleText = "";
  Widget _settingsWidget;
  bool _settingsButton = false;
  bool _backButton = false;

  void configureAppBar(String TitleText, Widget SettingsWidget,
      bool SettingsButton, bool BackButton) {
    _titleText = TitleText;
    _settingsWidget = SettingsWidget;
    _settingsButton = SettingsButton;
    _backButton = BackButton;
  }

  Widget build(BuildContext context) {
    List<Widget> titleBarActions = new List<Widget>();

    if (_settingsButton && _settingsWidget != null) {
      titleBarActions.add(IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => _settingsWidget));
        },
      ));
    }

    if (_backButton) {
      titleBarActions.add(IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ));
    }

    return new AppBar(
      backgroundColor: mwpColors.mwpAccentColor,
      //leading: Icon(Icons.home),
      automaticallyImplyLeading: false,
      title: Text(
        _titleText,
        textDirection: TextDirection.ltr,
      ),
      actions: titleBarActions,
    );
  }
}
