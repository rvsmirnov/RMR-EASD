import 'package:MWPX/data_structure/TableRow.dart';

/// Общий родительский класс для записей справочников
/// Справочники могут быть из разных систем, поэтому тут объявим Логическую систему
class DictionaryItem extends TableRow {
  /// Логическая система
  late String logSys;

  /// Конструктор, инициализация
  DictionaryItem() {
    logSys = "";
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "[ЛС-$logSys]";
  }
}
