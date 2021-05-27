import 'package:MWPX/datastructure/CardItemKey.dart';

class DelegationTableItem extends CardItemKey {
  /// <summary>
  /// ФИО делегата
  /// </summary>
  String fioText;

  /// <summary>
  /// Подразделение делегата
  /// </summary>
  String orgText;

  /// <summary>
  /// Должность делегата
  /// </summary>
  String postText;

  /// <summary>
  /// Дата начала пребывания в командировке
  /// </summary>
  DateTime begDT;

  /// <summary>
  /// Дата окончания пребывания в командировке
  /// </summary>
  DateTime endDT;

  /// <summary>
  /// Продолжительность пребывания в командировке (в календарных днях)
  /// </summary>
  int calendarDays;

  /// <summary>
  /// Вид транспорта, на котором делегат едет в командировку
  /// </summary>
  String transportType;

  DelegationTableItem() : super() {
    fioText = "";
    orgText = "";
    postText = "";

    begDT = emptyDate;
    endDT = emptyDate;
    calendarDays = 0;

    transportType = "";
  }
}
