import 'package:MWPX/data_structure/card/body/CardItemKey.dart';
import 'package:intl/intl.dart';

class VoiceNoteTableItem extends CardItemKey {
  DateFormat dateFormat = DateFormat("dd.MM.yyyy HH:mm:ss");

  /// Номер итерации Рук-Пом
  late int iterNr;

  late String recExtId;
  late String version;

  late DateTime createdDT;
  late bool isNew;
  late String noteName;

  String get createdDTText {
    return dateFormat.format(createdDT);
  }

  VoiceNoteTableItem() : super() {
    iterNr = 0;
    recExtId = "";
    version = "";
    createdDT = emptyDate;
    isNew = true;
    noteName = "Заметка";
  }
}
