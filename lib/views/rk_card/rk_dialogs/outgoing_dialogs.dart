import 'package:MWPX/services/icons_service.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OutgoingDilogs {
  static void getOutgoingRKDialog({
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
                    '${cellsList[3].value}',
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
                        'Исполнитель: ЦН',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(),
                    ),
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
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${cellsList[4].value.toString()} ${cellsList[1].value.toString()} doknr: ${cellsList[5].value.toString()} dokvr: ${cellsList[6].value.toString()} doktl: ${cellsList[7].value.toString()}'),
          SizedBox(
            height: 20,
          ),
          Text(
            'Адресаты',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: Colors.black,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Севастьянов П.Д. ООО ЯвьТ Директор',
            style: TextStyle(
                // fontSize: 20,
                ),
          ),
        ],
      ),
    );
  }

  static void getOutgoingAgreementDialog({
    BuildContext? context,
  }) {
    List<TableRow> tableRowList = <TableRow>[];

    DateFormat dateFormat = DateFormat("dd.MM.yyyy");
    for (int i = 1; i < 100; i++) {
      tableRowList.add(TableRow(
        decoration: i == 1
            ? const BoxDecoration(color: MWPColors.mwpTableRowGreenBackground)
            : const BoxDecoration(color: Colors.white),
        children: <Widget>[
          Container(
            child: Text(
              'Кузьмина Ольга Юрьевна $i ЦН',
              style: TextStyle(),
              // overflow: TextOverflow.visible,
              // maxLines: 2,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  child: i % 2 != 0
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 30,
                        )
                      : Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        ),
                ),
                Container(
                  child: Text(
                    dateFormat
                        .format(DateTime.now().add(new Duration(days: 1 * i)))
                        .toString(),
                    style: TextStyle(),
                    // overflow: TextOverflow.visible,
                    // maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              'Текст замечания $i',
              style: TextStyle(),
              // overflow: TextOverflow.visible,
              // maxLines: 2,
            ),
          ),
        ],
      ));
    }

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
                  Text(
                    'Лист согласования',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context!).size.width * 0.8,
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.symmetric(
              inside: BorderSide(width: 1),
              outside: BorderSide(width: 1),
            ),
            columnWidths: const <int, TableColumnWidth>{
              // 0: IntrinsicColumnWidth(),
              // 1: FlexColumnWidth(),
              // 2: FixedColumnWidth(64),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(75, 75, 75, 1),
                ),
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text(
                      'Согласующий',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    child: Text(
                      'Согласование',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    child: Text(
                      'Текст замечания',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              ...tableRowList
            ],
          ),
        ),
      ),
    );
  }
}
