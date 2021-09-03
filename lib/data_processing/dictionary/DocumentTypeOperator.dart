import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/dictionary/DocumentTypeItem.dart';

///Класс для работы со справочником типов документов
abstract class DocumentTypeOperator {
  /// Получить содержимое справочника
  static Future<List<DocumentTypeItem>> getDictData() async {
    List<DocumentTypeItem> result = [];

    var dictData = await DB.selectTable('DocumentType');

    for (var dictItem in dictData) {
      DocumentTypeItem item = new DocumentTypeItem();
      item.fromMap(dictItem);
      result.add(item);
    }

    return result;
  }

  /// Вставить запись справочника в БД
  static Future<void> insert(DocumentTypeItem pItem) async {
    await DB.insert(pItem.tableName, pItem);
  }

  /// Очистить содержимое справочника
  static Future<void> clearAll() async {
    await DB.delete('DocumentType', '1=1', []);
  }
}
