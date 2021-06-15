import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:MWPX/data_structure/card/body/instruction/ExecutorTableItem.dart';

/// Атрибуты РК Поручения
class InstructionCard extends CardHeader {
  /// ФИО инициатора поручения
  late String initiatorName;

  /// ФИО подписывающего поручение
  late String signerName;

  /// ФИО контролера Поручения
  late String controllerName;

  /// Идентификатор  вида контроля Поручения
  /// 00 - не на контроле, 01 - контроль, 02 - особый контроль
  late String ctrlType;

  /// Идентификатор срочности Поручения
  /// 1 - Обычное, 2 - срочное, 3 - В.Срочное
  late String urgency;

  /// Признак "Конфиденциально"
  late bool chkConf;

  /// Срок исполнения Поручени
  late DateTime ctrlDate;

  /// Фактическая дата исполнения поручения
  late DateTime factExecDate;

  /// Поле "Чем Исполнено"
  late String executionText;

  /// Поле "Положение с выполнение"
  late String statusProcText;

  /// Пункт Поручения
  late String punkt;

  /// Текст загловка РК поручения
  String get cardHeaderText {
    if (regNumFull.isEmpty) {
      return "Поручение";
    } else {
      if (regNumFull.startsWith("№")) {
        return "Поручение к " + regNumFull;
      } else {
        return "Поручение " + regNumFull;
      }
    }
  }

  String get controlDateText {
    if (ctrlDate == emptyDate) {
      return "";
    } else {
      return "Срок исполнения: " + dateFormat.format(ctrlDate);
    }
  }

  String get controllerDateText {
    return "Контролер: " + controllerName;
  }

  String get punktText {
    if (punkt.isNotEmpty) {
      return "Пункт: " + punkt;
    } else {
      return "";
    }
  }

  String get signerNameText {
    if (signerName.isNotEmpty) {
      return "Подписал: " + signerName;
    } else {
      return "";
    }
  }

  String get controlHighTest {
    String sControlType;
    switch (ctrlType) {
      case "02":
        sControlType = "особый контроль";
        break;
      default:
        sControlType = "";
        break;
    }

    return sControlType;
  }

  /// Для последовательной нумерации исполнителей
  late int maxExecutorRecnr;

  /// Таблица исполнителей РК Поручения (локальная)
  late List<ExecutorTableItem> _executorTable;

  /// Таблица исполнителей РК Поручения
  List<ExecutorTableItem> get executorTable {
    return _executorTable;
  }

  /// Конструктор, инициализация значений
  InstructionCard() : super() {
    initiatorName = "";
    signerName = "";
    controllerName = "";
    ctrlType = "";
    urgency = "";
    chkConf = false;
    ctrlDate = emptyDate;
    factExecDate = emptyDate;
    executionText = "";
    statusProcText = "";
    punkt = "";

    _executorTable = [];
  }

  /// Текстовое представление РК Поручения
  @override
  String toString() {
    return "Поручение $initiatorName (${dateFormat.format(ctrlDate)}) ${super.toString()}";
  }
}
