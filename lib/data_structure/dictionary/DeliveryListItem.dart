import 'package:MWPX/data_structure/dictionary/DictionaryItem.dart';

/// Строка списка рассылки
class DeliveryListItem extends DictionaryItem {
  /// Код списка рассылки
  late String listCode;

  /// Номер строки в списке
  late String recnr;

  /// Идентификатор сотрудника
  late String personCode;

  /// ФИО сотрудника
  late String personText;

  /// Идентификатор подразделения
  late String podrCode;

  /// Название подразделения
  late String podrText;

  /// Идентификатор должности
  late String postCode;

  /// Название должности
  late String postText;

  /// поле для чекбокса при выборе значений справочника на экране
  late bool isSelected;

  /// Конструктор, инициализация
  DeliveryListItem() : super() {
    this.listCode = "";
    this.recnr = "";
    this.personCode = "";
    this.personText = "";
    this.podrCode = "";
    this.podrText = "";
    this.postCode = "";
    this.postText = "";
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "${super.toString()} $listCode-$personText-$podrText-$postText";
  }
}
