import 'package:MWPX/data_structure/CardListKey.dart';

///Класс для хранения элмента списка синхронизируемой дельты РК
class CardListItemSync extends CardListKey
    implements Comparable<CardListItemSync> {
  ///Дата последнего изменения РК
  String lastChangeDT = '';

  /// Действие при синхронизации
  String syncAction = '';

  ///Нужно ли загружать тело РК или достаточно просто в папку привязать.
  bool needToLoadCard = false;

  /// Конструктор
  CardListItemSync() : super();

  @override
  int compareTo(CardListItemSync other) {
    int iResult = this.syncAction.compareTo(other.syncAction);
    if (iResult == 0) {
      iResult = this.logsys.compareTo(other.logsys);
      if (iResult == 0) {
        iResult = this.folderCode.compareTo(other.folderCode);
        if (iResult == 0) {
          iResult = this.dokar.compareTo(other.dokar);
          if (iResult == 0) {
            iResult = this.doknr.compareTo(other.doknr);
          }
        }
      }
    }
    return iResult;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'folderCode': folderCode, 'wfItem': wfItem};

// cardOpened BOOLEAN NULL'
//         ', cardProcessed BOOLEAN NULL'
//         ', rcvdDT DateTime NULL'

    map.addAll(super.toMap());

    return map;
  }

  @override
  String toString() {
    return super.toString() + " ActualDate=" + lastChangeDT;
  }
}
