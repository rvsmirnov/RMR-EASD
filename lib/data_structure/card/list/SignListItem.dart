import 'package:MWPX/data_structure/card/list/CardListItem.dart';

///Строка списка документов На подписание
class SignListItem extends CardListItem {
  /// Признак "Важность"
  late bool cardUrgent;

  /// Вид документа (Пиьмо, Телеграмма, Протокол...)
  /// Значения  Поручение, Командировка, Отпуск формируются в данном поле исходя из типа РК
  late String documentTypeText;

  /// Конструктор
  SignListItem() : super() {
    documentTypeText = "";
    cardUrgent = false;
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    content = pMap['content'];
    cardUrgent = pMap['cardUrgent'] == '1';
    documentTypeText = pMap['docTypeText'];

    super.fromMap(pMap);
  }

  @override
  String toString() {
    return super.toString() +
        "Тип: $documentTypeText Содержание: $content Важность: $cardUrgent";
  }
}
