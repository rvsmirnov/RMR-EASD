import 'package:MWPX/data_structure/card/body/CardHeader.dart';

/// Атрибуты РК ОРД
class ORDCard extends CardHeader {
  /// ФИО Исполнителя(инициатора)
  late String executorName;

  /// Подразделения Исполнителя(инициатора)
  late String executorOrg;

  /// ФИО Подписывающего
  late String signerName;

  String get executorOrgText {
    return "Исполнитель: $executorOrg";
  }

  /// Конструктор, инициализация значений
  ORDCard() : super() {
    executorName = "";
    executorOrg = "";
    signerName = "";
    tableName = "ORD";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logsys,
      'dokar': dokar,
      'doknr': doknr,
      'dokvr': dokvr,
      'doktl': doktl,
      'executorName': executorName,
      'executorDepartment': executorOrg,
      'signerName': signerName
    };
    return map;
  }

  /// Строковое представление ОРД
  @override
  String toString() {
    return "${super.toString()} $documentType $executorName";
  }
}
