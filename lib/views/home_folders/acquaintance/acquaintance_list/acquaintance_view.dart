import 'package:MWPX/blocs/home_folders/acquaintance/acquaintance_list/acquaintance_list_bloc.dart';
import 'package:MWPX/data_structure/card/list/acquaintanceListItem.dart';
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

///Список документов из папки На Ознакомление
///

class AcquaintanceView extends StatelessWidget {
  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('На ознакомление', false, true);
    SharedPrefsService sharedPrefsService =
        Provider.of<SharedPrefsService>(context);
    DataGridService dataGridService = Provider.of<DataGridService>(context);

    return Scaffold(
      appBar: appBar,
      body: BlocProvider(
        create: (BuildContext context) => AcquaintanceListBloc(
          sharedPrefsService: sharedPrefsService,
          dataGridService: dataGridService,
        )..add(OpenScreen()),
        child: AcquaintanceViewBody(),
      ),
    );
  }
}

class AcquaintanceViewBody extends StatefulWidget {
  @override
  _AcquaintanceViewBodyState createState() => _AcquaintanceViewBodyState();
}

class _AcquaintanceViewBodyState extends State<AcquaintanceViewBody> {
  @override
  Widget build(BuildContext context) {
    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameDecision);

    List<AcquaintanceListItem> _documentList = [];

    for (int i = 0; i < 100; i++) {
      AcquaintanceListItem acquaintanceItem = new AcquaintanceListItem();
      acquaintanceItem.cardUrgent = true;
      acquaintanceItem.dokar = "VHD";
      acquaintanceItem.rcvdDT = DateTime.now().add(new Duration(days: -1 * i));
      // acquaintanceItem.ctrlDate = DateTime.now().add(new Duration(days: -2 * i));
      // if (i < 10) {
      //   acquaintanceItem.ctrlDate = DateTime.now().add(new Duration(days: 2 * i));
      // }
      acquaintanceItem.regNUM = i.toString();
      acquaintanceItem.content = "Документ $i";
      acquaintanceItem.regDATE = DateTime.now().add(new Duration(days: -1 * i));
      acquaintanceItem.doknr = i.toString();
      acquaintanceItem.documentTypeText = 'Приказ';
      // acquaintanceItem.dokar = "01$i";
      acquaintanceItem.dokvr = "00$i";
      acquaintanceItem.doktl = "000$i";
      acquaintanceItem.wfItem = "02$i";
      acquaintanceItem.logsys = 'logsys';

      _documentList.add(acquaintanceItem);
    }

    AcquaintanceDataSource _acquaintanceListSource =
        new AcquaintanceDataSource(_documentList);

    return BlocConsumer<AcquaintanceListBloc, AcquaintanceListState>(
      listener: (context, state) {
        if (state is AcquaintanceListFailure) {
          Dialogs.errorDialog(
            context: context,
            content: Text('${state.error}'),
          );
        }
        if (state is AcquaintanceListSortInit) {
          state.sortDataList!.forEach((element) {
            _acquaintanceListSource.sortedColumns.add(element);
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
                  source: _acquaintanceListSource,
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
                      columnName: 'regNUM',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: GridHeaderItem(
                        headerName: 'Номер',
                      ),
                    ),
                    GridColumn(
                      columnName: 'documentTypeText',
                      columnWidthMode: ColumnWidthMode.fill,
                      label: GridHeaderItem(
                        headerName: 'Вид документа',
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
                    BlocProvider.of<AcquaintanceListBloc>(context).add(
                      SortDataSave(
                          sortDataList: _acquaintanceListSource.sortedColumns),
                    );
                    _acquaintanceListSource.sort();
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

class AcquaintanceDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  AcquaintanceDataSource(List<AcquaintanceListItem> employees) {
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
                  columnName: 'regNUM', value: dataGridRow.regNumText),
              DataGridCell<String>(
                  columnName: 'documentTypeText',
                  value: dataGridRow.documentTypeText),
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
        routeTypeCard: 'acquaintance',
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
        routeTypeCard: 'acquaintance',
        cellsList: row.getCells(),
        childWidget: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: DataGridService.getRowBackgroundColor(index),
          child: IconsService.getIconRK(row.getCells()[1].value),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'acquaintance',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[2].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'acquaintance',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[3].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'acquaintance',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[4].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'acquaintance',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[5].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
    ]);
  }
}
