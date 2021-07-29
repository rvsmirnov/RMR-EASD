import 'package:MWPX/services/data_grid_service.dart';
import 'package:MWPX/services/shared_prefers_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

part 'execution_list_event.dart';
part 'execution_list_state.dart';

class ExecutionListBloc extends Bloc<ExecutionListEvent, ExecutionListState> {
  final SharedPrefsService? sharedPrefsService;
  final DataGridService? dataGridService;

  ExecutionListBloc({
    @required this.sharedPrefsService,
    @required this.dataGridService,
  })  : assert(sharedPrefsService != null, dataGridService != null),
        super(ExecutionListInitial());

  @override
  Stream<ExecutionListState> mapEventToState(ExecutionListEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield ExecutionListLoading();
        List<String> stringList =
            await sharedPrefsService!.getStringList(key: 'execution_sort_data');
        List<SortColumnDetails>? sortDataList = <SortColumnDetails>[];
        if (stringList != null) {
          int listCount = stringList.length;
          int ii = 0;
          if (listCount > 0) {
            for (int i = 0; i < listCount / 2; i++) {
              String columnName = stringList[ii];
              ii++;
              DataGridSortDirection sortDirection =
                  dataGridService!.getsortDirectionValue(stringList[ii]);
              ii++;
              if (columnName == null || sortDirection == null) {
                yield ExecutionListSortInit(
                  sortDataList: <SortColumnDetails>[],
                );
              }
              print('sortDirection $sortDirection');
              sortDataList.add(
                SortColumnDetails(
                  name: columnName,
                  sortDirection: sortDirection,
                ),
              );
            }
          }
        }
        yield ExecutionListSortInit(
          sortDataList: sortDataList,
        );
      } catch (error) {
        print('error in ExecutionListBloc $error');
        yield ExecutionListFailure(error: error.toString());
      }
    }

    if (event is SortDataSave) {
      try {
        yield ExecutionListLoading();
        print('SortDataSave sortDataList ${event.sortDataList}');
        List<SortColumnDetails>? sortDataList = event.sortDataList;
        List<String> stringList = <String>[];

        sortDataList!.forEach((element) {
          print('element.name ${element.name}');
          stringList.add(element.name);
          print(
              'element.sortDirection.toString() ${element.sortDirection.toString()}');
          stringList.add(element.sortDirection.toString());
        });
        await sharedPrefsService!
            .setStringList(key: 'execution_sort_data', stringList: stringList);
      } catch (error) {
        print('error in ExecutionListBloc $error');
        yield ExecutionListFailure(error: error.toString());
      }
    }
  }
}
