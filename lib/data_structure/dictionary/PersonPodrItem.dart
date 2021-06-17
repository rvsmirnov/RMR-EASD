import 'package:MWPX/data_structure/dictionary/DictionaryItem.dart';

/// Класс для хранения данных о Сотрудниках и Подразделениях, загружаемых в РМР из ЕАСД
class PersonPodrItem extends DictionaryItem {
  /// Идентификатор сотрудника
  late String personCode;

  /// Идентификатор подразделения
  late String podrCode;

  /// Идентификатор должности
  late String postCode;

  /// ФИО Сотрудника
  late String personText;

  /// Название подраздедения
  late String podrText;

  /// Название должности
  late String postText;

  ///флаг выбранности в списке сотрудников
  late bool isSelected;

  /// ФИО и подразделение сотрудника
  String get personPodrText {
    if (personText.trim().isEmpty) {
      return podrText;
    } else {
      return "$personText ($podrText)";
    }
  }

  /// Конструктор, инициализация
  PersonPodrItem() : super() {
    this.personCode = "";
    this.podrCode = "";
    this.postCode = "";
    this.personText = "";
    this.podrText = "";
    this.postText = "";
    this.isSelected = false;
  }

  /// <summary>
  /// Отображение данных класса в текстовом виде
  /// </summary>
  /// <returns>Возвращает строку информации о Сотруднике/Подразделени</returns>
  @override
  String toString() {
    return "[${super.toString()}] $personText-$podrText-$postText";
  }
}
