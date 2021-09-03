import 'package:MWPX/data_structure/card/list/CardListItemSync.dart';
import 'package:MWPX/data_structure/folder/FolderItem.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/export/CommonExporter.dart';
import 'package:xml/xml.dart' as xml;

///Класс для получения списокв РК для загрузки из ЕАСД
class CardListExporter extends CommonExporter {
  /// Список РК из локальной БД
  List<CardListItemSync> _localCardList = [];

  /// Список РК из ЕАСД
  List<CardListItemSync> _easdCardList = [];

  /// Список РК которые надо получить из ЕАСД
  List<CardListItemSync> _cardListForExport = [];

  List<CardListItemSync> get cardListForExport {
    return _cardListForExport;
  }

  //Конструктор
  CardListExporter();

  ///Установка параметров экспорта папок
  void setParameters(String pUserName, List<FolderItem> pSyncFolderList,
      List<CardListItemSync> pLocalCardList) {
    String envHeader =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:ZAWPWS03_EX_CARDLIST>
      <IT_FOLDERS>''';

    String envFolders = '';

    for (var fld in pSyncFolderList) {
      envFolders += '''<item>
               <CODE>${fld.folderCode}</CODE>               
            </item>''';
    }
    String envFooter = '''</IT_FOLDERS>
         <I_HIER_TYPE>0</I_HIER_TYPE>
         <I_USERNAME>${pUserName.toUpperCase()}</I_USERNAME>
      </urn:ZAWPWS03_EX_CARDLIST>
   </soapenv:Body>
</soapenv:Envelope>''';

    envelop = envHeader + envFolders + envFooter;

    _localCardList = pLocalCardList;
  }

  @override
  Future<void> doExport(ConnectionConfig pConConf) async {
    await getRemoteResponse(
        pConConf.fullEasdURL, pConConf.encodedLoginPassword, envelop);

    //Получим список РК и дат актуальности
    xml.XmlElement cardData =
        super.parsedXml.findAllElements('ET_CARD_LIST').single;

    Map<String, String> cardActualDateList = {};
    for (var crd in cardData.children) {
      String cardKey = getItemValueByName(crd, "LOGSYS") +
          getItemValueByName(crd, "DOKAR") +
          getItemValueByName(crd, "DOKNR") +
          getItemValueByName(crd, "DOKVR") +
          getItemValueByName(crd, "DOKTL");

      String cardDT = getItemValueByName(crd, "CHANGED_ON") +
          " " +
          getItemValueByName(crd, "CHANGED_TM");

      if (cardDT.startsWith("1900"))
        cardDT = getItemValueByName(crd, "CREATED_ON") +
            " " +
            getItemValueByName(crd, "CREATED_TM");

      cardActualDateList[cardKey] = cardDT;
    }

    //Получим список привязок РК к папкам
    xml.XmlElement cardToFolderData =
        super.parsedXml.findAllElements('ET_CARD_TO_FOLDER').single;

    //Соберем список РК из ЕАСД с датами актуальности и привязками к папкам
    for (var c2f in cardToFolderData.children) {
      CardListItemSync syncCard = new CardListItemSync();
      syncCard.logsys = getItemValueByName(c2f, "LOGSYS");
      syncCard.dokar = getItemValueByName(c2f, "DOKAR");
      syncCard.doknr = getItemValueByName(c2f, "DOKNR");
      syncCard.dokvr = getItemValueByName(c2f, "DOKVR");
      syncCard.doktl = getItemValueByName(c2f, "DOKTL");
      syncCard.folderCode = getItemValueByName(c2f, "FOLDER_CODE");
      syncCard.wfItem = getItemValueByName(c2f, "WFITEM");

      String cardKey = syncCard.logsys +
          syncCard.dokar +
          syncCard.doknr +
          syncCard.dokvr +
          syncCard.doktl;

      syncCard.lastChangeDT = cardActualDateList[cardKey]!;

      _easdCardList.add(syncCard);
      //print(syncCard.toString());
    }

    //Сравним списки РК и найдем дельту для закачки

    for (CardListItemSync local_card in _localCardList) {
      //Найдем локальную  РК в списке пришедших
      CardListItemSync easdCard = _easdCardList.firstWhere(
          (element) => (element.logsys == local_card.logsys &&
              element.doknr == local_card.doknr &&
              element.wfItem == local_card.wfItem &&
              element.folderCode == local_card.folderCode),
          orElse: () => new CardListItemSync());

      //Если РК нет - значит из локальной БД её надо удалить
      if (easdCard.logsys.isEmpty) {
        local_card.syncAction = "D";
        _cardListForExport.add(local_card);
      } else {
        //Если РК есть - сравниваем дальше
        if (easdCard.lastChangeDT != local_card.lastChangeDT) {
          local_card.syncAction = "U";
          _cardListForExport.add(local_card);
        }
        // Удалим РК из списка ЕАСД, так как уже её обработали
        _easdCardList.remove(easdCard);
      }
    }

    // В списке РК из ЕАСД остались только те,
    // которых нет в списке локальных РК - добавим их как закачиваемые
    for (CardListItemSync easdCard in _easdCardList) {
      easdCard.syncAction = "I";
      _cardListForExport.add(easdCard);
    }
  }
}
