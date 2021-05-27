import 'package:MWPX/datastructure/CardListKey.dart';
import 'package:MWPX/datastructure/card/DelegationTableItem.dart';
import 'package:intl/intl.dart';

class BTripCard extends CardListKey {
  /// Флаг "Иностранная командировка"
  bool isInternational;

  /// Название целевой страны
  String countryText;

  /// Название города, куда едем
  String nCity;

  /// Начало командировки, если общее для делегации
  DateTime begDT;

  /// Окончание командировки, если общее для делегации
  DateTime endDT;

  /// Продолжительность, в календарных днях
  int calendarDays;

  /// Вид транспорта
  String transportType;

  /// Флаг "Общие для делегации"
  /// Если он установлен, то поля BEG_DT, END_DT, CALENDDAYS, TRANSP одинковые для всех членов делегации
  bool globalFlag;

  /// Пункт плана, если командировка плановая
  String planPunkt;

  /// Флаг "Командировка плановая"
  bool planFlag;

  /// Цель командировки
  String goalText;

  /// Дополнительная информация для командровки
  String addInfText;

  /// Текст резолюции Президента при подписании командировки
  String resText;

  /// Подписывающий командировку
  String signerName;

  /// Подразделение подписывающего
  String signerPodr;

  /// Текст вида командировки
  String get isInternationalText =>
      (this.isInternational ? "Зарубежная" : "На территории РФ");

  String get begDTText => dateFormat.format(this.begDT);

  String get endDTText => dateFormat.format(this.endDT);

  String get calendarDaysText => this.calendarDays.toString() + ' к.дн.';

  DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  List<DelegationTableItem> delegationTable;

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

    delegationTable = new List<DelegationTableItem>();
  }
}
