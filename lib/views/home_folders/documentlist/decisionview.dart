import 'package:MWPX/data_structure/card/list/DecisionListItem.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

///Список документов из папки На решение
class DecisionView extends StatelessWidget {
  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('На решение', false, true);

    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameDecisionList);

    List<DecisionListItem> _documentList = [];

    for (int i = 0; i < 100; i++) {
      DecisionListItem decisionItem = new DecisionListItem();
      decisionItem.dokar = "VHD";
      decisionItem.doknr = i.toString();
      decisionItem.content = "Документ $i";
      decisionItem.regNUM = i.toString();
      decisionItem.regDATE = DateTime.now().add(new Duration(days: -1 * i));
      decisionItem.rcvdDT = DateTime.now().add(new Duration(days: -1 * i));
      decisionItem.mainAuthor = "Иванов$i Степан$i Петрович$i";

      _documentList.add(decisionItem);
    }

    DecisionDataSource _decisionListSource =
        new DecisionDataSource(_documentList);

    return Scaffold(
      appBar: appBar,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SfDataGrid(
                allowSorting: true,
                selectionMode: SelectionMode.single,
                source: _decisionListSource,
                gridLinesVisibility: GridLinesVisibility.none,
                columns: [
                  GridTextColumn(
                      columnName: 'doknr',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          color: MWPColors.mwpColorLight,
                          child: Text(
                            'DOKNR',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridTextColumn(
                      columnName: 'rcvdDT',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          color: MWPColors.mwpColorLight,
                          child: Text(
                            'Получено',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridTextColumn(
                      columnName: 'regNUM',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          color: MWPColors.mwpColorLight,
                          child: Text(
                            'Номер',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridTextColumn(
                      columnName: 'mainAuthor',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          color: MWPColors.mwpColorLight,
                          child: Text(
                            'Автор',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridTextColumn(
                      columnName: 'content',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          color: MWPColors.mwpColorLight,
                          child: Text(
                            'Содержание',
                            overflow: TextOverflow.ellipsis,
                          ))),
                ],
              ),
            ),
            buttonBar
          ]),
    );
  }
}

class DecisionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  DecisionDataSource(List<DecisionListItem> employees) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'doknr', value: dataGridRow.doknr),
              DataGridCell<String>(
                  columnName: 'rcvdDT', value: dataGridRow.rcvdDTText),
              DataGridCell<String>(
                  columnName: 'regNUM', value: dataGridRow.regNumText),
              DataGridCell<String>(
                  columnName: 'mainAuthor', value: dataGridRow.mainAuthor),
              DataGridCell<String>(
                  columnName: 'content', value: dataGridRow.content),
            ]))
        .toList();
  }

//          if (dataGridCell.value == 'Developer'

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: (dataGridCell.columnName == 'doknr' &&
                  int.parse(dataGridCell.value).remainder(2) == 0
              ? MWPColors.mwpTableRowBackroundDark
              : MWPColors.mwpTableRowBackroundLight),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}
