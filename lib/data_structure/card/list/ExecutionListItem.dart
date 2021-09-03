import 'package:MWPX/data_structure/card/list/CardListItem.dart';

class ExecutionListItem extends CardListItem {
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

      // if (sDelta.substring(sDelta.length - 2, sDelta.length - 1) == "1") {
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

  /// ФИО Контролера поручения, заполняется для РК Поручения
  late String controllerName;

  /// Светофор, говорящий о приближении срока или просрочке поручения
  late String _execLight;

  /// Светофор, говорящий о приближении срока или просрочке поручения
  String get execLight => _execLight;

  /// Срок исполнения поручения(дата контроля)
  late DateTime _ctrlDate;

  /// Срок выполнения (для поручений)
  DateTime get ctrlDate {
    return _ctrlDate;
  }

  /// Срок выполнения (для поручений)
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

  /// Пункт Поручения, заполняется для РК Поручения
  late String punkt;

  /// ФИО Подписывающего, заполняется для РК Поручения
  late String signerName;

  /// Конструктор
  ExecutionListItem() : super() {
    controllerName = "";
    ctrlDate = emptyDate;
    cardUrgent = false;
    punkt = "";
    signerName = "";
    _execLight = "cl6";
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    content = pMap['content'];
    cardUrgent = pMap['cardUrgent'] == '1';
    controllerName = pMap['controllerName'];
    ctrlDate = DateTime.fromMillisecondsSinceEpoch(pMap['ctrlDate']);
    punkt = pMap['punkt'];
    signerName = pMap['signerName'];

    super.fromMap(pMap);
  }
}
