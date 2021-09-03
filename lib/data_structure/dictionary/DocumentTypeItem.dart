import 'package:MWPX/data_structure/dictionary/DictionaryItem.dart';

/// Тип документа ЕАСД
class DocumentTypeItem extends DictionaryItem {
  /// Код типа документа
  late String sCode;

  /// Наименование типа документа
  late String value;

  /// Конструктор, инициализация
  DocumentTypeItem() : super() {
    this.sCode = "";
    this.value = "";
    tableName = 'DocumentType';
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logSys,
      'sCode': sCode,
      'value': value
    };
    return map;
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    logSys = pMap['logsys'];
    sCode = pMap['sCode'];
    value = pMap['value'];
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "${super.toString()} $sCode-$value";
  }
}
