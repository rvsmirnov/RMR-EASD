import 'package:MWPX/data_structure/TableRow.dart';

/// Класс для хранения ключа РК. От него наследуются структуры хранения данных
class CardKey extends TableRow {
  /// Логическая система
  String logsys = "";

  /// Тип карточки
  String dokar = "";

  /// Номер карточки
  String doknr = "";

  /// Версия ( обычно - 00)
  String dokvr = "00";

  /// DOKTL ( обычно - 000)
  String doktl = "000";

  /// Пустая дата для подстановки в качестве начального значения полей данных в классах-потомках
  final DateTime emptyDate = new DateTime(1900, 01, 01, 00, 00, 00);

  /// Конструктор с пустыми значениями
  CardKey() {
    this.logsys = "";
    this.dokar = "";
    this.doknr = "";
    this.dokvr = "00";
    this.doktl = "000";
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    logsys = pMap['logsys'];
    dokar = pMap['dokar'];
    doknr = pMap['doknr'];
    dokvr = pMap['dokvr'];
    doktl = pMap['doktl'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logsys,
      'dokar': dokar,
      'doknr': doknr,
      'dokvr': dokvr,
      'doktl': doktl,
    };
    return map;
  }

  @override
  String toString() {
    return "LS=$logsys KEY=$dokar $doknr $dokvr $doktl ";
  }

  @override
  String getWhereExp() {
    return "logsys=? and dokar=? and doknr=? and dokvr=? and doktl=?";
  }

  @override
  List<Object?> getWhereKey() {
    return {logsys, dokar, doknr, dokvr, doktl}.toList();
  }
}
