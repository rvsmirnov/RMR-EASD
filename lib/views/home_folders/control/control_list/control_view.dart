import 'package:MWPX/blocs/home_folders/control/control_list/control_list_bloc.dart';
import 'package:MWPX/data_structure/card/list/ControlListItem.dart';
import 'package:MWPX/services/data_grid_service.dart';
import 'package:MWPX/services/icons_service.dart';
import 'package:MWPX/services/shared_prefers_service.dart';
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

///Список документов из папки На исполнение
///

class ControlView extends StatelessWidget {
  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('На контроль (100)', false, true);
    SharedPrefsService sharedPrefsService =
        Provider.of<SharedPrefsService>(context);
    DataGridService dataGridService = Provider.of<DataGridService>(context);

    return Scaffold(
      appBar: appBar,
      body: BlocProvider(
        create: (BuildContext context) => ControlListBloc(
          sharedPrefsService: sharedPrefsService,
          dataGridService: dataGridService,
        )..add(OpenScreen()),
        child: ControlViewBody(),
      ),
    );
  }
}

class ControlViewBody extends StatefulWidget {
  @override
  _ControlViewBodyState createState() => _ControlViewBodyState();
}

class _ControlViewBodyState extends State<ControlViewBody> {
  @override
  Widget build(BuildContext context) {
    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameDecision);

    List<ControlListItem> _documentList = [];

    for (int i = 0; i < 100; i++) {
      ControlListItem controlItem = new ControlListItem();
      // 'cardUrgent'
      // 'dokar'
      // 'rcvdDT'
      // 'execLight'
      // 'ctrlDate'
      // 'regNUM'
      // 'controllerName'
      // 'content'
      // 'signerName'
      controlItem.cardUrgent = true;
      controlItem.dokar = "VHD";
      controlItem.rcvdDT = DateTime.now().add(new Duration(days: -1 * i));
      controlItem.ctrlDate = DateTime.now().add(new Duration(days: -2 * i));
      if (i < 10) {
        controlItem.ctrlDate = DateTime.now().add(new Duration(days: 2 * i));
      }
      controlItem.regNUM = i.toString();
      controlItem.content = "Документ $i";
      controlItem.regDATE = DateTime.now().add(new Duration(days: -1 * i));
      controlItem.doknr = i.toString();
      // controlItem.dokar = "01$i";
      controlItem.dokvr = "00$i";
      controlItem.doktl = "000$i";
      controlItem.wfItem = "02$i";
      controlItem.logsys = 'logsys';

      _documentList.add(controlItem);
    }

    ControlDataSource _controlListSource =
        new ControlDataSource(_documentList);

    return BlocConsumer<ControlListBloc, ControlListState>(
      listener: (context, state) {
        if (state is ControlListFailure) {
          Dialogs.errorDialog(
            context: context,
            content: Text('${state.error}'),
          );
        }
        if (state is ControlListSortInit) {
          state.sortDataList!.forEach((element) {
            _controlListSource.sortedColumns.add(element);
          });
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
                  source: _controlListSource,
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
                    GridColumn(
                      columnName: 'rcvdDT',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: GridHeaderItem(
                        headerName: 'Получено',
                      ),
                    ),
                    GridColumn(
                      columnName: 'execLight',
                      columnWidthMode: ColumnWidthMode.fill,
                      width: 100,
                      label: GridHeaderItem(
                        headerName: '',
                      ),
                    ),
                    GridColumn(
                      columnName: 'ctrlDate',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: GridHeaderItem(
                        headerName: 'Срок',
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
                    BlocProvider.of<ControlListBloc>(context).add(
                      SortDataSave(
                          sortDataList: _controlListSource.sortedColumns),
                    );
                    _controlListSource.sort();
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

class ControlDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  ControlDataSource(List<ControlListItem> employees) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'cardUrgent',
                  value: dataGridRow.cardUrgent.toString()),
              DataGridCell<String>(
                  columnName: 'dokar', value: dataGridRow.dokar),
              DataGridCell<String>(
                  columnName: 'rcvdDT', value: dataGridRow.rcvdDTText),
              DataGridCell<String>(
                  columnName: 'execLight', value: dataGridRow.execLight),
              DataGridCell<String>(
                  columnName: 'ctrlDate',
                  value:
                      '${dataGridRow.ctrlDateText} \n${dataGridRow.deltaText}'),
              DataGridCell<String>(
                  columnName: 'regNUM', value: dataGridRow.regNumText),
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

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = dataGridRows.indexOf(row);

    return DataGridRowAdapter(cells: <Widget>[
      ContainerCell(
        routeTypeCard: 'control',
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
        routeTypeCard: 'control',
        cellsList: row.getCells(),
        childWidget: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: DataGridService.getRowBackgroundColor(index),
          child: IconsService.getIconRK(row.getCells()[1].value),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'control',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[2].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'control',
        cellsList: row.getCells(),
        childWidget: DataGridService.getExecLight(
          value: row.getCells()[3].value.toString(),
          backgroundColor: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'control',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[4].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'control',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[5].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'control',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[6].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
    ]);
  }
}
