import 'package:MWPX/data_structure/card/body/CardItemKey.dart';
import 'package:MWPX/data_structure/card/body/VoiceNoteTableItem.dart';
import 'package:intl/intl.dart';

class IterationTableItem extends CardItemKey {
  DateFormat dateFormat = DateFormat("dd.MM.yyyy HH:mm:ss");

  /// Номер итерации Рук-Пом
  late int iterNr;

  /// Дата и время создания итерации
  late DateTime createdDT;

  /// ФИО автора
  late String authorName;

  /// Тип итерации (вроде бы не используется, возможно надо удалить)
  late String iterType;

  /// Текстовый коментарий
  late String noteText;

  /// Текстовое представление даты и времени создания итерации
  String get createdDTText {
    return dateFormat.format(createdDT);
  }

  /// Список звуковых заметок, относящихся к данной итерации
  late List<VoiceNoteTableItem> voiceNoteList;

  /// <summary>
  /// Конструктор, инициализация значений
  /// </summary>
  IterationTableItem() : super() {
    iterNr = 0;
    createdDT = emptyDate;
    authorName = "";
    iterType = "";
    noteText = "";
    voiceNoteList = [];
    tableName = "MST_Iteration";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logsys,
      'dokar': dokar,
      'doknr': doknr,
      'dokvr': dokvr,
      'doktl': doktl,
      'iterNr': iterNr,
      'createdDT': createdDT.millisecondsSinceEpoch,
      'authorName': authorName,
      'iterType': iterType,
      'noteText': noteText
    };

    return map;
  }
}
