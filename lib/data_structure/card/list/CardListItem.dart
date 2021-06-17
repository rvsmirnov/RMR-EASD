import 'package:MWPX/data_structure/CardListKey.dart';
import 'package:intl/intl.dart';

//Общий предок классов списков РК
class CardListItem extends CardListKey {
  DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  /// Дата получения карточки пользователем
  late DateTime rcvdDT;

  /// Регистрационный номер в текстовом виде, в формате ВХ-17/ГВЦ
  late String regNUM;

  /// Дата регистрации в текстовом виде, в формате дд.ММ.гггг
  late DateTime regDATE;

  /// <summary>
  /// Статус обработки РК:
  /// 0 - доступна для обработки;
  /// 1 - обработана в РМР;
  /// </summary>
  late int cardProcessed;

  /// <summary>
  /// Статус просмотра РК:
  /// 0 - новая РК, еще не открытая ни разу;
  /// 1 - открыта хоть раз;
  /// </summary>
  late int cardOpened;

  /// <summary>
  /// Дата поступления РК в рабочее место в формате дд.ММ.гггг
  /// </summary>
  String get rcvdDTText {
    if (this.rcvdDT.year == 1900) {
      return "";
    } else {
      return dateFormat.format(this.rcvdDT);
    }
  }

  String get regNumText {
    return this.regNUM == "" ? "" : "№ " + this.regNUM;
  }

  String get regDateText {
    return regDATE == emptyDate ? "" : "от " + dateFormat.format(this.regDATE);
  }

  late String createdDT;
  late String changedDT;

  late int fileCount;

  /// Содержание документа
  /// У Командировок и Отпусков тут сборная строка из полей РК, так как отдельного содержания там нет
  late String content;

  /// <summary>
  /// Конструктор, инициализация значений
  /// </summary>
  CardListItem() : super() {
    rcvdDT = emptyDate;
    regNUM = "";
    regDATE = emptyDate;
    cardProcessed = 0;
    cardOpened = 0;
    createdDT = "";
    changedDT = "";
    fileCount = 0;
    content = "";
  }
}
