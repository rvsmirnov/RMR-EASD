import 'package:MWPX/data_structure/card/list/CardListItem.dart';

class VacationSignListItem extends CardListItem {
  late String emplName;

  late DateTime begDa;

  late DateTime endDa;

  late int duration;

  late String emplPodr;

  late String emplState;

  String get emplPodrStateText {
    String sResult = "";
    if (emplPodr.isNotEmpty) {
      sResult = emplPodr;
    }

    if (sResult.isNotEmpty) {
      sResult += " (" + emplState + ")";
    } else {
      sResult = emplState;
    }

    return sResult;
  }

  String get vacationPeriod {
    return "${dateFormat.format(begDa)} - ${dateFormat.format(endDa)}";
  }

  String get durationText {
    return "$duration к.дн.";
  }

  /// Конструктор
  VacationSignListItem() : super() {
    emplName = "";
    begDa = emptyDate;
    endDa = emptyDate;
    duration = 0;
    emplPodr = "";
    emplState = "";
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    emplName = pMap['emplName'];
    begDa = DateTime.fromMillisecondsSinceEpoch(pMap['begDT']);
    endDa = DateTime.fromMillisecondsSinceEpoch(pMap['endDT']);
    duration = pMap['calenddays'];
    emplPodr = pMap['emplDepartment'];
    emplState = pMap['emplPosition'];

    super.fromMap(pMap);
  }

  @override
  String toString() {
    return super.toString() + " Содержание: $emplName, $emplPodr";
  }
}
