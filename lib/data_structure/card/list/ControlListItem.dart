import 'package:MWPX/data_structure/card/list/CardListItem.dart';

class ControlListItem extends CardListItem {
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

      if (sDelta.substring(sDelta.length - 1, 1) == "1") {
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

  /// Светофор, говорящий о приближении срока или просрочке поручения
  late String _execLight;

  /// Светофор, говорящий о приближении срока или просрочке поручения
  String get execLight => _execLight;

  /// Срок исполнения поручения(дата контроля)
  late DateTime _ctrlDate;

  /// Срок выполнения (для поручений) в формате дд.ММ.гггг
  DateTime get ctrlDate {
    return _ctrlDate;
  }

  set ctrlDate(DateTime value) {
    _ctrlDate = value;
    if (_ctrlDate != emptyDate) {
      int dtDiff = _ctrlDate.difference(DateTime.now()).inDays;

      if (dtDiff >= 7) {
        _execLight = "cl4";
      } else if (dtDiff >= 2 && dtDiff < 7) {
        _execLight = "cl3green";
      } else if (dtDiff >= 0 && dtDiff < 2) {
        _execLight = "cl2yellow";
      } else if (dtDiff < 0) {
        _execLight = "cl1red";
      } else {
        _execLight = "cl5";
      }
    } else {
      _execLight = "cl6";
    }
  }

  /// Признак "Важность"
  late bool cardUrgent;

  /// Конструктор
  ControlListItem() : super() {
    ctrlDate = emptyDate;
    cardUrgent = false;
    _execLight = "cl6";
  }
}
