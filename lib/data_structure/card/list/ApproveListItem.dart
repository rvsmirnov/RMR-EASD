import 'package:MWPX/data_structure/card/list/CardListItem.dart';

class ApproveListItem extends CardListItem {
  /// Вид документа (Пиьмо, Телеграмма, Протокол...)
  /// Значения  Поручение, Командировка, Отпуск формируются в данном поле исходя из типа РК
  late String documentTypeText;

  /// Конструктор
  ApproveListItem() : super() {
    documentTypeText = "";
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    content = pMap['content'];
    //regNUM = pMap['regNum'];
    //regDATE = DateTime.fromMillisecondsSinceEpoch(pMap['regDate']);
    super.fromMap(pMap);
    if (dokar == "LVE") {
      documentTypeText = "Отпуск";
    } else if (dokar == "BTR") {
      documentTypeText = "Командировка";
    } else {
      documentTypeText = pMap['docTypeText'];
    }
  }

  @override
  String toString() {
    return super.toString() + "Тип: $documentTypeText Содержание: $content";
  }
}
