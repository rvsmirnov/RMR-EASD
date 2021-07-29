import 'package:MWPX/widgets/button/circlebutton.dart';
import 'package:MWPX/widgets/button/squarebutton.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/constants.dart' as Constants;

class MWPButtonBar extends StatelessWidget {
  List<Widget> button_list = [];

  void configureButtonBar(String viewName) {
    if (viewName == Constants.viewNameFolders) {
      button_list.add(MWPCircleButton(
        buttonChild: Icon(Icons.sync, color: Colors.white),
      ));
    }

    if (viewName == Constants.viewNameBTrips) {
      button_list.add(MWPSquareButton('Разрешить'));
      button_list.add(MWPSquareButton('Отклонить'));
      button_list.add(MWPSquareButton('Вернуть с\nзамечаниями'));
    }

    if (viewName == Constants.viewNameVacations) {
      button_list.add(MWPSquareButton('Разрешить'));
      button_list.add(MWPSquareButton('Отклонить'));
      button_list.add(MWPSquareButton('Вернуть с\nзамечаниями'));
    }

    if (viewName == Constants.viewNameDecision) {
      button_list.add(MWPCircleButton(
        buttonChild: Icon(Icons.sync, color: Colors.white),
      ));
    }

    if (viewName == Constants.viewNameInputScreen) {
      button_list.add(MWPSquareButton('Разрешить'));
      button_list.add(MWPSquareButton('Отклонить'));
      button_list.add(MWPSquareButton('Вернуть с\nзамечаниями'));
    }
  }

  //MWPSquareButton('Вернуть\nпомощнику'),
  //MWPSquareButton('Согласовать\nс замечаниями'),
  //MWPSquareButton('Согласовать\n без замечаний'),
  //MWPCircleButton()

  Widget build(BuildContext context) {
    return Align(
      child: Container(
          alignment: Alignment.center,
          height: 75,
          width: double.infinity,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: button_list,
          )

//
//            child: OutlineButton(
//              child: Icon(Icons.sync,color: Colors.white),
//                  onPressed: (){},
//                  shape: CircleBorder(side: BorderSide(color: Colors.white,width: 3)//new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
//              ),
//              ),
          ),
    );
  }
}
