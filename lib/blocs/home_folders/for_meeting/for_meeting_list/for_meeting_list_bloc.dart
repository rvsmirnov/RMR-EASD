import 'package:MWPX/services/data_grid_service.dart';
import 'package:MWPX/services/shared_prefers_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

part 'for_meeting_list_event.dart';
part 'for_meeting_list_state.dart';

class ForMeetingListBloc extends Bloc<ForMeetingListEvent, ForMeetingListState> {
  final SharedPrefsService? sharedPrefsService;
  final DataGridService? dataGridService;

  ForMeetingListBloc({
    @required this.sharedPrefsService,
    @required this.dataGridService,
  })  : assert(sharedPrefsService != null, dataGridService != null),
        super(ForMeetingListInitial());

  @override
  Stream<ForMeetingListState> mapEventToState(ForMeetingListEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield ForMeetingListLoading();
        List<String> stringList =
            await sharedPrefsService!.getStringList(key: 'for_meeting_sort_data');
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
                yield ForMeetingListSortInit(
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
        yield ForMeetingListSortInit(
          sortDataList: sortDataList,
        );
      } catch (error) {
        print('error in ForMeetingListBloc $error');
        yield ForMeetingListFailure(error: error.toString());
      }
    }

    if (event is SortDataSave) {
      try {
        yield ForMeetingListLoading();
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
            .setStringList(key: 'for_meeting_sort_data', stringList: stringList);
      } catch (error) {
        print('error in ForMeetingListBloc $error');
        yield ForMeetingListFailure(error: error.toString());
      }
    }
  }
}
