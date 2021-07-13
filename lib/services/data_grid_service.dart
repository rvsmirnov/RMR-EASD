import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataGridService {
  DataGridSortDirection getsortDirectionValue(String string) {
    if (string == 'DataGridSortDirection.ascending') {
      return DataGridSortDirection.ascending;
    }
    // if (string == 'DataGridSortDirection.descending') {
    return DataGridSortDirection.descending;
    // }
  }
}
