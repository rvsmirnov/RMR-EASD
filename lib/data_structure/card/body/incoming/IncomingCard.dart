import 'package:MWPX/data_structure/card/body/CardHeader.dart';

/// Атрибуты РК Входящего
class IncomingCard extends CardHeader {
  /// Основной автор РК Исходящего
  late String mainAuthor;

  /// Подразделение основного автора РК Исходящего
  late String mainAuthorOrg;

  /// Признак "Важное"
  late bool chbV;

  /// полная информация об основном авторе входящего
  String get mainAuthorFull {
    String sAuthorFull = "";

    if (mainAuthor.isNotEmpty && mainAuthorOrg.isNotEmpty) {
      sAuthorFull = "$mainAuthor / $mainAuthorOrg";
    } else if (mainAuthor.isNotEmpty && mainAuthorOrg.isEmpty) {
      sAuthorFull = mainAuthor;
    } else if (mainAuthor.isEmpty && mainAuthorOrg.isNotEmpty) {
      sAuthorFull = mainAuthorOrg;
    } else {
      sAuthorFull = " не указан.";
    }

    return "Автор: $sAuthorFull";
  }

  /// Конструктор, инициализация значений
  IncomingCard() : super() {
    mainAuthor = "";
    mainAuthorOrg = "";
    chbV = false;
  }

  /// Текстовое представление РК Входящего
  @override
  String toString() {
    return "Входящий${chbV ? '(Важный)' : ''} $regNum от ${dateFormat.format(regDate)} ${super.toString()}";
  }
}
