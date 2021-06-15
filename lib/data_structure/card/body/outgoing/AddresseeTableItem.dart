import 'package:MWPX/data_structure/card/body/CardItemKey.dart';

/// Атрибуты адресата РК Исходящего
class AddresseeTableItem extends CardItemKey {
  /// ФИО адресата
  late String addresseeName;

  /// Подразделение адресата
  late String addresseeOrg;

  /// Должность адресата
  late String addresseePost;

  /// Конструктор, инициализация значений
  AddresseeTableItem() : super() {
    addresseeName = "";
    addresseeOrg = "";
    addresseePost = "";
  }

  /// Текстовое представление адресата РК Исходящего
  @override
  String toString() {
    return "${super.toString()} $addresseeName($addresseeOrg)";
  }
}
