import 'package:MWPX/data_structure/card/list/CardListItem.dart';

class ApproveListItem extends CardListItem {
  /// Вид документа (Пиьмо, Телеграмма, Протокол...)
  /// Значения  Поручение, Командировка, Отпуск формируются в данном поле исходя из типа РК
  late String documentTypeText;

  /// Конструктор
  ApproveListItem() : super() {
    documentTypeText = "";
  }
}
