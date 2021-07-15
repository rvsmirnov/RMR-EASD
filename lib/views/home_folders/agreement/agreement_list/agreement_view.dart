import 'package:MWPX/blocs/home_folders/agreement/decision_list/agreement_list_bloc.dart';
// import 'package:MWPX/blocs/home_folders/decision/decision_list/decision_list_bloc.dart';
import 'package:MWPX/data_structure/card/list/ApproveListItem.dart';
import 'package:MWPX/services/data_grid_service.dart';
import 'package:MWPX/services/icons_service.dart';
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

///Список документов из папки На согласование
///

class AgreementView extends StatelessWidget {
  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('На согласование', false, true);
    SharedPrefsService sharedPrefsService =
        Provider.of<SharedPrefsService>(context);
    DataGridService dataGridService = Provider.of<DataGridService>(context);

    return Scaffold(
      appBar: appBar,
      body: BlocProvider(
        create: (BuildContext context) => AgreementListBloc(
          sharedPrefsService: sharedPrefsService,
          dataGridService: dataGridService,
        )..add(OpenScreen()),
        child: AgreementViewBody(),
      ),
    );
  }
}

class AgreementViewBody extends StatefulWidget {
  @override
  _AgreementViewBodyState createState() => _AgreementViewBodyState();
}

class _AgreementViewBodyState extends State<AgreementViewBody> {
  @override
  Widget build(BuildContext context) {
    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameAgreement);

    List<ApproveListItem> _documentList = [];

    for (int i = 0; i < 100; i++) {
      ApproveListItem approveItem = new ApproveListItem();
      // approveItem.cardUrgent = true;
      approveItem.dokar = "VHD";
      approveItem.doknr = i.toString();
      approveItem.content = "Документ $i";
      //этого свойства нет, подставить в таблицу вместо нум
      // approveItem.documentType = '';
      approveItem.documentTypeText = 'Приказ';
      approveItem.regNUM = i.toString();
      approveItem.rcvdDT = DateTime.now().add(new Duration(days: -1 * i));
      // decisionItem.doknr = i.toString();
      // decisionItem.dokar = "01$i";
      approveItem.dokvr = "00$i";
      approveItem.doktl = "000$i";
      approveItem.wfItem = "02$i";
      approveItem.logsys = 'logsys';

      _documentList.add(approveItem);
    }

    AgreementDataSource _decisionListSource =
        new AgreementDataSource(_documentList);

    return BlocConsumer<AgreementListBloc, AgreementListState>(
      listener: (context, state) {
        if (state is AgreementListFailure) {
          Dialogs.errorDialog(
            context: context,
            content: Text('${state.error}'),
          );
        }
        if (state is AgreementListSortInit) {
          state.sortDataList!.forEach((element) {
            _decisionListSource.sortedColumns.add(element);
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
                  source: _decisionListSource,
                  gridLinesVisibility: GridLinesVisibility.horizontal,
                  columns: [
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
                    BlocProvider.of<AgreementListBloc>(context).add(
                      SortDataSave(
                          sortDataList: _decisionListSource.sortedColumns),
                    );
                    _decisionListSource.sort();
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

class AgreementDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  AgreementDataSource(List<ApproveListItem> employees) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'dokar', value: dataGridRow.dokar),
              DataGridCell<String>(
                  columnName: 'rcvdDT', value: dataGridRow.rcvdDTText),
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
        routeTypeCard: 'agreement',
        cellsList: row.getCells(),
        childWidget: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            color: DataGridService.getRowBackgroundColor(index),
            child: IconsService.getIconRK(row.getCells()[0].value)),
      ),
      ContainerCell(
        routeTypeCard: 'agreement',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[1].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'agreement',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[2].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
      ContainerCell(
        routeTypeCard: 'agreement',
        cellsList: row.getCells(),
        childWidget: ContainerTextCell(
          textValue: row.getCells()[3].value.toString(),
          color: DataGridService.getRowBackgroundColor(index),
        ),
      ),
    ]);
  }
}
