import 'package:MWPX/data_structure/card/body/CardItemKey.dart';

/// Атрибуты адресата РК Исходящего
class AddresseeTableItem extends CardItemKey {
  /// ФИО адресата
  late String addresseeName;

  /// Подразделение адресата
  late String addresseeDepartment;

  /// Должность адресата
  late String addresseePosition;

  /// Конструктор, инициализация значений
  AddresseeTableItem() : super() {
    addresseeName = "";
    addresseeDepartment = "";
    addresseePosition = "";
    tableName = "Outg_Addressee";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logsys,
      'dokar': dokar,
      'doknr': doknr,
      'dokvr': dokvr,
      'doktl': doktl,
      'recNr': recNr,
      'addresseeName': addresseeName,
      'addresseeDepartment': addresseeDepartment,
      'addresseePosition': addresseePosition
    };
    return map;
  }

  /// Текстовое представление адресата РК Исходящего
  @override
  String toString() {
    return "${super.toString()} $addresseeName($addresseeDepartment)";
  }
}
