import 'package:MWPX/data_structure/card/list/CardListItemSync.dart';

/// Класс для обработки списка РК для получения из ЕАСД
/// Основная функция - выдавать порции однотипных РК для получения из ЕАСД пакетно
class CardListIterator {
  int _iStart = 0;
  int _iBatchSize = 0;

  /// Внутренний список карточек для получения
  List<CardListItemSync> _CardToFolderList = [];

  /// Внутренний список карточек для удаления
  List<CardListItemSync> _CardToFolderList_Delete = [];

  int get batchSize {
    return _iBatchSize;
  }

  int get processedCount {
    return _iStart;
  }

  /// Количество РК к получению
  int get forInsertUpdateCount {
    return _CardToFolderList.length;
  }

  /// Количество РК к удалению
  int get forDeleteCount {
    return _CardToFolderList_Delete.length;
  }

  // РК, которую надо удалить
  CardListItemSync? currentCardForDeletion;

  // Пачка РК для получения из ЕАСД
  List<CardListItemSync> currentCardListForProcessing = [];
  String currentCardType = "";
  String currentLogSys = "";
  bool cardTypeChanged = false;
  bool logsysChanged = false;
  String currentDoknrList = "";

  /// <summary>
  /// Конструктор, тут сортируем закачиваемый список для более удобного разрезания на пачки и отображения
  /// </summary>
  /// <param name="p_card_list">Список РК, который предстоит прокрутить</param>
  /// <param name="p_batch_size">Размер пачки РК, на которые будем разрезать список</param>
  CardListIterator(List<CardListItemSync> pCardList, int pBatchSize) {
    _CardToFolderList = pCardList
        .where((item) => item.syncAction == "I" || item.syncAction == "U")
        .toList();
    _CardToFolderList_Delete =
        pCardList.where((item) => item.syncAction == "D").toList();

    _CardToFolderList.sort((a, b) => a.compareTo(b));
    //.OrderByDescending(o => o.SYNC_ACTION).ThenBy(o => o.LOGSYS).ThenBy(o => o.FOLDER_CODE).ThenBy(o => o.DOKAR).ThenBy(o => o.DOKNR).ToList();

    _iStart = 0;
    _iBatchSize = pBatchSize; // ApplicationSettings.Instance.ExportBatchSize;
  }

// <summary>
  /// Получить из внутреннего списка очередную пачку РК для закачки на планшет
  /// </summary>
  /// <param name="p_card_list"></param>
  /// <param name="p_card_type"></param>
  /// <param name="p_card_type_changed"></param>
  /// <param name="p_logsys_changed"></param>
  /// <param name="p_curr_doknr_list"></param>
  /// <returns></returns>
  bool GetNextBatch() {
    int c = 0;
    int i;

    cardTypeChanged = false;
    logsysChanged = false;

    currentCardListForProcessing.clear();
    currentDoknrList = "";

    // Если уже перебрали весь список - просто выходим
    if (_iStart == _CardToFolderList.length) {
      return false;
    }

    // Переберем карточки для загрузки
    for (i = _iStart; i < _CardToFolderList.length; i++) {
      currentCardListForProcessing.add(_CardToFolderList[i]);
      currentDoknrList += _CardToFolderList[i].doknr + ", ";

      c++;

      if (c >= _iBatchSize ||
          i + 1 == _CardToFolderList.length ||
          _CardToFolderList[i].logsys != _CardToFolderList[i + 1].logsys ||
          _CardToFolderList[i].dokar != _CardToFolderList[i + 1].dokar ||
          _CardToFolderList[i].syncAction !=
              _CardToFolderList[i + 1].syncAction ||
          _CardToFolderList[i].folderCode !=
              _CardToFolderList[i + 1].folderCode) {
        if (currentCardType != currentCardListForProcessing[0].dokar) {
          cardTypeChanged = true;
        }

        if (currentLogSys != currentCardListForProcessing[0].logsys) {
          logsysChanged = true;
        }

        currentCardType = currentCardListForProcessing[0].dokar;
        currentLogSys = currentCardListForProcessing[0].logsys;

        break;
      }
    }

    _iStart = i + 1;

    if (currentDoknrList.endsWith(", ") && currentDoknrList.length > 2) {
      currentDoknrList =
          currentDoknrList.substring(0, currentDoknrList.length - 2);
    }

    return true;
  }

  /// Получить ссылку на РК для удаления из локальной БД в процессе синхронизации
  bool getNextCardForDelete() {
    if (_CardToFolderList_Delete.length > 0) {
      currentCardForDeletion = _CardToFolderList_Delete[0];
      _CardToFolderList_Delete.removeAt(0);
      return true;
    } else {
      return false;
    }
  }
}
