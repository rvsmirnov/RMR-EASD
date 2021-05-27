import 'package:MWPX/datastructure/CardKey.dart';

class CardListKey extends CardKey {
  /// Код папки, в которой лежит карточка
  String folderCode;

  /// Идетификатор ЭПО
  String wfItem;

  /// Конструктор, инициализация значений
  CardListKey() : super() {
    folderCode = "";
    wfItem = "";
  }
}
