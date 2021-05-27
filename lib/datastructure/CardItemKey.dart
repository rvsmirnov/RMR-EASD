import 'package:MWPX/datastructure/CardKey.dart';

///Класс для дочерних таблиц карточек(Делегаты, Маршрут и т. д.)
class CardItemKey extends CardKey {
  /// Порядковый номер записи в списке. В маршрутной таблице сюда кладем RECNR
  String recNr;

  /// <summary>
  /// Конструктор, инициализация
  /// </summary>
  CardItemKey() : super() {
    recNr = "";
  }
}
