import 'package:MWPX/data_structure/CardKey.dart';

///Класс для дочерних таблиц карточек(Делегаты, Маршрут и т. д.)
class CardItemKey extends CardKey {
  /// Порядковый номер записи в списке. В маршрутной таблице сюда кладем RECNR
  late String recNr;

  /// <summary>
  /// Конструктор, инициализация
  /// </summary>
  CardItemKey() : super() {
    recNr = "";
  }
}
