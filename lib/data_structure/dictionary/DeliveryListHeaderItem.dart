import 'package:MWPX/data_structure/dictionary/DictionaryItem.dart';

/// Заголовок списка рассылки
class DeliveryListHeaderItem extends DictionaryItem {
  /// Идентификатор списка рассылки
  late String sCode;

  /// Название списка рассылки
  late String headerText;

  /// Конструктор, инициализация
  DeliveryListHeaderItem() : super() {
    this.sCode = "";
    this.headerText = "";
    tableName = "DeliveryListHeader";
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logSys,
      'sCode': sCode,
      'headerText': headerText
    };
    return map;
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    logSys = pMap['logsys'];
    sCode = pMap['sCode'];
    headerText = pMap['headerText'];
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "${super.toString()} $sCode-$headerText";
  }
}
