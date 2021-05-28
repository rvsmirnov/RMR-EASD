import 'package:MWPX/datastructure/CardKey.dart';

class CardListKey extends CardKey {
  /// Код папки, в которой лежит карточка
  late String folderCode;

  /// Идетификатор ЭПО
  late String wfItem;

  /// Конструктор, инициализация значений
  CardListKey() : super() {
    folderCode = "";
    wfItem = "";
  }
}
