import 'package:MWPX/services/icons_service.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InstructionDilogs {
  static void getInstructionRKDialog({
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
                    // '${cellsList[3].value}',
                    'Поручение к № ВХ-60/ЦН от 25.04.2019',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border(
          //       top: BorderSide(
          //         width: 1,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          //   child: Container(
          //     height: 60,
          //     child: Padding(
          //       padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Flexible(
          //             flex: 3,
          //             child: Align(
          //               alignment: Alignment.topLeft,
          //               child: Text(
          //                 'Срок исполнения: 20.02.2021',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 14,
          //                 ),
          //                 overflow: TextOverflow.visible,
          //               ),
          //             ),
          //           ),
          //           Flexible(
          //             flex: 1,
          //             child: SizedBox(),
          //           ),
          //           Flexible(
          //             flex: 3,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   'Контроллер: Денисов Петор Алексеевич',
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.normal,
          //                     fontSize: 14,
          //                   ),
          //                   overflow: TextOverflow.visible,
          //                   maxLines: 1,
          //                 ),
          //                 Text(
          //                   'Подписал: Петров Федор Андреевич',
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.normal,
          //                     fontSize: 14,
          //                   ),
          //                   overflow: TextOverflow.visible,
          //                   maxLines: 1,
          //                 ),
          //                 Text(
          //                   'Получено: 08.12.2020',
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.normal,
          //                     fontSize: 14,
          //                   ),
          //                   overflow: TextOverflow.visible,
          //                   maxLines: 1,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Colors.black,
                ),
              ),
            ),
            width: MediaQuery.of(context!).size.width * 0.8,
            child: SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Срок исполнения: 20.02.2021',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Контроллер: Денисов Петор Алексеевич',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.visible,
                            // maxLines: 1,
                          ),
                          Text(
                            'Подписал: Петров Федор Андреевич',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.visible,
                            // maxLines: 1,
                          ),
                          Text(
                            'Получено: 08.12.2020',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.visible,
                            // maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${cellsList[4].value.toString()} ${cellsList[1].value.toString()} ${cellsList[5].value.toString()} ${cellsList[6].value.toString()} ${cellsList[7].value.toString()}'),
          SizedBox(
            height: 20,
          ),
          Text(
            'Исполнители',
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
          // Container(
          //   height: 60,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Flexible(
          //         flex: 1,
          //         child: Icon(
          //           Icons.check,
          //           color: Colors.green,
          //           size: 20,
          //         ),
          //       ),
          //       Flexible(
          //         flex: 3,
          //         child: Text(
          //           'Норманская Ольга Вячеславовна',
          //           style: TextStyle(),
          //           // overflow: TextOverflow.visible,
          //           // maxLines: 2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // Column(
          //   children: [
          //     Container(
          //       height: 60,
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Flexible(
          //             flex: 1,
          //             child: Icon(
          //               Icons.check,
          //               color: Colors.green,
          //               size: 20,
          //             ),
          //           ),
          //           Flexible(
          //             flex: 3,
          //             child: Text(
          //               'Норманская Ольга Вячеславовна',
          //               style: TextStyle(),
          //               // overflow: TextOverflow.visible,
          //               // maxLines: 2,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Container(
          //       height: 60,
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Flexible(
          //             flex: 1,
          //             child: Icon(
          //               Icons.check,
          //               color: Colors.green,
          //               size: 20,
          //             ),
          //           ),
          //           Flexible(
          //             flex: 3,
          //             child: Text(
          //               'Норманская Ольга Вячеславовна',
          //               style: TextStyle(),
          //               // overflow: TextOverflow.visible,
          //               // maxLines: 2,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Text(
                              'Норманская Ольга Вячеславовна',
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          'ЦН',
                          overflow: TextOverflow.visible,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 20,
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Text(
                              'Федоров Олег Николаевич',
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          'ЦН',
                          overflow: TextOverflow.visible,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void getInstructionAgreementDialog({
    BuildContext? context,
  }) {
    List<TableRow> tableRowList = <TableRow>[];

    DateFormat dateFormat = DateFormat("dd.MM.yyyy");
    for (int i = 1; i < 2; i++) {
      tableRowList.add(TableRow(
        // decoration: i == 1
        //     ? const BoxDecoration(color: MWPColors.mwpTableRowGreenBackground)
        //     : const BoxDecoration(color: Colors.white),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              dateFormat
                  .format(DateTime.now().add(new Duration(days: 1 * i)))
                  .toString(),
              style: TextStyle(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              'Кузьмина Ольга Юрьевна',
              style: TextStyle(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              'ЦН',
              style: TextStyle(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              'Текст отчета $i',
              style: TextStyle(),
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
                    'Ход исполнения',
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
              inside: BorderSide(
                width: 1,
                color: Colors.white,
              ),
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
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                    height: 60,
                    child: Text(
                      'Дата',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      'Исполнитель',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      'Подразделение',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      'Отчет',
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
