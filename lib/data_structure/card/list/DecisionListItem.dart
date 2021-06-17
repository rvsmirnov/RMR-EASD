import 'package:MWPX/data_structure/card/list/CardListItem.dart';

/// Элемент списка папки "На решение"
class DecisionListItem extends CardListItem {
  /// Признак "Важность"
  late bool cardUrgent;

  /// Основной автор, заполняется для Входящего
  late String mainAuthor;

  /// Конструктор
  DecisionListItem() : super() {
    cardUrgent = false;
    mainAuthor = "";
  }
}
