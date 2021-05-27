import 'package:MWPX/datastructure/CardListKey.dart';
import 'package:intl/intl.dart';

class VacationCard extends CardListKey {
  /// ФИО сотрудника, уходящего в отпуск
  String emplName;

  /// Подразделение сотрудника, уходящего в отпуск
  String emplPodr;

  /// Должность сотрудника, уходящего в отпуск
  String emplState;

  /// Дата начала отпуска
  DateTime begDA;

  /// Дата окончания отпуска
  DateTime endDA;

  /// Количество календарных дней отпуска
  int calendarDays;

  /// Флаг того, что отпуск на территории РФ или с выездом за границу
  /// Значение "D" - на территории РФ
  String intnlFlag;

  /// Место проведения отпуска
  String location;

  /// Флаг "Отпуск неоплачиваемый"
  bool unpaidFlag;

  /// ФИО замещающего отпускника сотрудника
  String substName;

  /// Дополнительная информация для отпуска
  String addInfText;

  /// Резолюция Президента при подписании отпуска
  String resolutionText;

  /// ФИО подписывающего
  String signerName;

  /// Подразделение подписывающего
  String signerPodr;

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
    this.signerPodr = "";
  }

  String getShortFIO(String longFIO) {
    var fioParts = longFIO.split(' ');
    return fioParts[0] +
        " " +
        fioParts[1].substring(0, 1) +
        ". " +
        fioParts[2].substring(0, 1) +
        ".";
  }
}
