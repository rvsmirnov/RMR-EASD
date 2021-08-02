import 'package:MWPX/blocs/home/home_bloc.dart';
import 'package:MWPX/views/home_folders/acquaintance/acquaintance_list/acquaintance_view.dart';
import 'package:MWPX/views/home_folders/agreement/agreement_list/agreement_view.dart';
// import 'package:MWPX/views/documentlist/decisionview.dart';
import 'package:MWPX/views/home_folders/btripview.dart';
import 'package:MWPX/views/home_folders/control/control_list/control_view.dart';
import 'package:MWPX/views/home_folders/decision/decision_list/decision_view.dart';
import 'package:MWPX/views/home_folders/execution/execution_list/execution_view.dart';
import 'package:MWPX/views/home_folders/for_meeting/for_meeting_list/for_meeting_list.dart';
import 'package:MWPX/views/home_folders/graphic_notes/draw_screen.dart';
import 'package:MWPX/views/home_folders/graphic_notes/draw_screen2.dart';
import 'package:MWPX/views/home_folders/graphic_notes/graphic_notes_screen3.dart';
import 'package:MWPX/views/home_folders/graphic_notes/graphic_notes_screen4.dart';
import 'package:MWPX/views/home_folders/graphic_notes/graphic_notes_screen5.dart';
import 'package:MWPX/views/home_folders/graphic_notes/graphic_notes_screen5_0.dart';
import 'package:MWPX/views/home_folders/graphic_notes/graphic_notes_screen6.dart';
import 'package:MWPX/views/home_folders/graphic_notes/graphic_notes_screen7.dart';
import 'package:MWPX/views/home_folders/graphic_notes/graphic_notes_screen8.dart';
import 'package:MWPX/views/home_folders/graphic_notes/graphic_notes_screen9.dart';
import 'package:MWPX/views/home_folders/report/report_screen.dart';
import 'package:MWPX/views/home_folders/sign/sign_list/sign_view.dart';
import 'package:MWPX/views/home_folders/vacationview.dart';
import 'package:MWPX/views/open_file_example/open_file.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
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
    return Container(
      margin: EdgeInsets.all(14),
      width: 270,
      height: 190,
      child: OutlineButton(
        onPressed: () {
          if (this._folderCode == 00001) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BTripView()));
          }
          if (this._folderCode == 00002) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VacationView()));
          }
          if (this._folderCode == 00003) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DecisionView()));
          }
          if (this._folderCode == 00004) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReportScreen()));
          }
          if (this._folderCode == 00005) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AgreementView()));
          }
          if (this._folderCode == 00006) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignView()));
          }
          if (this._folderCode == 00007) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExecutionView()));
          }
          // if (this._folderCode == 00007) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => MyHomePage5(
          //         title: 'Пример графических работ 2',
          //       ),
          //     ),
          //   );
          // }
          if (this._folderCode == 00008) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ControlView(),
              ),
            );
          }
          //
          if (this._folderCode == 00009) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OpenFileWidget(
                ),
              ),
            );
          }
          if (this._folderCode == 00010) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AcquaintanceView(),
              ),
            );
          }
          if (this._folderCode == 00011) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForMeetingView(),
              ),
            );
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
