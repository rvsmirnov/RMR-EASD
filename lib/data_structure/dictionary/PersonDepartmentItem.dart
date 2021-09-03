import 'package:MWPX/data_structure/dictionary/DictionaryItem.dart';

/// Класс для хранения данных о Сотрудниках и Подразделениях, загружаемых в РМР из ЕАСД
class PersonDepartmentItem extends DictionaryItem {
  /// Идентификатор сотрудника
  late String personCode;

  /// Идентификатор подразделения
  late String departmentCode;

  /// Идентификатор должности
  late String positionCode;

  /// ФИО Сотрудника
  late String personText;

  /// Название подраздедения
  late String departmentText;

  /// Название должности
  late String positionText;

  ///флаг выбранности в списке сотрудников
  late bool isSelected;

  /// ФИО и подразделение сотрудника
  String get personDepartmentText {
    if (personText.trim().isEmpty) {
      return departmentText;
    } else {
      return "$personText ($departmentText)";
    }
  }

  /// Конструктор, инициализация
  PersonDepartmentItem() : super() {
    this.personCode = "";
    this.departmentCode = "";
    this.positionCode = "";
    this.personText = "";
    this.departmentText = "";
    this.positionText = "";
    this.isSelected = false;
    tableName = "PersonDepartment";
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logSys,
      'personCode': personCode,
      'departmentCode': departmentCode,
      'positionCode': positionCode,
      'personText': personText,
      'departmentText': departmentText,
      'positionText': positionText
    };
    return map;
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    logSys = pMap['logsys'];
    personCode = pMap['personCode'];
    departmentCode = pMap['departmentCode'];
    positionCode = pMap['positionCode'];
    personText = pMap['personText'];
    departmentText = pMap['departmentText'];
    positionText = pMap['positionText'];
  }

  /// <summary>
  /// Отображение данных класса в текстовом виде
  /// </summary>
  /// <returns>Возвращает строку информации о Сотруднике/Подразделени</returns>
  @override
  String toString() {
    return "[${super.toString()}] $personText-$departmentText-$positionText";
  }
}
