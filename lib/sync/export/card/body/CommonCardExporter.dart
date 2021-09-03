import 'package:MWPX/data_structure/CardKey.dart';
import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:MWPX/data_structure/card/body/FileTableItem.dart';
import 'package:MWPX/data_structure/card/body/IterationTableItem.dart';
import 'package:MWPX/data_structure/card/body/RouteTableItem.dart';
import 'package:MWPX/data_structure/card/list/CardListItemSync.dart';
import 'package:MWPX/data_structure/dictionary/DocumentTypeItem.dart';
import 'package:MWPX/sync/SapTypeHelper.dart';
import 'package:MWPX/sync/export/CommonExporter.dart';
import 'package:xml/xml.dart';

///Класс для получения атрибутов РК
class CommonCardExporter extends CommonExporter {
  ///Список РК для получения из ЕАСД, который будем передавать при вызове сервиса
  String loadListXML = "";

  /// Заполнение списка РК, которые будут загружены из ЕАСД
  void setLoadList(List<CardListItemSync> pLoadList) {
    for (CardListItemSync card in pLoadList) {
      loadListXML += '''<item>
               <LOGSYS>${card.logsys}</LOGSYS>
               <DOKAR>${card.dokar}</DOKAR>
               <DOKNR>${card.doknr}</DOKNR>
               <DOKVR>${card.dokvr}</DOKVR>
               <DOKTL>${card.doktl}</DOKTL>
            </item>''';
    }
  }

  /// Установка текстового значения типа документа в коде
  // void setDocumentTypeText(List<DocumentTypeItem> pDocTypeList) {
  //   for (CardHeader card in convertedCardList) {
  //     if (card.dokar == "ДКИ") {
  //       card.documentTypeText = "Поручение";
  //     } else {
  //       DocumentTypeItem docType = pDocTypeList.firstWhere(
  //           (element) =>
  //               element.logSys == card.logsys &&
  //               element.sCode == card.documentType,
  //           orElse: () => new DocumentTypeItem());

  //       if (docType.sCode.isNotEmpty) {
  //         card.documentTypeText = docType.value;
  //       }
  //     }
  //   }
  // }

  ///Конвертация маршрутной таблицы РК
  List<RouteTableItem> convertRouteTable(CardKey pCardKey,
      XmlElement pXmlRouteTable, XmlElement pXmlRouteNoteTable) {
    List<RouteTableItem> routeTable = [];

    for (var xmlRoute in pXmlRouteTable.children) {
      if (getItemValueByName(xmlRoute, "DOKNR") == pCardKey.doknr) {
        RouteTableItem cardRoute = new RouteTableItem();

        cardRoute.logsys = pCardKey.logsys;
        cardRoute.dokar = pCardKey.dokar;
        cardRoute.doknr = pCardKey.doknr;
        cardRoute.dokvr = pCardKey.dokvr;
        cardRoute.doktl = pCardKey.doktl;
        cardRoute.recNr = getItemValueByName(xmlRoute, "APRNR");

        cardRoute.procDT = SapTypeHelper.stringToDateTime(
            getItemValueByName(xmlRoute, "PROC_DATE"),
            getItemValueByName(xmlRoute, "PROC_TIME"));

        cardRoute.aprNameText = getItemValueByName(xmlRoute, "APRNAME_FULL");
        cardRoute.aprPodrText = getItemValueByName(xmlRoute, "APRPODR_TEXT");
        cardRoute.aprStatus = getItemValueByName(xmlRoute, "APRST");

        cardRoute.noteDT = SapTypeHelper.stringToDateTime(
            getItemValueByName(xmlRoute, "NOTE_DATE"),
            getItemValueByName(xmlRoute, "NOTE_TIME"));

        cardRoute.execNameText = getItemValueByName(xmlRoute, "ISPNAME_FULL");
        cardRoute.execPodrText = getItemValueByName(xmlRoute, "ISPPODR_TEXT");
        cardRoute.aprRole = getItemValueByName(xmlRoute, "APRROLE");
        cardRoute.wfItem = getItemValueByName(xmlRoute, "WI_ID");

        cardRoute.rcvdDT = SapTypeHelper.stringToDateTime(
            getItemValueByName(xmlRoute, "RCVD_ON"),
            getItemValueByName(xmlRoute, "RCVD_TM"));

        cardRoute.aprSubst = getItemValueByName(xmlRoute, "APRSUBST");

        String sRouteNote = "";
        for (var xmlNote in pXmlRouteNoteTable.children) {
          if (getItemValueByName(xmlNote, "DOKAR") == cardRoute.doknr &&
              getItemValueByName(xmlNote, "APRNR") == cardRoute.recNr) {
            sRouteNote += getItemValueByName(xmlNote, "LINETX");
          }
        }

        cardRoute.routeNote = sRouteNote;

        routeTable.add(cardRoute);
      }
    }

    return routeTable;
  }

  ///Конвертация таблицы файлов, прикрепелнных к РК
  List<FileTableItem> convertFileTable(CardKey pCardKey,
      XmlElement pXmlFileTable, XmlElement pXmlFileSignerTable) {
    List<FileTableItem> fileTable = [];

    for (var xmlFile in pXmlFileTable.children) {
      String sCurrObjkey = getItemValueByName(xmlFile, "OBJKEY");

      if (sCurrObjkey.length != 33) continue;

      if (sCurrObjkey.substring(3, 28) == pCardKey.doknr) {
        FileTableItem cardFile = new FileTableItem();

        cardFile.logsys = pCardKey.logsys;
        cardFile.dokar = pCardKey.dokar;
        cardFile.doknr = pCardKey.doknr;
        cardFile.dokvr = pCardKey.dokvr;
        cardFile.doktl = pCardKey.doktl;

        cardFile.recExtId = getItemValueByName(xmlFile, "REC_EXT_ID");
        cardFile.version = getItemValueByName(xmlFile, "VERSION");

        cardFile.recType = getItemValueByName(xmlFile, "REC_TYPE");
        cardFile.description = getItemValueByName(xmlFile, "DESCRIPTION");
        cardFile.dappl = getItemValueByName(xmlFile, "DAPPL");
        cardFile.createdBy = getItemValueByName(xmlFile, "CREATED_BY");
        cardFile.createdDT = SapTypeHelper.stringToDateTime(
            getItemValueByName(xmlFile, "CREATE_DATE"),
            getItemValueByName(xmlFile, "CREATE_TIME"));

        cardFile.fileNr = int.parse(getItemValueByName(
            xmlFile, "FILENR")); // сохраняем порядковый номер файла
        if (cardFile.fileNr <= 0)
          cardFile.fileNr = 1000; // файлы без приоритета - в конец списка

        cardFile.fileFormat = getItemValueByName(xmlFile, "FILE_FORMAT");
        cardFile.srcLogSys = getItemValueByName(xmlFile, "SRC_LOGSYS");
        cardFile.srcRecExtId = getItemValueByName(xmlFile, "SRC_REC_EXT_ID");
        cardFile.srcVersion = getItemValueByName(xmlFile, "SRC_VERSION");
        cardFile.createMode = getItemValueByName(xmlFile, "CREATE_MODE");

        if (getItemValueByName(xmlFile, "STAMP_FLAG") == "X") {
          if (getItemValueByName(xmlFile, "STAMP_SIGNED") == "X") {
            cardFile.stampHeader = "Электронная подпись. ";
          }

          cardFile.stampRegNum = getItemValueByName(xmlFile, "STAMP_REGNUM");

          for (var signer in pXmlFileSignerTable.children) {
            if (getItemValueByName(signer, "REC_EXT_ID") == cardFile.recExtId &&
                getItemValueByName(signer, "VERSION") == cardFile.version) {
              cardFile.stampSignerList +=
                  getItemValueByName(xmlFile, "SIGNER_TEXT")
                          .replaceFirst("Подписал:", "") +
                      "<sep>";
            }
          }

          if (cardFile.stampSignerList.length > 0) {
            cardFile.stampSignerList = "Подписал: " + cardFile.stampSignerList;
          }
        }

        // Не вставлять одинаковые!!!
        if (!fileTable.any((element) =>
            element.logsys == cardFile.logsys &&
            element.doknr == cardFile.doknr &&
            element.recExtId == cardFile.recExtId)) {
          fileTable.add(cardFile);
        }
      }
    }

    return fileTable;
  }

  ///Конвертация таблицы итераций Рук-Пом для РК
  List<IterationTableItem> convertIterationTable(CardKey pCardKey,
      XmlElement pXmlIterationTable, XmlElement pXmlIterationNoteTable) {
    List<IterationTableItem> iterationTable = [];

    IterationTableItem cardIteration;

    for (var xmlIter in pXmlIterationTable.children) {
      if (getItemValueByName(xmlIter, "DOKNR") == pCardKey.doknr) {
        cardIteration = new IterationTableItem();

        cardIteration.logsys = pCardKey.logsys;
        cardIteration.dokar = pCardKey.dokar;
        cardIteration.doknr = pCardKey.doknr;
        cardIteration.dokvr = pCardKey.dokvr;
        cardIteration.doktl = pCardKey.doktl;
        cardIteration.iterNr = int.parse(getItemValueByName(xmlIter, "MSTI"));
        cardIteration.createdDT = SapTypeHelper.stringToDateTime(
            getItemValueByName(xmlIter, "CREATED_ON"),
            getItemValueByName(xmlIter, "CREATED_TM"));
        cardIteration.authorName =
            getItemValueByName(xmlIter, "CREATED_BY_FIO");
        cardIteration.iterType = "";

        String sRouteNote = "";
        for (var xmlIterNote in pXmlIterationNoteTable.children) {
          if (getItemValueByName(xmlIterNote, "DOKNR") == cardIteration.doknr &&
              int.parse(getItemValueByName(xmlIterNote, "MSTI")) ==
                  cardIteration.iterNr) {
            sRouteNote +=
                getItemValueByName(xmlIterNote, "TDLINE").trim() + "\r\n";
          }
        }

        if (sRouteNote.isEmpty) {
          cardIteration.noteText = ""; //"Заметка отсутствует";
        } else {
          cardIteration.noteText = sRouteNote;
        }

        iterationTable.add(cardIteration);
      }
    }

    //Добавим текущую итерацию, чтобы к ней клеить новые звуковые заметки
    cardIteration = new IterationTableItem();
    cardIteration.logsys = pCardKey.logsys;
    cardIteration.dokar = pCardKey.dokar;
    cardIteration.doknr = pCardKey.doknr;
    cardIteration.dokvr = pCardKey.dokvr;
    cardIteration.doktl = pCardKey.doktl;
    cardIteration.iterNr = -1;
    cardIteration.createdDT = DateTime.now();
    cardIteration.authorName = "Я";
    cardIteration.iterType = "";
    cardIteration.noteText = "";

    iterationTable.add(cardIteration);

    return iterationTable;
  }
}
