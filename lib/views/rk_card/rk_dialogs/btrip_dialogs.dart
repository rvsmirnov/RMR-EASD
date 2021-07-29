import 'package:MWPX/services/icons_service.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:MWPX/widgets/text/richtext_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BTripDilogs {
  static void getBTripRKDialog({
    BuildContext? context,
    List<DataGridCell<dynamic>>? cellsList,
    String? str1,
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
                    'Командировка',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichTextWidget(
                            text: 'Вид командировки ',
                            boldText: 'На территории РФ',
                            context: context,
                          ),
                          RichTextWidget(
                            text: 'Город ',
                            boldText: 'Калининград',
                            context: context,
                          ),
                          RichTextWidget(
                            text: 'Период ',
                            boldText: 'с 28.06.2021 по 24.07.2021',
                            context: context,
                          ),
                          RichTextWidget(
                            text: 'Продолжительность ',
                            boldText: '27 дн.',
                            context: context,
                          ),
                          RichTextWidget(
                            text: 'Вид транспорта ',
                            boldText: 'ж.д.',
                            context: context,
                          ),
                          RichTextWidget(
                            text: 'Подписывает ',
                            boldText: 'Букатова Т.А.',
                            context: context,
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
      content: Text(
          '${cellsList[4].value.toString()} ${cellsList[1].value.toString()} ${cellsList[5].value.toString()} ${cellsList[6].value.toString()} ${cellsList[7].value.toString()}'),
    );
  }
}
