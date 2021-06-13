import 'package:MWPX/data_structure/card/list/CardListItem.dart';

///Элемент списка папки На ознакомление
class AcquaintanceListItem extends CardListItem {
  /// Вид документа (Пиьмо, Телеграмма, Протокол...)
  /// Значения  Поручение, Командировка, Отпуск формируются в данном поле исходя из типа РК
  late String documentTypeText;

  /// Признак "Важность"
  late bool cardUrgent;

  /// Конструктор
  AcquaintanceListItem() : super() {
    documentTypeText = "";
    cardUrgent = false;
  }
}
