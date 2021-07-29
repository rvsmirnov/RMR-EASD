import 'package:MWPX/services/icons_service.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class IncomingDilogs {
  static void getIncomingRKDialog({
    BuildContext? context,
    List<DataGridCell<dynamic>>? cellsList,
  }) {
    Dialogs.infoDialogRK(
      context: context,
      titleWidget: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconsService.getIconRK(cellsList![1].value),
                  Text(
                    'Тип документа ${cellsList[3].value}',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Colors.black,
                ),
              ),
            ),
            child: Container(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Text(
                        'Автор: ${cellsList[4].value}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Flexible(flex: 1, child: SizedBox(),),
                    Flexible(
                      flex: 3,
                      child: Text(
                        'Получено: ${cellsList[2].value}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      content: Text(
          '${cellsList[5].value.toString()} doknr: ${cellsList[6].value.toString()} dokvr: ${cellsList[7].value.toString()} doktl: ${cellsList[8].value.toString()} wfItem: ${cellsList[9].value.toString()}'),
    );
  }
}
