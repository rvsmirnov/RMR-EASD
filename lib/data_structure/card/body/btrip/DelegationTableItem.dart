import 'package:MWPX/data_structure/card/body/CardItemKey.dart';

class DelegationTableItem extends CardItemKey {
  /// <summary>
  /// ФИО делегата
  /// </summary>
  late String fioText;

  /// <summary>
  /// Подразделение делегата
  /// </summary>
  late String orgText;

  /// <summary>
  /// Должность делегата
  /// </summary>
  late String postText;

  /// <summary>
  /// Дата начала пребывания в командировке
  /// </summary>
  late DateTime begDT;

  /// <summary>
  /// Дата окончания пребывания в командировке
  /// </summary>
  late DateTime endDT;

  /// <summary>
  /// Продолжительность пребывания в командировке (в календарных днях)
  /// </summary>
  late int calendarDays;

  /// <summary>
  /// Вид транспорта, на котором делегат едет в командировку
  /// </summary>
  late String transportType;

  DelegationTableItem() : super() {
    fioText = "";
    orgText = "";
    postText = "";

    begDT = emptyDate;
    endDT = emptyDate;
    calendarDays = 0;

    transportType = "";

    tableName = "BTrip_Delegation";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logsys,
      'dokar': dokar,
      'doknr': doknr,
      'dokvr': dokvr,
      'doktl': doktl,
      'recNr': recNr,
      'nameText': fioText,
      'departmentText': orgText,
      'positionText': postText,
      'begDT': begDT.millisecondsSinceEpoch,
      'endDT': endDT.millisecondsSinceEpoch,
      'calendDays': calendarDays,
      'transp': transportType
    };

    return map;
  }
}
