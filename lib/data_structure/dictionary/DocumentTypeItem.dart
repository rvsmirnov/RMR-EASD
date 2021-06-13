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
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "${super.toString()} $sCode-$value";
  }
}
