import 'package:MWPX/data_structure/card/body/CardItemKey.dart';

/// Атрибуты Исполнителя РК Поручения
class ExecutorTableItem extends CardItemKey {
  /// ФИО Исполнителя
  late String executorName;

  /// Идентификатор Исполнителя
  late String executorCode;

  /// Подразделение Исполнителя
  late String executorDepartment;

  /// Идентификатор подразделения исполнителя
  late String executorDepartmentCode;

  /// Признак "Ответственный Исполнитель"
  late bool respExec;

  /// Поле для вывода Исполнителя в таблицах.
  /// Если это сотрудни к - выведется ФИО, если подразделление - выведется название подразделения
  String get executorNameDepartment {
    String sResult = "";

    if (executorName.isNotEmpty) {
      sResult = executorName;
    } else {
      sResult = executorDepartment;
    }

    return sResult;
  }

  /// <summary>
  /// Конструктор, инициализация
  /// </summary>
  ExecutorTableItem() : super() {
    executorName = "";
    executorDepartment = "";
    respExec = false;
    executorCode = "";
    executorDepartmentCode = "";
    tableName = "Ins_Executor";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logsys,
      'dokar': dokar,
      'doknr': doknr,
      'dokvr': dokvr,
      'doktl': doktl,
      'recNr': recNr,
      'executorName': executorName,
      'executorDepartment': executorDepartment,
      'respExec': respExec ? 1 : 0,
      'executorCode': executorCode,
      'executorDepartmentCode': executorDepartmentCode
    };
    return map;
  }

  /// <summary>
  /// Текстовое представление Исполнителя РК Поручения
  /// </summary>
  /// <returns>Признак "Ответственный", ФИО и подразделение Исполнителя, а так же ключ РК </returns>
  @override
  String toString() {
    return "${(respExec ? '*' : ' ')} $executorName $executorDepartment - ${super.toString()}";
  }
}
