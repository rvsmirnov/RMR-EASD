import 'package:intl/intl.dart';

///Класс для преобразования разных типов данных из формата SAP в формат DART
abstract class SapTypeHelper {
  static late DateFormat dateTimeFormat;

  SapTypeHelper() {
    dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  }

  ///Преобразовать строку даты из SAP в тип DateTime
  static DateTime stringToDateTime(String pDate, String pTime) {
    DateTime? dtResult = DateTime.tryParse(pDate + " " + pTime);

    if (dtResult == null) {
      dtResult = new DateTime(1900);
    }

    return dtResult;
  }

  /// Преобразовать значения флага из SAP в логическую переменную
  static bool stringToBool(String pX) {
    return pX == "X";
  }

  /// Собрать из нескольких частей полный регистрационный номер РК
  static String regNumToString(String pPreCode, String pNum, String pCode) {
    String sRegnum = "";

    if (pNum.isNotEmpty) {
      sRegnum = int.parse(pNum).toString();

      if (sRegnum == "0") {
        sRegnum = "";
      } else {
        if (pPreCode.isNotEmpty) {
          sRegnum = pPreCode + "-" + sRegnum;
        }

        if (pCode.isNotEmpty) {
          sRegnum = sRegnum + "/" + pCode;
        }
      }
    }

    return sRegnum;
  }
}
