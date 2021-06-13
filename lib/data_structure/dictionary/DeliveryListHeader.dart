import 'package:MWPX/data_structure/dictionary/DictionaryItem.dart';

/// Заголовок списка рассылки
class DeliveryListHeader extends DictionaryItem {
  /// Идентификатор списка рассылки
  late String sCode;

  /// Название списка рассылки
  late String headerText;

  /// Конструктор, инициализация
  DeliveryListHeader() : super() {
    this.sCode = "";
    this.headerText = "";
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "${super.toString()} $sCode-$headerText";
  }
}
