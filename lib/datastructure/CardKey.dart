
/// Класс для хранения ключа РК. От него наследуются структуры хранения данных
class CardKey
{

  /// Логическая система
  String logsys;

  /// Тип карточки
  String dokar;

  /// Номер карточки
  String doknr;

  /// Версия ( обычно - 00)
  String dokvr;

  /// DOKTL ( обычно - 000)
  String doktl;

  /// Пустая дата для подстановки в качестве начального значения полей данных в классах-потомках
  final DateTime emptyDate = new DateTime(1900, 01, 01, 00, 00, 00);

  /// Конструктор с пустыми значениями
  CardKey()
  {
    this.logsys = "";
    this.dokar = "";
    this.doknr = "";
    this.dokvr = "";
    this.doktl = "";
  }

  //CardKey(this.logsys, this.dokar, this.doknr, this.dokvr, this.doktl);

}