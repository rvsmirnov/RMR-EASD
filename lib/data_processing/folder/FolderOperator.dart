import 'package:MWPX/data_processing/DB.dart';

import 'package:MWPX/data_structure/folder/FolderItem.dart';

///Класс для работы с данными папок, в которых лежат документы
abstract class FolderOperator {
  ///Получить список папок с количеством документов в них.
  ///Нужно указать родительскую папку для получения списка.
  static Future<List<FolderItem>> getFolderList(String pParentCode) async {
    List<FolderItem> result = [];

    var folderList = await DB.rawSelect(
        "SELECT folderCode, folderName, recNr, folderType, parentCode from Folder where parentCode = '$pParentCode'");

    for (var fold in folderList) {
      FolderItem fi = new FolderItem();
      fi.fromMap(fold);
      fi.allCount = await selectFolderCount(fi.folderCode);
      result.add(fi);
    }
    return result;
  }

  /// Получить количество РК в заданной папке
  static Future<int> selectFolderCount(String pFolderCode) async {
    int iResult = 0;

    if (pFolderCode.isEmpty) {
      iResult = 0;
    } else {
      String sSql;

      sSql = "select count(*) as cnt"
          " from CardToFolder as c2f, "
          " CardHeader as crd "
          " where crd.DOKAR = c2f.DOKAR "
          " and crd.DOKNR = c2f.DOKNR "
          " and crd.DOKVR = c2f.DOKVR "
          " and crd.DOKTL = c2f.DOKTL "
          " and c2f.folderCode = '$pFolderCode' and cardProcessed = 0";

      // try
      // {
      var folderCounter = await DB.rawSelect(sSql);

      iResult = folderCounter[0]["cnt"];
    }

    return iResult;

    // }
    // catch (Exception ex)
    // {
    //     return 0;
    // }
  }

  /// Добавить в БД папку
  static Future<void> insertFolder(FolderItem pFolderItem) async {
    await DB.insert(pFolderItem.tableName, pFolderItem);
  }

  /// Изменить в БД информацию о папке
  static Future<void> updateFolder(FolderItem pFolderItem) async {
    DB.update(pFolderItem.tableName, pFolderItem, 'folderCode=?',
        [pFolderItem.folderCode]);
  }

  ///Удалить папку из БД
  static Future<void> deleteFolder(FolderItem pFolderItem) async {
    DB.delete(pFolderItem.tableName, 'folderCode=?', [pFolderItem.folderCode]);
  }

  /// Заполнить данными БД после создания (потом убрать, для тестирования)
  static Future<void> fillInitialFolders() async {
    FolderItem fi;

    fi = new FolderItem();
    fi.folderCode = "00001";
    fi.folderName = "Командировки";
    fi.recNr = 1;
    fi.folderType = "WFL";
    fi.parentCode = "";
    await insertFolder(fi);

    fi = new FolderItem();
    fi.folderCode = "00002";
    fi.folderName = "Отпуска";
    fi.recNr = 2;
    fi.folderType = "WFL";
    fi.parentCode = "";
    await insertFolder(fi);

    fi = new FolderItem();
    fi.folderCode = "00003";
    fi.folderName = "На решение";
    fi.recNr = 3;
    fi.folderType = "WFL";
    fi.parentCode = "";
    await insertFolder(fi);

    fi = new FolderItem();
    fi.folderCode = "00004";
    fi.folderName = "Отчеты";
    fi.recNr = 3;
    fi.folderType = "PLN";
    fi.parentCode = "";
    await insertFolder(fi);

    fi = new FolderItem();
    fi.folderCode = "00005";
    fi.folderName = "На исполнении";
    fi.recNr = 3;
    fi.folderType = "REP";
    fi.parentCode = "00004";
    await insertFolder(fi);

    fi = new FolderItem();
    fi.folderCode = "00006";
    fi.folderName = "Исполненные";
    fi.recNr = 3;
    fi.folderType = "REP";
    fi.parentCode = "00004";
    await insertFolder(fi);

    fi = new FolderItem();
    fi.folderCode = "00014";
    fi.folderName = "У меня на исполнении";
    fi.recNr = 3;
    fi.folderType = "REP";
    fi.parentCode = "00004";
    await insertFolder(fi);

    fi = new FolderItem();
    fi.folderCode = "00007";
    fi.folderName = "На согласование";
    fi.recNr = 3;
    fi.folderType = "WFL";
    fi.parentCode = "";
    await insertFolder(fi);

    fi = new FolderItem();
    fi.folderCode = "00008";
    fi.folderName = "На подписание";
    fi.recNr = 3;
    fi.folderType = "WFL";
    fi.parentCode = "";
    await insertFolder(fi);
  }
}
