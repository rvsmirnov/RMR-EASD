import 'package:MWPX/datastructure/CardListItem.dart';

/// Элемент списка папки "На решение"
class DecisionListItem extends CardListItem {
  /// Признак "Важность"
  late bool cardUrgent;

  /// Основной автор, заполняется для Входящего
  late String mainAuthor;

  /// Содержание документа
  /// У Командировок и Отпусков тут сборная строка из полей РК, так как отдельного содержания там нет
  late String content;

  /// Конструктор
  DecisionListItem() : super() {
    cardUrgent = false;
    mainAuthor = "";
    content = "";
  }
}
