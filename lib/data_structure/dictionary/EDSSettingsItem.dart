import 'package:MWPX/data_structure/dictionary/DictionaryItem.dart';

/// Класс для хранения настроек использования ЭП для разных типов документов в системе
class EDSSettingsItem extends DictionaryItem {
  /// Использовать или нет ЭП для ОРД
  late int ordEDS;

  /// Использовать или нет ЭП для Исходящих
  late int isdEDS;

  ///Настроена ли ЭП вообще для пользователя
  late bool isEDSEnable;

  ///Флаг того, что система из которой получены данные справочников является основной для пользователя
  late bool isSystemNative;

  /// Конструктор, инициализация
  EDSSettingsItem() : super() {
    this.ordEDS = 0;
    this.isdEDS = 0;
    this.isEDSEnable = false;
    this.isSystemNative = false;
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "[${super.toString()}] ORD-$ordEDS ISD-$isdEDS";
  }
}
