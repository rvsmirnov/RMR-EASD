import 'package:MWPX/blocs/home_folders/decision/decision_list/decision_list_bloc.dart';
import 'package:MWPX/data_structure/card/list/DecisionListItem.dart';
import 'package:MWPX/services/data_grid_service.dart';
import 'package:MWPX/services/icons_service.dart';
import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/services/shared_prefers_service.dart';
import 'package:MWPX/views/home_folders/decision/decision_card/decision_card.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:MWPX/widgets/data_grid_widgets/container_cell.dart';
import 'package:MWPX/widgets/data_grid_widgets/container_text_cell.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

///Список документов из папки На решение
///

class DecisionView extends StatelessWidget {
  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('На решение', false, true);
    SharedPrefsService sharedPrefsService =
        Provider.of<SharedPrefsService>(context);
    DataGridService dataGridService = Provider.of<DataGridService>(context);

    return Scaffold(
      appBar: appBar,
      body: BlocProvider(
        create: (BuildContext context) => DecisionListBloc(
          sharedPrefsService: sharedPrefsService,
          dataGridService: dataGridService,
        )..add(OpenScreen()),
        child: DecisionViewBody(),
      ),
    );
  }
}

class DecisionViewBody extends StatefulWidget {
  @override
  _DecisionViewBodyState createState() => _DecisionViewBodyState();
}

class _DecisionViewBodyState extends State<DecisionViewBody> {
  @override
  Widget build(BuildContext context) {
    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameDecision);

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
      // decisionItem.doknr = i.toString();
      // decisionItem.dokar = "01$i";
      decisionItem.dokvr = "00$i";
      decisionItem.doktl = "000$i";
      decisionItem.wfItem = "02$i";
      decisionItem.logsys = 'logsys';

      _documentList.add(decisionItem);
    }

    DecisionDataSource _decisionListSource =
        new DecisionDataSource(_documentList);

    // _decisionListSource.sortedColumns.add(SortColumnDetails(
    //     name: 'rcvdDT', sortDirection: DataGridSortDirection.ascending));
    // _decisionListSource.sortedColumns.add(SortColumnDetails(
    //     name: 'dokar', sortDirection: DataGridSortDirection.ascending));

    print(
        '0 _decisionListSource.sortedColumns ${_decisionListSource.sortedColumns}');
    // print(
    //     '_decisionListSource.sortedColumns[0].name ${_decisionListSource.sortedColumns[0].name}');
    // print(
    //     '_decisionListSource.sortedColumns[0].name ${_decisionListSource.sortedColumns[0].sortDirection}');

    return BlocConsumer<DecisionListBloc, DecisionListState>(
      listener: (context, state) {
        if (state is DecisionListFailure) {
          Dialogs.errorDialog(
            context: context,
            content: Text('${state.error}'),
          );
        }
        if (state is DecisionListSortInit) {
          state.sortDataList!.forEach((element) {
            _decisionListSource.sortedColumns.add(element);
          });
          // _decisionListSource.sortedColumns.add(SortColumnDetails(
          //     name: 'rcvdDT', sortDirection: DataGridSortDirection.ascending));
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                    selectionColor: MWPColors.mwpAccentColor,
                    sortIconColor: MWPColors.mwpAccentColor,
                    headerColor: MWPColors.mwpColorDark,
                    gridLineColor: MWPColors.mwpColorDark),
                child: SfDataGrid(
                  allowTriStateSorting: true,
                  allowSorting: true,
                  allowMultiColumnSorting: true,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: FlatButton(
                  onPressed: () {
                    BlocProvider.of<DecisionListBloc>(context).add(
                      SortDataSave(
                          sortDataList: _decisionListSource.sortedColumns),
                    );
                    // _decisionListSource.sortedColumns.add(SortColumnDetails(
                    //     name: 'rcvdDT',
                    //     sortDirection: DataGridSortDirection.ascending));
                    // // _decisionListSource.sort();
                    // _decisionListSource.sortedColumns.add(SortColumnDetails(
                    //     name: 'dokar',
                    //     sortDirection: DataGridSortDirection.ascending));
                    print(
                        '1 _decisionListSource.sortedColumns ${_decisionListSource.sortedColumns}');
                    // print(
                    //     '_decisionListSource.sortedColumns[0].name ${_decisionListSource.sortedColumns[0].name}');
                    // print(
                    //     '_decisionListSource.sortedColumns[0].sortDirection ${_decisionListSource.sortedColumns[0].sortDirection}');
                    _decisionListSource.sort();
                    // setState(() {});
                  },
                  child: Text('Сохранить настройки сортировки')),
            ),
            buttonBar
          ],
        );
      },
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
          left: leftHeaderBorder
              ? BorderSide(
                  color: MWPColors.mwpTableRowBackroundLight,
                  width: 1.0,
                )
              : BorderSide(),
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
              // Передаем данные, но не отображаем
              DataGridCell<String>(
                  columnName: 'doknr', value: dataGridRow.doknr),
              DataGridCell<String>(
                  columnName: 'dokvr', value: dataGridRow.dokvr),
              DataGridCell<String>(
                  columnName: 'doktl', value: dataGridRow.doktl),
              DataGridCell<String>(
                  columnName: 'wfItem', value: dataGridRow.wfItem),
              DataGridCell<String>(
                  columnName: 'logsys', value: dataGridRow.logsys),
            ]))
        .toList();
  }

//          if (dataGridCell.value == 'Developer'

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = dataGridRows.indexOf(row);

    return DataGridRowAdapter(cells: <Widget>[
      ContainerCell(
        routeTypeCard: 'decision',
        cellsList: row.getCells(),
        childWidget: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: DataGridService.getRowBackgroundColor(index),
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
      ),
      ContainerCell(
        routeTypeCard: 'decision',
        cellsList: row.getCells(),
        childWidget: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            color: DataGridService.getRowBackgroundColor(index),
            child: IconsService.getIconRK(row.getCells()[1].value)),
      ),
      ContainerCell(
        routeTypeCard: 'decision',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[2].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'decision',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[3].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'decision',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[4].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'decision',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[5].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
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
