import 'package:MWPX/data_structure/CardListKey.dart';
import 'package:MWPX/data_structure/card/body/IterationTableItem.dart';
import 'package:MWPX/data_structure/card/body/RouteTableItem.dart';
import 'package:MWPX/data_structure/card/body/VoiceNoteTableItem.dart';
import 'package:intl/intl.dart';
import 'FileTableItem.dart';

//Класс заголовка РК. Тут хранятся общие атрибуты каждой РК
class CardHeader extends CardListKey {
  DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  /// Тех. номер карточки. Это усеченный DOKNR, получаем его из ЕАСД, сами его не делаем
  late String doknrTRUNC;

  /// Создатель карточки, логин
  late String createdBy;

  /// Дата создания карточки
  late DateTime createdDT;

  /// Последний изменивший карточку
  late String changedBy;

  /// Дата последнего изменения карточки
  late DateTime changedDT;

  /// Содержание РК
  late String content;

  /// Регистрационный номер РК
  late String regNum;

  /// Дата регистрации
  late DateTime regDate;

  /// Вид документа
  late String documentType;

  /// Название вида документа
  late String documentTypeText;

  /// Признак "Важность"
  late int cardUrgent;

  /// Дата получения карточки пользователем
  /// Может быть разная для одной и той же РК в разных папках
  late DateTime rcvdDT;

  /// Текстовое представление даты получения РК
  String get rcvdDTText {
    if (rcvdDT.year == 1900) {
      return "";
    } else {
      return "Получено: ${dateFormat.format(rcvdDT)}";
    }
  }

  /// Количество файлов, которое должно быть у РК
  late int syncFileCount;

  /// Признак принадлежности РК к папке "К совещанию"
  late bool forMeeting;

  /// Номер текущей строки согласования
  String get currentAPRNR {
    String sResult = "";

    // foreach (RouteTableItem ri in _routeTable)
    // {
    //     if (ri.WFITEM == this.WFITEM)
    //     {
    //         s_result = ri.RECNR;
    //     }
    // }

    return sResult;
  }

  /// Полный регистрационный номер
  String get regNumFull {
    String sRegNum = "";

    if (regNum != "") {
      sRegNum = "№ {$regNum}";
    }

    if (regDate != emptyDate) {
      sRegNum += " от {$dateFormat.format(regDate)}";
    }
    return sRegNum;
  }

  /// Маршрутная таблица, внутренняя
  late List<RouteTableItem> _routeTable;

  /// Маршрутная таблица
  List<RouteTableItem> get routeTable {
    return _routeTable;
  }

  /// Таблица файлов, внутренняя
  late List<FileTableItem> _fileTable;

  /// Таблица файлов
  List<FileTableItem> get fileTable {
    return _fileTable;
  }

  /// Таблица коментариев Руководитель/Помощник, внутренняя
  late List<IterationTableItem> _iterationTable;

  /// Таблица коментариев Руководитель/Помощник
  List<IterationTableItem> get iterationTable {
    return _iterationTable;
  }

  /// Текущая итерация. Та, которую Рукоководитель редактирует на момент работы с РК
  IterationTableItem get currentIteration {
    if (_iterationTable.length == 0) {
      return new IterationTableItem();
    } else {
      return _iterationTable[_iterationTable.length - 1];
    }
  }

  /// ФИО самого пользователя РМР, используется в некоторых вычислениях
  String selfFIO = "";

  /// Самая свежая итерация помощника. Та, информация из которой показывается в видимом сегменте доп. информации
  IterationTableItem get lastIteration {
    if (_iterationTable.length == 0) {
      return new IterationTableItem();
    } else {
      if (this.folderCode == "00003") {
        IterationTableItem itmResult = new IterationTableItem();
        itmResult.iterNr = -1;
        for (int i = 0; i < _iterationTable.length; i++) {
          if (_iterationTable[i].noteText != "" &&
              _iterationTable[i].authorName.toUpperCase() !=
                  selfFIO.toUpperCase()) {
            itmResult = _iterationTable[i];
            break;
          }
        }
        return itmResult;
      } else
        return _iterationTable[0];
    }
  }

  /// числовой тип РК
  String get cardType {
    switch (dokar) {
      case "ORD":
        return "010001";
      case "ДКИ":
        return "010002";
      case "VHD":
        return "010004";
      case "ISD":
        return "010005";
      case "LVE":
        return "010008";
      case "BTR":
        return "010010";
      default:
        return "";
    }
  }

  /// Конструктор, инициализация значений
  CardHeader() : super() {
    doknrTRUNC = "";

    createdBy = "";
    createdDT = emptyDate;

    changedBy = "";
    changedDT = emptyDate;

    content = "";

    regNum = "";
    regDate = emptyDate;

    _routeTable = [];
    _fileTable = [];
    _iterationTable = [];

    documentType = "";

    cardUrgent = 0;

    rcvdDT = new DateTime(1900, 1, 1, 0, 0, 1);

    forMeeting = false;
  }

  /// <summary>
  /// Получить из полного ФИО короткую форму с инициалами
  /// </summary>
  /// <param name="p_long_fio">Полное ФИО</param>
  String getShortFIO(String pLongFIO) {
    String sShortFIO;
    List<String> arrFIO;

    sShortFIO = pLongFIO;

    arrFIO = pLongFIO.split(' ');

    if (arrFIO.length == 3) {
      sShortFIO =
          "{$arrFIO[0]} {$arrFIO[1].substring(0, 1)}. {$arrFIO[2].substring(0, 1)}.";
    }

    return sShortFIO;
  }

  /// <summary>
  /// Отображение данных класса в текстовом виде
  /// </summary>
  /// <returns>Возвращает ключ и содержание РК</returns>
  @override
  String toString() {
    return "Ключ [${super.toString()}] Содержание [$content]";
  }

  /// Информация о карточке одной строкой
  String get cardInfo {
    String sKey = super.toString();
    String sComment = "";
    String sVoiceNoteList = "";
    String sFileList = "";
    String sGraphNoteList = "";

    for (FileTableItem file in _fileTable) {
      if (file.isSelected) {
        sFileList += "[X]" + file.descriptionFilename + ", ";
      } else {
        sFileList += file.descriptionFilename + ", ";
      }

      // if (file.InkStrokeContent != null) {
      //   sGraphNoteList += file.descriptionFilename  + ", ";
      // }
    }

    if (sFileList.length > 0) {
      sFileList = sFileList.substring(0, sFileList.length - 2);
    }

    if (sGraphNoteList.length > 0) {
      sGraphNoteList = sGraphNoteList.substring(0, sGraphNoteList.length - 2);
    }

    sComment = currentIteration.noteText;

    for (VoiceNoteTableItem voice in currentIteration.voiceNoteList) {
      sVoiceNoteList += voice.noteName + ", ";
    }

    if (sVoiceNoteList.length > 0) {
      sVoiceNoteList = sVoiceNoteList.substring(0, sVoiceNoteList.length - 2);
    }

    return "Ключ:[$sKey] Файлы:[$sFileList] Комментарий:[$sComment] Аудио:[$sVoiceNoteList] Графические заметки:[$sGraphNoteList]";
  }
}
