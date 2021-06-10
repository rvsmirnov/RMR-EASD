import 'package:MWPX/blocs/home/home_bloc.dart';
import 'package:MWPX/views/documentlist/decisionview.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/views/masterdetail/btripview.dart';
import 'package:MWPX/views/masterdetail/vacationview.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Страница с плитками папок
class MWPFolderTileView extends StatelessWidget {
  Widget build(BuildContext context) {
    MWPButtonBar button_bar = MWPButtonBar();

    button_bar.configureButtonBar(Constants.viewNameFolders);

    return BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
      if (state is HomeFailure) {
        Dialogs.infoDialog(
          context: context,
          content: Text('${state.error}'),
        );
      }
    }, builder: (context, state) {
      print('state in MWPFolderTileView $state');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (state is HomeLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (state is HomeDataReceived)
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(30.0),
                  alignment: Alignment.center,
                  child: Wrap(
                    textDirection: TextDirection.ltr,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ...state.foldersHomeDataList!.map(
                        (e) => MWPFolderTile(
                          e['folderCode'],
                          e['folderName'],
                          e['folderCount'],
                          e['svgCode'],
                        ),
                      ),
                      // MWPFolderTile(1, 'Командировки', 7, Icons.date_range),
                      // MWPFolderTile(2, 'Отпуска', 3, Icons.free_breakfast),
                      // MWPFolderTile(3, 'На решение', 12, Icons.description),
                    ],
                  ),
                ),
              ),
            ),
          if (state is HomeFailure)
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
  String _folderName = "";
  String? _svgCode;
  int? _folderCount = 0;
  int _folderCode = 0;

  MWPFolderTile(
      int folderCode, String folderName, int? folderCount, String svgCode) {
    _folderCode = folderCode;
    _folderName = folderName;
    _svgCode = svgCode;
    _folderCount = folderCount;
  }

  Widget build(BuildContext context) {
    print('--- $_svgCode');
    return Container(
      margin: EdgeInsets.all(14),
      width: 270,
      height: 190,
      child: OutlineButton(
        onPressed: () {
          if (this._folderCode == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BTripView()));
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
                        _svgCode!,
                        height: 135,
                        width: 135,
                        fit: BoxFit.fill,
                        color: Colors.lightGreen,
                      ),
                    ),
                    // Expanded(child: Container()),
                    // Center(
                    //   child: SvgPicture.string(
                    //     '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path
                    //     d="
                    //     "
                    //      /></svg>''',
                    //     height: 135,
                    //     width: 135,
                    //     fit: BoxFit.fill,
                    //     color: Colors.lightGreen,
                    //   ),
                    // ),
                    // Center(
                    //   child: SvgPicture.string(
                    //     '''<svg style="width:24px;height:24px" viewBox="0 0 24 24"> <path d="$_svgCode" /></svg>''',
                    //     height: 135,
                    //     width: 135,
                    //     fit: BoxFit.fill,
                    //     color: Colors.lightGreen,
                    //   ),
                    // ),
                    // Icon(
                    //   _svgCode,
                    //   color: Colors.lightGreen,
                    //   size: 90,
                    // ),
                    // Expanded(child: Container()),
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
                        _folderName,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                      child: Container(
                          //color: Colors.lightGreen,
                          )),
                  Text(
                    _folderCount == null ? '' : '$_folderCount',
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
