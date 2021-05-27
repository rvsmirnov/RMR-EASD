import 'package:flutter/material.dart';
import 'package:MWPX/controls/button/circlebutton.dart';
import 'package:MWPX/controls/button/squarebutton.dart';
import 'package:MWPX/constants.dart' as Constants;

class MWPButtonBar extends StatelessWidget {
  List<Widget> button_list = new List<Widget>();

  void configureButtonBar(String viewName) {
    if (viewName == Constants.viewNameFolders) {
      button_list.add(MWPCircleButton(Icons.sync));
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

    if (viewName == Constants.viewNameDecisionList) {
      button_list.add(MWPCircleButton(Icons.sync));
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
