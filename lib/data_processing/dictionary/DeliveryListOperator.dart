import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/dictionary/DeliveryListHeaderItem.dart';
import 'package:MWPX/data_structure/dictionary/DeliveryListMemberItem.dart';

/// Класс для записи и чтения из БД данных о списках рассылки
abstract class DeliveryListOperator {
  /// Получить заголовки списков рассылки
  static Future<List<DeliveryListHeaderItem>> getHeaderList() async {
    List<DeliveryListHeaderItem> result = [];

    var dictData = await DB.selectTable('DeliveryListHeader');

    for (var dictItem in dictData) {
      DeliveryListHeaderItem item = new DeliveryListHeaderItem();
      item.fromMap(dictItem);
      result.add(item);
    }

    return result;
  }

  /// Получить элементы списков рассылки
  static Future<List<DeliveryListMemberItem>> getMemeberList(
      String pListCode) async {
    List<DeliveryListMemberItem> result = [];

    List<String> aSql = [
      '''select distinct itm.logsys, itm.listCode,
                         itm.recnr, pers.personCode, pers.personText, 
                         pers.departmentCode, pers.departmentText, 
                         pers.positionCode, pers.positionText 
            from DeliveryListMember as itm,
              PersonDepartment as pers
            where pers.personCode = itm.itemCode
              and itm.listCode='$pListCode'  
            order by itm.recnr''',
      '''select distinct itm.logsys, itm.listCode,
                         itm.recnr, pers.personCode, pers.personText, 
                         pers.departmentCode, pers.departmentText, 
                         pers.positionCode, pers.positionText 
            from DeliveryListMember as itm,
              PersonDepartment as pers
            where pers.departmentCode = itm.itemCode
              and pers.personCode = ''
              and itm.listCode='$pListCode'  
            order by itm.recnr'''
    ];

    for (String sSql in aSql) {
      var dictData = await DB.rawSelect(sSql);

      for (var dictItem in dictData) {
        DeliveryListMemberItem item = new DeliveryListMemberItem();
        item.fromMap(dictItem);
        result.add(item);
      }
    }

    return result;
  }

  /// Вставить запись заголовка списка рассылки в БД
  static Future<void> insertHeader(DeliveryListHeaderItem pItem) async {
    await DB.insert(pItem.tableName, pItem);
  }

  /// Вставить запись элемента списка рассылки в БД
  static Future<void> insertMember(DeliveryListMemberItem pItem) async {
    await DB.insert(pItem.tableName, pItem);
  }

  /// Очистить содержимое всего справочника
  static Future<void> clearAll() async {
    await DB.delete('DeliveryListHeader', '1=1', []);
    await DB.delete('DeliveryListMember', '1=1', []);
  }
}
