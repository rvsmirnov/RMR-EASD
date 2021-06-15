import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:MWPX/data_structure/card/body/outgoing/AddresseeTableItem.dart';

/// Атрибуты РК Исходящего
class OutgoingCard extends CardHeader {
  /// ФИО Исполнителя(инициатора)
  late String executorName;

  /// Подразделения Исполнителя(инициатора)
  late String executorOrg;

  /// ФИО Подписывающего
  late String signerName;

  /// Признак, говорящий о том, что для данной РК нужно
  /// конвертировать файлы DOC в PDF-A1 при подписани
  late bool pdfaConvFlag;

  /// Исполнитель(инициатор) для вывода на экран
  String get executorOrgText {
    return "Исполнитель: $executorOrg";
  }

  /// Таблица адресатов исходящего(локальная)
  late List<AddresseeTableItem> _addresseeTable;

  /// Таблица адресатов исходящег
  List<AddresseeTableItem> get addresseeTable {
    return _addresseeTable;
  }

  /// Конструктор, инициализация значений и  внутреннних таблиц
  OutgoingCard() : super() {
    executorName = "";
    executorOrg = "";
    signerName = "";
    pdfaConvFlag = false;
    _addresseeTable = [];
  }

  /// Текстовое представление РК Исходящего
  @override
  String toString() {
    return "${super.toString()} $documentType $executorName";
  }
}
