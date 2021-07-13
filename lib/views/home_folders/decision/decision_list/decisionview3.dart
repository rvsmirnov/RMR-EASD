import 'package:MWPX/data_structure/card/list/DecisionListItem.dart';
import 'package:MWPX/views/home_folders/graphic_notes/graphic_notes_screen5.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

///Список документов из папки На решение
///

class DecisionView3 extends StatelessWidget {
  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('На решение', false, true);

    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameDecisionList);

    List<DecisionListItem> _documentList = [];

    for (int i = 0; i < 100; i++) {
      DecisionListItem decisionItem = new DecisionListItem();
      decisionItem.cardUrgent = true;
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
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                    // rowHoverColor: Colors.green[900],
                    // rowHoverTextStyle: TextStyle(
                    //   color: Colors.red,
                    //   fontSize: 14,
                    // ),
                    selectionColor: MWPColors.mwpAccentColor,
                    sortIconColor: MWPColors.mwpAccentColor,
                    headerColor: MWPColors.mwpColorDark,
                    gridLineColor: MWPColors.mwpColorDark),
                child: SfDataGrid(
                  // headerGridLinesVisibility: GridLinesVisibility.vertical,

                  allowSorting: true,
                  selectionMode: SelectionMode.single,
                  source: _decisionListSource,
                  gridLinesVisibility: GridLinesVisibility.horizontal,
                  columns: [
                    GridColumn(
                      columnName: 'cardUrgent',
                      columnWidthMode: ColumnWidthMode.fill,
                      width: 50,
                      label: GridHeaderItem(
                        headerName: '',
                        leftHeaderBorder: false,
                      ),
                    ),
                    GridColumn(
                      columnName: 'dokar',
                      columnWidthMode: ColumnWidthMode.fill,
                      width: 50,
                      label: GridHeaderItem(
                        headerName: '',
                      ),
                    ),
                    // GridColumn(
                    //   columnName: 'doknr',
                    //   columnWidthMode: ColumnWidthMode.fill,
                    //   width: 100,
                    //   label: GridHeaderItem(
                    //     headerName: 'DOKNR',
                    //   ),
                    // ),
                    GridColumn(
                      columnName: 'rcvdDT',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: GridHeaderItem(
                        headerName: 'Получено',
                      ),
                    ),
                    GridColumn(
                      columnName: 'regNUM',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: GridHeaderItem(
                        headerName: 'Номер',
                      ),
                    ),
                    GridColumn(
                      columnName: 'mainAuthor',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: GridHeaderItem(
                        headerName: 'Автор',
                      ),
                    ),
                    GridColumn(
                      columnName: 'content',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: GridHeaderItem(
                        headerName: 'Содержание',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
            //   child: FlatButton(
            //       onPressed: () {
            //         _decisionListSource.sortedColumns.add(SortColumnDetails(
            //             name: 'rcvdDT',
            //             sortDirection: DataGridSortDirection.ascending));
            //         _decisionListSource.sort();
            //       },
            //       child: Text('Apply sort')),
            // ),
            buttonBar
          ]),
    );
  }
}

class GridHeaderItem extends StatelessWidget {
  final String? headerName;
  final bool leftHeaderBorder;
  const GridHeaderItem({this.headerName, this.leftHeaderBorder = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          // left: leftHeaderBorder
          //     ? BorderSide(
          //         color: MWPColors.mwpTableRowBackroundLight,
          //         width: 1.0,
          //       )
          //     : BorderSide(),
          left: leftHeaderBorder
              ? BorderSide(
                  color: MWPColors.mwpTableRowBackroundLight,
                  width: 1.0,
                )
              : BorderSide(),
          // right: leftHeaderBorder
          //     ? BorderSide(
          //         color: MWPColors.mwpTableRowBackroundLight,
          //         width: 1.0,
          //       )
          //     : BorderSide(),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        headerName!,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class DecisionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  // performSorting

  DecisionDataSource(List<DecisionListItem> employees) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'cardUrgent',
                  value: dataGridRow.cardUrgent.toString()),
              DataGridCell<String>(
                  columnName: 'dokar', value: dataGridRow.dokar),
              // DataGridCell<String>(
              //     columnName: 'doknr', value: dataGridRow.doknr),
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
    print('start buildRow');
    // print('row[0] ${dataGridRows.}');
    print('dataGridRows.first ${dataGridRows.first.getCells().first.value}');
    // print('dataGridRows.first ${dataGridRows.}');

    // int itemNumber;

    Widget getContainerCell({String? textValue, Color? color}) {
      return Builder(builder: (BuildContext context) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage5(
                  title: 'Пример графических работ 2',
                ),
              ),
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            color: color,
            child: Text(
              textValue!,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      });
    }

    Color getRowBackgroundColor() {
      final int index = dataGridRows.indexOf(row);
      if (index % 2 != 0) {
        return MWPColors.mwpTableRowBackroundLight;
      }

      return MWPColors.mwpTableRowBackroundDark;
    }

    return DataGridRowAdapter(cells: <Widget>[
      // Container(
      //   padding: const EdgeInsets.all(8.0),
      //   child: row.getCells()[0].value,
      // ),
      Builder(builder: (BuildContext context) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage5(
                  title: 'Пример графических работ 2',
                ),
              ),
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            color: getRowBackgroundColor(),
            child: Text(
              row.getCells()[0].value == 'true' ? '!' : '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 28,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
      // dokar
      Builder(builder: (BuildContext context) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage5(
                  title: 'Пример графических работ 2',
                ),
              ),
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            color: getRowBackgroundColor(),
            child: row.getCells()[1].value == 'VHD'
                ? Image.asset(
                    'assets/images/1.jpeg',
                    width: 30,
                    height: 30,
                  )
                : Image.asset(
                    'assets/images/1.png',
                    width: 30,
                    height: 30,
                  ),
          ),
        );
      }),
      // getContainerCell(
      //   textValue: row.getCells()[2].value.toString(),
      //   color: getRowBackgroundColor(),
      // ),
      getContainerCell(
        textValue: row.getCells()[2].value.toString(),
        color: getRowBackgroundColor(),
      ),
      getContainerCell(
        textValue: row.getCells()[3].value.toString(),
        color: getRowBackgroundColor(),
      ),
      getContainerCell(
        textValue: row.getCells()[4].value.toString(),
        color: getRowBackgroundColor(),
      ),
      getContainerCell(
        textValue: row.getCells()[5].value.toString(),
        color: getRowBackgroundColor(),
      ),
    ]);

    //   row.getCells().map<Widget>((dataGridCell) {
    // // itemNumber++;
    //   return Container(
    //       alignment: Alignment.centerLeft,
    //       padding: EdgeInsets.symmetric(horizontal: 16.0),
    //       color: getRowBackgroundColor(),

    //       // (dataGridCell.columnName == 'doknr' &&
    //       //         int.parse(dataGridCell.value).remainder(2) == 0
    //       //     // int.parse(dataGridCell.value).remainder(2) == 0
    //       //     ? MWPColors.mwpTableRowBackroundDark
    //       //     : MWPColors.mwpTableRowBackroundLight),
    //       // itemNumber.remainder(2) == 0
    //       //     ? MWPColors.mwpTableRowBackroundDark
    //       //     : MWPColors.mwpTableRowBackroundLight,
    //       child: Text(
    //         dataGridCell.value.toString(),
    //         overflow: TextOverflow.ellipsis,
    //       ));
    // }).toList());
  }
}
