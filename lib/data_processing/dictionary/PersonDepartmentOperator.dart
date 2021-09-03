import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/dictionary/PersonDepartmentItem.dart';

abstract class PersonDepartmentOperator {
  /// Получить содержимое справочника
  static Future<List<PersonDepartmentItem>> getDictData() async {
    List<PersonDepartmentItem> result = [];
    List<String> aSql = [
      "select * from PersonDepartment where personText <> '' order by personText",
      "select * from PersonDepartment where personText = '' order by departmentText"
    ];

    for (String sSql in aSql) {
      var dictData = await DB.rawSelect(sSql);

      for (var dictItem in dictData) {
        PersonDepartmentItem item = new PersonDepartmentItem();
        item.fromMap(dictItem);
        result.add(item);
      }
    }
    return result;
  }

  /// Вставить запись справочника в БД
  static Future<void> insert(PersonDepartmentItem pItem) async {
    await DB.insert(pItem.tableName, pItem);
  }

  /// Очистить содержимое справочника
  static Future<void> clearAll() async {
    await DB.delete('PersonDepartment', '1=1', []);
  }
}
