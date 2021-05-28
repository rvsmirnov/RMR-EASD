import 'package:MWPX/controls/appbar.dart';
import 'package:MWPX/controls/buttonbar.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

///Список документов из папки На решение
class DecisionView extends StatelessWidget {
  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('На решение', null, false, true);

    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameDecisionList);

    return Scaffold(
      appBar: appBar,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(child: Text("Документы на решении, список")),
            ),
            buttonBar
          ]),
    );
  }
}
