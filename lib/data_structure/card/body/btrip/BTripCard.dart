import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:MWPX/data_structure/card/body/btrip/DelegationTableItem.dart';
import 'package:intl/intl.dart';

class BTripCard extends CardHeader {
  /// Флаг "Иностранная командировка"
  late bool isInternational;

  /// Название целевой страны
  late String countryText;

  /// Название города, куда едем
  late String nCity;

  /// Начало командировки, если общее для делегации
  late DateTime begDT;

  /// Окончание командировки, если общее для делегации
  late DateTime endDT;

  /// Продолжительность, в календарных днях
  late int calendarDays;

  /// Вид транспорта
  late String transportType;

  /// Флаг "Общие для делегации"
  /// Если он установлен, то поля BEG_DT, END_DT, CALENDDAYS, TRANSP одинковые для всех членов делегации
  late bool globalFlag;

  /// Пункт плана, если командировка плановая
  late String planPunkt;

  /// Флаг "Командировка плановая"
  late bool planFlag;

  /// Цель командировки
  late String goalText;

  /// Дополнительная информация для командровки
  late String addInfText;

  /// Текст резолюции Президента при подписании командировки
  late String resText;

  /// Подписывающий командировку
  late String signerName;

  /// Подразделение подписывающего
  late String signerDepartment;

  /// Текст вида командировки
  String get isInternationalText =>
      (this.isInternational ? "Зарубежная" : "На территории РФ");

  String get begDTText => dateFormat.format(this.begDT);

  String get endDTText => dateFormat.format(this.endDT);

  String get calendarDaysText => this.calendarDays.toString() + ' к.дн.';

  DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  late List<DelegationTableItem> delegationTable;

  /// Конструктор, инициализация
  BTripCard() : super() {
    this.isInternational = false;
    this.countryText = "";
    this.nCity = "";
    this.begDT = emptyDate;
    this.endDT = emptyDate;
    this.calendarDays = 0;
    this.transportType = "";
    this.globalFlag = false;
    this.planPunkt = "";
    this.planFlag = false;
    this.resText = "";
    this.goalText = "";
    this.addInfText = "";
    this.signerName = "";
    this.signerDepartment = "";
    this.delegationTable = [];
    this.tableName = 'BTrip';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logsys,
      'dokar': dokar,
      'doknr': doknr,
      'dokvr': dokvr,
      'doktl': doktl,
      'intnl': isInternational ? 1 : 0,
      'countryText': countryText,
      'nCity': nCity,
      'begDT': begDT.millisecondsSinceEpoch,
      'endDT': endDT.millisecondsSinceEpoch,
      'calendDays': calendarDays,
      'transp': transportType,
      'globflag': globalFlag ? 1 : 0,
      'plpunkt': planPunkt,
      'planFlag': planFlag ? 1 : 0,
      'resText': resText,
      'goalText': goalText,
      'addInfText': addInfText,
      'signerName': signerName,
      'signerDepartment': signerName
    };

    return map;
  }
}
