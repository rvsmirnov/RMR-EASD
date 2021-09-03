import 'package:MWPX/data_structure/dictionary/DictionaryItem.dart';

/// Класс для получения и хранения типовых текстов(для резолюций и поручений), загружаемых в РМР из ЕАСД
class TextTemplateItem extends DictionaryItem {
  /// Тип РК, к которой привязан типовой текст
  late String cardType;

  /// Тип текста: S - Общесистемный; O - На подраздедение пользователя; P- Личный пользовательский
  late String textType;

  /// Значение текста(собственно слова и буквы)
  late String textValue;

  /// Конструктор, инициализация
  TextTemplateItem() : super() {
    this.cardType = "";
    this.textType = "";
    this.textValue = "";
    tableName = "TextTemplate";
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logSys,
      'cardType': cardType,
      'textType': textType,
      'textValue': textValue
    };
    return map;
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    logSys = pMap['logsys'];
    cardType = pMap['cardType'];
    textType = pMap['textType'];
    textValue = pMap['textValue'];
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "[${super.toString()}] $cardType-$textType-$textValue";
  }
}
