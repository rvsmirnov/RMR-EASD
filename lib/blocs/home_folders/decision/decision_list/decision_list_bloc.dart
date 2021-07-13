import 'package:MWPX/services/data_grid_service.dart';
import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/services/shared_prefers_service.dart';
import 'package:MWPX/styles/mwp_icons.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

part 'decision_list_event.dart';
part 'decision_list_state.dart';

class DecisionListBloc extends Bloc<DecisionListEvent, DecisionListState> {
  final SharedPrefsService? sharedPrefsService;
  final DataGridService? dataGridService;

  DecisionListBloc({
    @required this.sharedPrefsService,
    @required this.dataGridService,
  })  : assert(sharedPrefsService != null, dataGridService != null),
        super(DecisionListInitial());

  @override
  Stream<DecisionListState> mapEventToState(DecisionListEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield DecisionListLoading();
        List<String> stringList =
            await sharedPrefsService!.getStringList(key: 'decision_sort_data');
        List<SortColumnDetails>? sortDataList = <SortColumnDetails>[];
        if (stringList != null) {
          int listCount = stringList.length;
          int ii = 0;
          if (listCount > 0) {
            for (int i = 0; i < listCount / 2; i++) {
              // print('stringList[ii] ${stringList[ii]}');
              // print('-0- ii $ii');
              // print(
              //     'dataGridService!.getsortDirectionValue(stringList[ii++])) ${dataGridService!.getsortDirectionValue(stringList[ii++])}');
              // print('-1- ii $ii');
              String columnName = stringList[ii];
              // print('-0- ii $ii');
              // print('columnName $columnName');
              ii++;
              // print('-1- ii $ii');
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
        yield DecisionListSortInit(
          sortDataList: sortDataList,
        );
      } catch (error) {
        print('error in DecisionListBloc $error');
        yield DecisionListFailure(error: error.toString());
      }
    }

    if (event is SortDataSave) {
      try {
        yield DecisionListLoading();
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
            .setStringList(key: 'decision_sort_data', stringList: stringList);
      } catch (error) {
        print('error in DecisionListBloc $error');
        yield DecisionListFailure(error: error.toString());
      }
    }
  }
}
