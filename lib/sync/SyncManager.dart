import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_processing/card/body/BTripOperator.dart';
import 'package:MWPX/data_processing/card/body/IncomingOperator.dart';
import 'package:MWPX/data_processing/card/body/InstructionOperator.dart';
import 'package:MWPX/data_processing/card/body/ORDOperator.dart';
import 'package:MWPX/data_processing/card/body/OutgoingOperator.dart';
import 'package:MWPX/data_processing/card/body/VacationOperator.dart';
import 'package:MWPX/data_processing/card/list/CardListOperator.dart';
import 'package:MWPX/data_processing/dictionary/DeliveryListOperator.dart';
import 'package:MWPX/data_processing/dictionary/DocumentTypeOperator.dart';
import 'package:MWPX/data_processing/dictionary/PersonDepartmentOperator.dart';
import 'package:MWPX/data_processing/dictionary/TextTemplateOperator.dart';
import 'package:MWPX/data_processing/folder/FolderOperator.dart';
import 'package:MWPX/data_structure/card/body/btrip/BTripCard.dart';
import 'package:MWPX/data_structure/card/body/incoming/IncomingCard.dart';
import 'package:MWPX/data_structure/card/body/instruction/InstructionCard.dart';
import 'package:MWPX/data_structure/card/body/ord/ORDCard.dart';
import 'package:MWPX/data_structure/card/body/outgoing/OutgoingCard.dart';
import 'package:MWPX/data_structure/card/body/vacation/VacationCard.dart';
import 'package:MWPX/data_structure/card/list/CardListItemSync.dart';
import 'package:MWPX/data_structure/folder/FolderItem.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/export/CommonExporter.dart';
import 'package:MWPX/sync/export/card/body/BTripExporter.dart';
import 'package:MWPX/sync/export/card/body/CommonCardExporter.dart';
import 'package:MWPX/sync/export/card/body/IncomingExporter.dart';
import 'package:MWPX/sync/export/card/body/InstructionExporter.dart';
import 'package:MWPX/sync/export/card/body/ORDExporter.dart';
import 'package:MWPX/sync/export/card/body/OutgoingExporter.dart';
import 'package:MWPX/sync/export/card/body/VacationExporter.dart';
import 'package:MWPX/sync/export/card/list/CardListExporter.dart';
import 'package:MWPX/sync/export/card/list/CardListIterator.dart';
import 'package:MWPX/sync/export/dictionary/DeliveryListExporter.dart';
import 'package:MWPX/sync/export/dictionary/DocumentTypeExporter.dart';
import 'package:MWPX/sync/export/dictionary/PersonDepartmentExporter.dart';
import 'package:MWPX/sync/export/dictionary/TextTemplateExporter.dart';
import 'package:MWPX/sync/export/folder/FolderExporter.dart';

/// Класс для осуществления синхронизации РМР и ЕАСД
class SyncManager {
  ///Список настроек синхронизируемых систем
  List<ConnectionConfig> syncSystemList = [];

  //Количество настроенных систем для синхронизации
  int get syncSystemCount {
    return syncSystemList.length;
  }

  /// Имя "домашней" системы ЕАСД.
  String get nativeSystemName {
    for (var sys in syncSystemList) {
      if (sys.isSystemNative) {
        return sys.systemName;
      }
    }
    return "";
  }

  ///Конструктор, инициализация
  SyncManager() {}

  ///Синхронизировать данные с ЕАСД
  Future<void> SyncData() async {
    List<String> folderListForExport = [];
    List<FolderItem> localFolderList = [];

    ConnectionConfig cconf = new ConnectionConfig();
    cconf.userLogin = "AVERINAA";
    cconf.userPassword = "123123";

    //Сформируем список существующих папок
    localFolderList = await FolderOperator.getFolderList(null);

    print("Sync Start!");

    //Синхронизируем папки из ЕАСД
    await exportFolders(
        cconf, true, true, localFolderList, folderListForExport);

    //Синхронищируем НСИ
    await exportDictionaries(cconf);

    //Синхронизируем разные настройки и полезные данне
    await exportServiceData(cconf);

    //Получим список РК для закачки из ЕАСД
    List<CardListItemSync> cardsForProcessing = await exportCardList(cconf);

    //Подготовим список РК
    CardListIterator cardIterator = new CardListIterator(cardsForProcessing, 5);

    while (cardIterator.GetNextBatch()) {
      if (cardIterator.currentCardType == "BTR") {
        BTripExporter btrExp = new BTripExporter();

        btrExp.setLoadList(cardIterator.currentCardListForProcessing);

        btrExp.setParameters();

        await btrExp.doExport(cconf);

        //btrExp.setDocumentTypeText(await DocumentTypeOperator.getDictData());

        for (var c2f in cardIterator.currentCardListForProcessing) {
          var convertedCard = btrExp.convertedCardList.firstWhere(
              (element) => element.doknr == c2f.doknr,
              orElse: () => new BTripCard());

          if (convertedCard.doknr.isNotEmpty) {
            await CardListOperator.insertCardToFolder(c2f, convertedCard);
            await BTripOperator.insert(convertedCard);
          }
        }
      }

      if (cardIterator.currentCardType == "LVE") {
        VacationExporter vacExp = new VacationExporter();

        vacExp.setLoadList(cardIterator.currentCardListForProcessing);

        vacExp.setParameters();

        await vacExp.doExport(cconf);

        //btrExp.setDocumentTypeText(await DocumentTypeOperator.getDictData());

        for (var c2f in cardIterator.currentCardListForProcessing) {
          var convertedCard = vacExp.convertedCardList.firstWhere(
              (element) => element.doknr == c2f.doknr,
              orElse: () => new VacationCard());

          if (convertedCard.doknr.isNotEmpty) {
            await CardListOperator.insertCardToFolder(c2f, convertedCard);
            await VacationOperator.insert(convertedCard);
          }
        }
      }

      if (cardIterator.currentCardType == "VHD") {
        IncomingExporter incExp = new IncomingExporter();

        incExp.setLoadList(cardIterator.currentCardListForProcessing);

        incExp.setParameters();

        await incExp.doExport(cconf);

        for (var c2f in cardIterator.currentCardListForProcessing) {
          var convertedCard = incExp.convertedCardList.firstWhere(
              (element) => element.doknr == c2f.doknr,
              orElse: () => new IncomingCard());

          if (convertedCard.doknr.isNotEmpty) {
            await CardListOperator.insertCardToFolder(c2f, convertedCard);
            await IncomingOperator.insert(convertedCard);
          }
        }
      }

      if (cardIterator.currentCardType == "ДКИ") {
        InstructionExporter ordExp = new InstructionExporter();

        ordExp.setLoadList(cardIterator.currentCardListForProcessing);

        ordExp.setParameters();

        await ordExp.doExport(cconf);

        for (var c2f in cardIterator.currentCardListForProcessing) {
          var convertedCard = ordExp.convertedCardList.firstWhere(
              (element) => element.doknr == c2f.doknr,
              orElse: () => new InstructionCard());

          if (convertedCard.doknr.isNotEmpty) {
            await CardListOperator.insertCardToFolder(c2f, convertedCard);
            await InstructionOperator.insert(convertedCard);
          }
        }
      }

      if (cardIterator.currentCardType == "ORD") {
        ORDExporter ordExp = new ORDExporter();

        ordExp.setLoadList(cardIterator.currentCardListForProcessing);

        ordExp.setParameters();

        await ordExp.doExport(cconf);

        for (var c2f in cardIterator.currentCardListForProcessing) {
          var convertedCard = ordExp.convertedCardList.firstWhere(
              (element) => element.doknr == c2f.doknr,
              orElse: () => new ORDCard());

          if (convertedCard.doknr.isNotEmpty) {
            await CardListOperator.insertCardToFolder(c2f, convertedCard);
            await ORDOperator.insert(convertedCard);
          }
        }
      }

      if (cardIterator.currentCardType == "ISD") {
        OutgoingExporter ordExp = new OutgoingExporter();

        ordExp.setLoadList(cardIterator.currentCardListForProcessing);

        ordExp.setParameters();

        await ordExp.doExport(cconf);

        for (var c2f in cardIterator.currentCardListForProcessing) {
          var convertedCard = ordExp.convertedCardList.firstWhere(
              (element) => element.doknr == c2f.doknr,
              orElse: () => new OutgoingCard());

          if (convertedCard.doknr.isNotEmpty) {
            await CardListOperator.insertCardToFolder(c2f, convertedCard);
            await OutgoingOperator.insert(convertedCard);
          }
        }
      }

      //print(cardIter.currentCardType + "  " + cardIter.currentDoknrList);
    }

    print("Sync Complete!");

    print("===FolderList===");
    var fld = await FolderOperator.getFolderList(null);
    for (var f in fld) print(f.toString());

    // print("===DocumentTypeList===");
    // var dt = await DocumentTypeOperator.getDictData();
    // for (var d in dt) print(d.toString());

    // print("===TextTemplateList===");
    // var tt = await TextTemplateOperator.getDictData();
    // for (var t in tt) print(t.toString());

    // print("===PersonDepartmentList===");
    // var pd = await PersonDepartmentOperator.getDictData();
    // for (var p in pd) print(p.toString());

    // print("===DeliveryList===");
    // var dlh = await DeliveryListOperator.getHeaderList();
    // for (var dh in dlh) {
    //   print("Header - " + dh.toString());
    //   var dlm = await DeliveryListOperator.getMemeberList(dh.sCode);
    //   for (var dm in dlm) print(dm.toString());
    // }

    print("===CardList===");
    var btrList = await CardListOperator.getBTripSignList();
    for (var crd in btrList) {
      print(crd.toString());
    }

    var vacList = await CardListOperator.getVacationSignList();
    for (var crd in vacList) {
      print(crd.toString());
    }

    var decList = await CardListOperator.getDecisionList();
    for (var crd in decList) {
      print(crd.toString());
    }

    var apprList = await CardListOperator.getApproveList();
    for (var crd in apprList) {
      print(crd.toString());
    }

    var signList = await CardListOperator.getSignList();
    for (var crd in signList) {
      print(crd.toString());
    }

    var execList = await CardListOperator.getExecutionList();
    for (var crd in execList) {
      print(crd.toString());
    }

    print("======END OF SYNC LOG===========================");
  }

  ///Синхронизировать список папок с ЕАСД
  Future<void> exportFolders(
      ConnectionConfig pConConf,
      bool pSyncCards,
      bool pSyncReports,
      List<FolderItem> pLocalFolderList,
      List<String> pFolderListForExport) async {
    //Создадим класс экспорта
    FolderExporter fexp = new FolderExporter();

    fexp.setParameters(pConConf.userLogin, pLocalFolderList);

    await fexp.doExport(pConConf);
  }

  /// Получить из ЕАСД содержимое справочников
  Future<void> exportDictionaries(ConnectionConfig pConConf) async {
    //Получим списки  документов
    DocumentTypeExporter dtexp = new DocumentTypeExporter();
    dtexp.setParameters();
    await dtexp.doExport(pConConf);

    //Получим типовые тексты
    TextTemplateExporter ttexp = new TextTemplateExporter();
    ttexp.setParameters();
    await ttexp.doExport(pConConf);

    //Получим сотрудников и подразделения
    PersonDepartmentExporter pdexp = new PersonDepartmentExporter();
    pdexp.setParameters();
    await pdexp.doExport(pConConf);

    //Получим списки рассылки
    DeliveryListExporter dlexp = new DeliveryListExporter();
    dlexp.setParameters();
    await dlexp.doExport(pConConf);
  }

  /// Получить из ЕАСД содержимое справочников
  Future<void> exportServiceData(ConnectionConfig pConConf) async {
    //Получим отпечаток для ЭП

    //Получим информацию о текущем пользователе

    //Получим настройки применения ЭП
  }

  /// Список РК для получения из ЕАСД(удаления в РМР)
  Future<List<CardListItemSync>> exportCardList(
      ConnectionConfig pConConf) async {
    CardListExporter clexp = new CardListExporter();

    //Сделаем список синхронизизруемых папок
    var folderList = await FolderOperator.getFolderList(null);

    //Сделаем список локальных РК для сравнения с таким же списком из ЕАСД
    var localCardList = await CardListOperator.getCardListForSync();

    //Установим параметры для поиса дельты
    clexp.setParameters(pConConf.userLogin, folderList, localCardList);

    //Получим данные из ЕАСД
    await clexp.doExport(pConConf);

    return clexp.cardListForExport;
  }
}
