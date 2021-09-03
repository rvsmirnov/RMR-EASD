import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:intl/intl.dart';

class VacationCard extends CardHeader {
  /// ФИО сотрудника, уходящего в отпуск
  late String emplName;

  /// Подразделение сотрудника, уходящего в отпуск
  late String emplPodr;

  /// Должность сотрудника, уходящего в отпуск
  late String emplState;

  /// Дата начала отпуска
  late DateTime begDA;

  /// Дата окончания отпуска
  late DateTime endDA;

  /// Количество календарных дней отпуска
  late int calendarDays;

  /// Флаг того, что отпуск на территории РФ или с выездом за границу
  /// Значение "D" - на территории РФ
  late String intnlFlag;

  /// Место проведения отпуска
  late String location;

  /// Флаг "Отпуск неоплачиваемый"
  late bool unpaidFlag;

  /// ФИО замещающего отпускника сотрудника
  late String substName;

  /// Дополнительная информация для отпуска
  late String addInfText;

  /// Резолюция Президента при подписании отпуска
  late String resolutionText;

  /// ФИО подписывающего
  late String signerName;

  /// Подразделение подписывающего
  late String signerDepartment;

  DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  String get emplPodrStateText => this.emplPodr + " (" + this.emplState + ")";

  String get vacationPeriodText =>
      this.dateFormat.format(this.begDA) +
      " - " +
      dateFormat.format(this.endDA);

  String get calendarDaysText => this.calendarDays.toString() + " к.дн.";

  String get vacationTypeText =>
      this.intnlFlag == "D" ? "На территории РФ" : "Зарубежный";

  /// Конструктор, инициализация данных
  VacationCard() : super() {
    this.emplName = "";
    this.emplPodr = "";
    this.emplState = "";

    this.begDA = emptyDate;
    this.endDA = emptyDate;
    this.calendarDays = 0;

    this.intnlFlag = "";
    this.location = "";
    this.unpaidFlag = false;
    this.substName = "";
    this.addInfText = "";
    this.resolutionText = "";

    this.signerName = "";
    this.signerDepartment = "";
    this.tableName = "Vacation";
  }

  /// Получить Фамилию и инциалы по полному ФИО
  String getShortFIO(String longFIO) {
    var fioParts = longFIO.split(' ');
    return fioParts[0] +
        " " +
        fioParts[1].substring(0, 1) +
        ". " +
        fioParts[2].substring(0, 1) +
        ".";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logsys,
      'dokar': dokar,
      'doknr': doknr,
      'dokvr': dokvr,
      'doktl': doktl,
      'begDT': begDA.millisecondsSinceEpoch,
      'endDT': endDA.millisecondsSinceEpoch,
      'calenddays': calendarDays,
      'intnl': intnlFlag,
      'location': location,
      'unpaid': unpaidFlag ? 1 : 0,
      'emplName': emplName,
      'substName': substName,
      'resText': resolutionText,
      'addInfText': addInfText,
      'emplDepartment': emplPodr,
      'emplPosition': emplState,
      'signerName': signerName,
      'signerDepartment': signerDepartment
    };

    return map;
  }
}
