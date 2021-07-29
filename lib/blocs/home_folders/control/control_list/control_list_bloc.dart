import 'package:MWPX/services/data_grid_service.dart';
import 'package:MWPX/services/shared_prefers_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

part 'control_list_event.dart';
part 'control_list_state.dart';

class ControlListBloc extends Bloc<ControlListEvent, ControlListState> {
  final SharedPrefsService? sharedPrefsService;
  final DataGridService? dataGridService;

  ControlListBloc({
    @required this.sharedPrefsService,
    @required this.dataGridService,
  })  : assert(sharedPrefsService != null, dataGridService != null),
        super(ControlListInitial());

  @override
  Stream<ControlListState> mapEventToState(ControlListEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield ControlListLoading();
        List<String> stringList =
            await sharedPrefsService!.getStringList(key: 'control_sort_data');
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
                yield ControlListSortInit(
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
        yield ControlListSortInit(
          sortDataList: sortDataList,
        );
      } catch (error) {
        print('error in ControlListBloc $error');
        yield ControlListFailure(error: error.toString());
      }
    }

    if (event is SortDataSave) {
      try {
        yield ControlListLoading();
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
            .setStringList(key: 'control_sort_data', stringList: stringList);
      } catch (error) {
        print('error in ControlListBloc $error');
        yield ControlListFailure(error: error.toString());
      }
    }
  }
}
