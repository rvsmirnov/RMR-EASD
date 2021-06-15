import 'package:MWPX/data_structure/card/body/CardItemKey.dart';

/// Атрибуты Исполнителя РК Поручения
class ExecutorTableItem extends CardItemKey {
  /// ФИО Исполнителя
  late String executorName;

  /// Идентификатор Исполнителя
  late String executorCode;

  /// Подразделение Исполнителя
  late String executorOrg;

  /// Идентификатор подразделения исполнителя
  late String executorOrgCode;

  /// Признак "Ответственный Исполнитель"
  late bool respExec;

  /// Поле для вывода Исполнителя в таблицах.
  /// Если это сотрудни к - выведется ФИО, если подразделление - выведется название подразделения
  String get executorNameOrg {
    String sResult = "";

    if (executorName.isNotEmpty) {
      sResult = executorName;
    } else {
      sResult = executorOrg;
    }

    return sResult;
  }

  /// <summary>
  /// Конструктор, инициализация
  /// </summary>
  ExecutorTableItem() : super() {
    executorName = "";
    executorOrg = "";
    respExec = false;
    executorCode = "";
    executorOrgCode = "";
  }

  /// <summary>
  /// Текстовое представление Исполнителя РК Поручения
  /// </summary>
  /// <returns>Признак "Ответственный", ФИО и подразделение Исполнителя, а так же ключ РК </returns>
  @override
  String toString() {
    return "${(respExec ? '*' : ' ')} $executorName $executorOrg - ${super.toString()}";
  }
}
