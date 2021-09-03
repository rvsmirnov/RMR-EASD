import 'package:MWPX/data_structure/card/list/CardListItem.dart';

class BTripSignListItem extends CardListItem {
  /// Дата начала командировки
  late DateTime begDT;

  /// Страна пребывания
  late String country;

  /// Город пребывания
  late String city;

  /// Длительность в календарных днях
  late int duration;

  /// Дата начала текстом
  String get begDTText {
    return dateFormat.format(begDT);
  }

  /// текст СТРАНА (ГОРОД)
  String get countryCityText {
    return "$country ($city)";
  }

  /// Текст для продолжительности командировки
  String get durationText {
    return "$duration к.дн.";
  }

  /// Конструктор
  BTripSignListItem() : super() {
    begDT = emptyDate;
    country = "";
    city = "";
    duration = 0;
  }

  @override
  fromMap(Map<String, dynamic> pMap) {
    begDT = DateTime.fromMillisecondsSinceEpoch(pMap['begDT']);
    country = pMap['countryText'];
    city = pMap['ncity'];
    duration = pMap['calendDays'];
    super.fromMap(pMap);
  }

  @override
  String toString() {
    return super.toString() + " Содержание: $countryCityText";
  }
}
