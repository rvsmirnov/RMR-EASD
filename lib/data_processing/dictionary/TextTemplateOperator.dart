import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/dictionary/TextTemplateItem.dart';

abstract class TextTemplateOperator {
  /// Получить содержимое справочника
  static Future<List<TextTemplateItem>> getDictData() async {
    List<TextTemplateItem> result = [];

    var dictData = await DB.selectTable('TextTemplate');

    for (var dictItem in dictData) {
      TextTemplateItem item = new TextTemplateItem();
      item.fromMap(dictItem);
      result.add(item);
    }

    return result;
  }

  /// Вставить запись справочника в БД
  static Future<void> insert(TextTemplateItem pItem) async {
    await DB.insert(pItem.tableName, pItem);
  }

  /// Очистить содержимое справочника
  static Future<void> clearAll() async {
    await DB.delete('TextTemplate', '1=1', []);
  }
}
