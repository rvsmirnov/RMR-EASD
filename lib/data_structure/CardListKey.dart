import 'package:MWPX/data_structure/CardKey.dart';

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

  @override
  fromMap(Map<String, dynamic> pMap) {
    folderCode = pMap['folderCode'];
    wfItem = pMap['wfItem'];
    super.fromMap(pMap);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'folderCode': folderCode, 'wfItem': wfItem};

    map.addAll(super.toMap());

    return map;
  }

  @override
  String toString() {
    return super.toString() + " Folder=$folderCode WFItem=$wfItem";
  }
}
