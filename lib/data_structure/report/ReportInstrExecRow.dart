import 'package:MWPX/data_structure/CardListKey.dart';
import 'package:intl/intl.dart';

/// Класс для работы с данными отчетов
class ReportInstrExecRow extends CardListKey {
  DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  late String dokarPr;
  late String doknrPr;
  late String dokvrPr;
  late String doktlPr;
  late String repColor;
  late String infoParent;
  late String infoInstruction;
  late String execList;
  late String infoStatusProc;
  late DateTime dateVP;
  late DateTime ctrlDate;
  late DateTime ispDate;
  late bool instrForContract;
  late String dokarRel;
  late String doknrRel;
  late String dokvrRel;
  late String doktlRel;
  late String infoPorIsp;
  late String signerName;
  late String createdDT;
  late String changedDT;

  late int rowNum;

  /// Текстовое представление даты срока исполнения
  String get ctrlDateText {
    if (ctrlDate == emptyDate) {
      return "";
    } else {
      return dateFormat.format(ctrlDate);
    }
  }

  /// Текстовое представление даты срока исполнения
  String get ispDateText {
    if (ispDate == emptyDate) {
      return "";
    } else {
      return dateFormat.format(ispDate);
    }
  }

  String get deltaText {
    String sDelta = "0";
    String sWord = "суток";
    Duration tsDelta;
    int iDays;

    DateTime dtNow = DateTime.now();

    DateTime dtNowRound = new DateTime(dtNow.year, dtNow.month, dtNow.day);

    DateTime dtCtrDateRound = new DateTime(
        this.ctrlDate.year, this.ctrlDate.month, this.ctrlDate.day);
    DateTime dtIspDateRound =
        new DateTime(this.ispDate.year, this.ispDate.month, this.ispDate.day);

    if (this.ispDate == emptyDate) {
      tsDelta = dtCtrDateRound.difference(dtNowRound);
    } else {
      tsDelta = dtCtrDateRound.difference(dtIspDateRound);
    }

    iDays = tsDelta.inDays;
    sDelta = iDays.toString();

    if (sDelta.endsWith("1")) {
      sWord = "сутки";
    } else {
      sWord = "суток";
    }

    return "$sDelta $sWord";
  }

  String get infoInstructionShort {
    String sText = "";
    String sController = "";
    int iIndex;

    try {
      if (infoInstruction.isNotEmpty) {
        iIndex = infoInstruction.lastIndexOf("На контроле у ");
        if (iIndex > 0) {
          sController = infoInstruction.substring(iIndex);
          sText = infoInstruction.substring(0, iIndex);
          if (sText.length > 120) {
            sText = sText.substring(0, 120) + "...\r\n\r\n" + sController;
          } else {
            sText = infoInstruction;
          }
        } else {
          sText = infoInstruction;
        }
      } else {
        sText = infoInstruction;
      }
    } catch (e) {
      sText = infoInstruction;
    }

    return sText;
  }

  /// <summary>
  /// Конструктор, инициализация строки отчета
  /// </summary>
  ReportInstrExecRow() : super() {
    dokarPr = "";
    doknrPr = "";
    dokvrPr = "";
    doktlPr = "";
    repColor = "";
    infoParent = "";
    infoInstruction = "";
    execList = "";
    infoStatusProc = "";
    dateVP = emptyDate;
    ctrlDate = emptyDate;
    ispDate = emptyDate;
    instrForContract = false;
    dokarRel = "";
    doknrRel = "";
    dokvrRel = "";
    doktlRel = "";
    infoPorIsp = "";
    signerName = "";
    createdDT = "";
    changedDT = "";
    rowNum = 0;
  }

  /// <summary>
  /// Представление строки отчета в текстовом виде.
  /// </summary>
  /// <returns></returns>
  @override
  String toString() {
    return "$repColor ${(instrForContract ? "(к договору)" : "")} ${super.toString()} $infoInstruction";
  }
}
