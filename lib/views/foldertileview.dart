import 'package:MWPX/views/documentlist/decisionview.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/controls/appbar.dart';
import 'package:MWPX/controls/buttonbar.dart';
import 'package:MWPX/views/masterdetail/btripview.dart';
import 'package:MWPX/views/masterdetail/vacationview.dart';
import 'package:MWPX/views/settingsview.dart';
import 'package:MWPX/constants.dart' as Constants;

/// Страница с плитками папок
class MWPFolderTileView extends StatelessWidget {
  Widget build(BuildContext context) {
    MWPMainAppBar app_bar = MWPMainAppBar();
    SettingsView settings = new SettingsView();
    MWPButtonBar button_bar = MWPButtonBar();

    app_bar.configureAppBar(
        'Рабочее Место Руководителя', settings, true, false);

    button_bar.configureButtonBar(Constants.viewNameFolders);

    return Scaffold(
      appBar: app_bar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: Container(
                  margin: EdgeInsets.all(30.0),
                  alignment: Alignment.center,
                  child: Wrap(
                    textDirection: TextDirection.ltr,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MWPFolderTile(1, 'Командировки', 7, Icons.date_range),
                      MWPFolderTile(2, 'Отпуска', 3, Icons.free_breakfast),
                      MWPFolderTile(3, 'На решение', 12, Icons.description),
                    ],
                  ))),
          button_bar,
        ],
      ),
    );
  }
}

// Плитка папки на главном экране
class MWPFolderTile extends StatelessWidget {
  String _folderName = "";
  IconData _folderIcon;
  int _folderCount = 0;
  int _folderCode = 0;

  MWPFolderTile(
      int FolderCode, String FolderName, int FolderCount, IconData FolderIcon) {
    _folderCode = FolderCode;
    _folderName = FolderName;
    _folderIcon = FolderIcon;
    _folderCount = FolderCount;
  }

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(14),
        width: 270,
        height: 190,
        child: OutlineButton(
            onPressed: () {
              if (this._folderCode == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BTripView()));
              }
              if (this._folderCode == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VacationView()));
              }
              if (this._folderCode == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DecisionView()));
              }
            },
            //color: Colors.lightGreen,
            borderSide: BorderSide.none,
            focusColor: Colors.lightGreen,
            padding: EdgeInsets.all(0),
            //shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(10)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.lightGreen, width: 5.0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(child: Container()),
                          Icon(
                            _folderIcon,
                            color: Colors.lightGreen,
                            size: 90,
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightGreen, //
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Colors.lightGreen),
                    child: Row(
                      children: <Widget>[
                        Text(
                          _folderName,
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        Expanded(
                            child: Container(
                                //color: Colors.lightGreen,
                                )),
                        Text(
                          '$_folderCount',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ])));
  }
}
