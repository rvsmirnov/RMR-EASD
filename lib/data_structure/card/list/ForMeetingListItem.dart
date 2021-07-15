import 'package:MWPX/data_structure/card/list/CardListItem.dart';

class ForMeetingListItem extends CardListItem {
  /// Признак "Важность"
  late bool cardUrgent;

  /// Вид документа (Пиьмо, Телеграмма, Протокол...)
  /// Значения  Поручение, Командировка, Отпуск формируются в данном поле исходя из типа РК
  late String documentTypeText;

  /// Основной автор, заполняется для Входящего
  late String mainAuthor;

  /// Дата срока исполнения
  late DateTime ctrlDate;

  /// Для поручений - просрочка или остаток после или до срока исполнения, в формате "N суток"
  String get deltaText {
    String sDelta = "0";
    String sWord = "суток";
    Duration tsDelta;
    int iDays;

    if (this.ctrlDate == emptyDate) {
      return "";
    } else {
      tsDelta = ctrlDate.difference(DateTime.now());

      iDays = tsDelta.inDays;
      sDelta = iDays.toString();

      if (sDelta.endsWith('1')) {
        sWord = "сутки";
      } else {
        sWord = "суток";
      }
      return "$sDelta $sWord";
    }
  }

  /// Текстовое представление даты срока исполнения
  String get ctrlDateText {
    if (ctrlDate == emptyDate) {
      return "";
    } else {
      return dateFormat.format(ctrlDate);
    }
  }

  /// Конструктор
  ForMeetingListItem() : super() {
    cardUrgent = false;
    mainAuthor = "";
    ctrlDate = emptyDate;
  }
}
