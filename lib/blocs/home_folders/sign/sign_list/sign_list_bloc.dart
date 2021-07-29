import 'package:MWPX/services/data_grid_service.dart';
import 'package:MWPX/services/shared_prefers_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

part 'sign_list_event.dart';
part 'sign_list_state.dart';

class SignListBloc extends Bloc<SignListEvent, SignListState> {
  final SharedPrefsService? sharedPrefsService;
  final DataGridService? dataGridService;

  SignListBloc({
    @required this.sharedPrefsService,
    @required this.dataGridService,
  })  : assert(sharedPrefsService != null, dataGridService != null),
        super(SignListInitial());

  @override
  Stream<SignListState> mapEventToState(SignListEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield SignListLoading();
        List<String> stringList =
            await sharedPrefsService!.getStringList(key: 'sign_sort_data');
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
        yield SignListSortInit(
          sortDataList: sortDataList,
        );
      } catch (error) {
        print('error in SignListBloc $error');
        yield SignListFailure(error: error.toString());
      }
    }

    if (event is SortDataSave) {
      try {
        yield SignListLoading();
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
            .setStringList(key: 'sign_sort_data', stringList: stringList);
      } catch (error) {
        print('error in SignListBloc $error');
        yield SignListFailure(error: error.toString());
      }
    }
  }
}
