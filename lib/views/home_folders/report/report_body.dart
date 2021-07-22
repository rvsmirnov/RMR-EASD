import 'package:MWPX/blocs/home_folders/report/report_bloc.dart';
// import 'package:MWPX/views/documentlist/decisionview.dart';
import 'package:MWPX/views/home_folders/btripview.dart';
import 'package:MWPX/views/home_folders/vacationview.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Страница с плитками папок
class ReportBody extends StatelessWidget {
  Widget build(BuildContext context) {
    MWPButtonBar button_bar = MWPButtonBar();

    button_bar.configureButtonBar(Constants.viewNameFolders);

    return BlocConsumer<ReportBloc, ReportState>(listener: (context, state) {
      if (state is ReportFailure) {
        Dialogs.errorDialog(
          context: context,
          content: Text('${state.error}'),
        );
      }
    }, builder: (context, state) {
      print('state in MWPFolderTileView $state');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (state is ReportLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (state is ReportDataReceived)
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(30.0),
                  alignment: Alignment.center,
                  child: Wrap(
                    textDirection: TextDirection.ltr,
                    children: <Widget>[
                      ...state.foldersReportDataList!.map(
                        (e) => MWPFolderTile(
                          folderCode: e['folderCode'],
                          folderName: e['folderName'],
                          folderCount: e['folderCount'],
                          svgCode: e['svgCode'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (state is ReportFailure)
            Expanded(
              child: SizedBox(),
            ),
          button_bar,
        ],
      );
    });
  }
}

// Плитка папки на главном экране
class MWPFolderTile extends StatelessWidget {
  final String? folderName;
  final String? svgCode;
  final int? folderCount;
  final int folderCode;

  MWPFolderTile({
    this.folderCode = 0,
    this.folderName = '',
    this.folderCount = 0,
    this.svgCode = '',
  });

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14),
      width: 270,
      height: 190,
      child: OutlineButton(
        onPressed: () {
          // if (this._folderCode == 1) {
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => BTripView()));
          // }
        },
        borderSide: BorderSide.none,
        focusColor: Colors.lightGreen,
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightGreen, width: 5.0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: SvgPicture.string(
                        svgCode!,
                        height: 135,
                        width: 135,
                        fit: BoxFit.fill,
                        color: Colors.lightGreen,
                      ),
                    ),
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
                  Container(
                    width: 200,
                    height: 25,
                    child: FittedBox(
                      child: Text(
                        folderName!,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    folderCount == null ? '' : '$folderCount',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
