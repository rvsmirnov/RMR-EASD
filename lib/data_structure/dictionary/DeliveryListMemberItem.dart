import 'package:MWPX/data_structure/dictionary/DictionaryItem.dart';

/// Строка списка рассылки
class DeliveryListMemberItem extends DictionaryItem {
  /// Код списка рассылки
  late String listCode;

  /// Номер строки в списке
  late String recnr;

  /// Идентификатор сотрудника
  late String personCode;

  /// ФИО сотрудника
  late String personText;

  /// Идентификатор подразделения
  late String departmentCode;

  /// Название подразделения
  late String departmentText;

  /// Идентификатор должности
  late String positionCode;

  /// Название должности
  late String positionText;

  /// поле для чекбокса при выборе значений справочника на экране
  late bool isSelected;

  /// Конструктор, инициализация
  DeliveryListMemberItem() : super() {
    this.listCode = "";
    this.recnr = "";
    this.personCode = "";
    this.personText = "";
    this.departmentCode = "";
    this.departmentText = "";
    this.positionCode = "";
    this.positionText = "";
    this.isSelected = false;
    tableName = "DeliveryListMember";
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logSys,
      'listCode': listCode,
      'recnr': recnr,
      'itemCode': personCode
    };
    return map;
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    logSys = pMap['logsys'];
    listCode = pMap['listCode'];
    recnr = pMap['recnr'];
    personCode = pMap['personCode'];
    personText = pMap['personText'];
    departmentCode = pMap['departmentCode'];
    departmentText = pMap['departmentText'];
    positionCode = pMap['positionCode'];
    positionText = pMap['positionText'];
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "${super.toString()} $listCode-$personText-$departmentText-$positionText";
  }
}
