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

  @override
  fromMap(Map<String, dynamic> pMap) {
    cardUrgent = pMap['cardUrgent'] == '1';
    mainAuthor = pMap['mainAuthor'];
    content = pMap['content'];
    regNUM = pMap['regNum'];
    regDATE = DateTime.fromMillisecondsSinceEpoch(pMap['regDate']);

    super.fromMap(pMap);
  }

  @override
  String toString() {
    return super.toString() +
        "Номер:$regNumText $regDateText , Содержание:$content Автор:$mainAuthor";
  }
}
