import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/CardListKey.dart';
import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:MWPX/data_structure/card/body/RouteTableItem.dart';
import 'package:MWPX/data_structure/card/list/AcquaintanceListItem.dart';
import 'package:MWPX/data_structure/card/list/ApproveListItem.dart';
import 'package:MWPX/data_structure/card/list/BTripSignListItem.dart';
import 'package:MWPX/data_structure/card/list/CardListItem.dart';
import 'package:MWPX/data_structure/card/list/CardListItemSync.dart';
import 'package:MWPX/data_structure/card/list/ControlListItem.dart';
import 'package:MWPX/data_structure/card/list/DecisionListItem.dart';
import 'package:MWPX/data_structure/card/list/ExecutionListItem.dart';
import 'package:MWPX/data_structure/card/list/ForMeetingListItem.dart';
import 'package:MWPX/data_structure/card/list/SignListItem.dart';
import 'package:MWPX/data_structure/card/list/VacationSignListItem.dart';

/// Класс для работы со списками РК в папках
abstract class CardListOperator {
  /// Добавить РК в список папки
  static Future<void> insertCardToFolder(
      CardListItemSync pListItem, CardHeader pCard) async {
    CardListItem cli = new CardListItem();
    //CardKey
    cli.logsys = pCard.logsys;
    cli.dokar = pCard.dokar;
    cli.doknr = pCard.doknr;
    cli.dokvr = pCard.dokvr;
    cli.doktl = pCard.doktl;
    //CardListKey
    cli.folderCode = pListItem.folderCode;
    cli.wfItem = pListItem.wfItem;
    //CardListItem
    cli.cardProcessed = 0;
    cli.cardOpened = 0;
    cli.regNUM = pCard.regNum;
    cli.regDATE = pCard.regDate;

    for (RouteTableItem rti in pCard.routeTable) {
      if (rti.wfItem == pListItem.wfItem) {
        cli.rcvdDT = rti.rcvdDT;
      }
    }

    await DB.insert("CardToFolder", cli);
  }

  ///Обновить привязку РК в папке
  static Future<void> updateCardInFolder(CardListItem pItem) async {
    await DB.update(
        pItem.tableName,
        pItem,
        "folderCode=? and logsys=?, dokar=?, doknr=?, dokvr=?, doktl=?, wfitem=?",
        [
          pItem.folderCode,
          pItem.logsys,
          pItem.dokar,
          pItem.doknr,
          pItem.dokvr,
          pItem.doktl
        ]);
  }

  /// Удалить РК из папки
  static Future<void> removeCardFromFolder(CardListKey pItem) async {
    DB.delete(
        pItem.tableName,
        "folderCode=? and logsys=?, dokar=?, doknr=?, dokvr=?, doktl=?, wfitem=?",
        [
          pItem.folderCode,
          pItem.logsys,
          pItem.dokar,
          pItem.doknr,
          pItem.dokvr,
          pItem.doktl
        ]);
  }

  ///Установить для РК статус Новая/Открытая. 0 - новая, 1 - открытая
  static Future<void> setCardOpenedStatus(CardListKey pKey) async {
    await DB.rawUpdate(
        "UPDATE CardToFolder set cardOpened=1"
        " where folderCode=? and wfitem=? "
        " and logsys=? and dokar=? and doknr=? and dokvr=? and doktl=?",
        [
          pKey.folderCode,
          pKey.wfItem,
          pKey.logsys,
          pKey.dokar,
          pKey.doknr,
          pKey.dokvr,
          pKey.doktl
        ]);
  }

  /// Установить для РК статус "Обработана"
  static Future<void> setCardProcessedStatus(CardListKey pKey) async {
    await DB.rawUpdate(
        "UPDATE CardToFolder set cardProcessed=1"
        " where folderCode=? and wfitem=? "
        " and logsys=? and dokar=? and doknr=? and dokvr=? and doktl=?",
        [
          pKey.folderCode,
          pKey.wfItem,
          pKey.logsys,
          pKey.dokar,
          pKey.doknr,
          pKey.dokvr,
          pKey.doktl
        ]);
  }

  /// Получить полный список РК для синхронизации
  static Future<List<CardListItemSync>> getCardListForSync() async {
    List<CardListItemSync> result = [];

    var cardList = await DB.rawSelect("select * from CardToFolder");

    for (var card in cardList) {
      CardListItemSync clis = new CardListItemSync();
      clis.logsys = card['logsys'];
      clis.dokar = card['dokar'];
      clis.doknr = card['doknr'];
      clis.dokvr = card['dokvr'];
      clis.doktl = card['doktl'];
      result.add(clis);
    }
    return result;
  }

  /// Получить список Командировок на подписание (папка Командировки)
  static Future<List<BTripSignListItem>> getBTripSignList() async {
    List<BTripSignListItem> result = [];
    String sSql = """select  c2f.DOKAR, 
		                            c2f.DOKNR,
		                            c2f.DOKVR,
		                            c2f.DOKTL,
                                c2f.WFITEM as wfItem,		
		                            btr.countryText,
		                            btr.ncity,
		                            btr.begDT,
                                btr.calenddays,
                                c2f.logsys,
                                c2f.cardOpened,
                                c2f.folderCODE,
                                c2f.rcvdDT,
                                c2f.cardProcessed, crd.createdDT, crd.changedDT,
                                btr.globflag,
                                btr.endDT
                            from BTrip as btr,
	                             CardHeader as crd,
	                             CardToFolder as c2f
                            where c2f.DOKAR = crd.DOKAR
                              and c2f.DOKNR = crd.DOKNR
                              and c2f.DOKVR = crd.DOKVR
                              and c2f.DOKTL = crd.DOKTL  
                              and crd.DOKAR = btr.DOKAR  
                              and crd.DOKNR = btr.DOKNR  
                              and crd.DOKVR = btr.DOKVR  
                              and crd.DOKTL = btr.DOKTL 
                              and c2f.LOGSYS = crd.LOGSYS
                              and crd.LOGSYS = btr.LOGSYS
                              and c2f.cardProcessed = 0  
                              and c2f.folderCode = '00001'
                              order by begDT asc""";

    var queryResult = await DB.rawSelect(sSql);

    for (var row in queryResult) {
      BTripSignListItem btr = new BTripSignListItem();
      btr.fromMap(row);
      result.add(btr);
    }

    return result;
  }

  /// Получить список Отпусков на подписание (папка Отпуска)
  static Future<List<VacationSignListItem>> getVacationSignList() async {
    List<VacationSignListItem> result = [];

    String sSql = """select c2f.DOKAR, 
                            c2f.DOKNR,
                            c2f.DOKVR,
                            c2f.DOKTL,
                            c2f.WFITEM as wfItem,		
                            vac.emplName,
                            vac.begDT,
                            vac.endDT,
                            vac.calenddays,
                            c2f.LOGSYS,
                            c2f.cardOpened,
                            c2f.folderCODE,
                            c2f.rcvdDT,
                            c2f.cardProcessed,
                            vac.emplDepartment,
                            vac.emplPosition, crd.createdDT, crd.changedDT
                        from Vacation as vac,
                              CardHeader as crd,
                              CardToFolder as c2f
                        where c2f.DOKAR = crd.DOKAR
                            and c2f.DOKNR = crd.DOKNR
                            and c2f.DOKVR = crd.DOKVR
                            and c2f.DOKTL = crd.DOKTL  
                            and crd.DOKAR = vac.DOKAR  
                            and crd.DOKNR = vac.DOKNR  
                            and crd.DOKVR = vac.DOKVR  
                            and crd.DOKTL = vac.DOKTL 
                            and c2f.LOGSYS = crd.LOGSYS
                            and crd.LOGSYS = vac.LOGSYS
                            and c2f.cardProcessed = 0  
                            and c2f.folderCode = '00002' 
                            order by vac.begDT asc""";

    var queryResult = await DB.rawSelect(sSql);

    for (var row in queryResult) {
      VacationSignListItem vac = new VacationSignListItem();
      vac.fromMap(row);
      result.add(vac);
    }

    return result;
  }

  /// Получить список Входящих для папки На решение
  static Future<List<DecisionListItem>> getDecisionList() async {
    List<DecisionListItem> result = [];

    String sSql = """select c2f.DOKAR, 
		                            c2f.DOKNR,
		                            c2f.DOKVR,
		                            c2f.DOKTL,
                                    c2f.WFITEM as wfItem,
                                    crd.regNum,
                                    crd.regDate,
                                    crd.content,
                                    inc.mainAuthor,
                                    c2f.rcvdDT,
                                    c2f.LOGSYS,
                                    c2f.cardOpened,
                                    c2f.folderCode,
                                    c2f.cardProcessed,
                                    crd.cardUrgent, crd.createdDT, crd.changedDT, crd.syncFileCount
                            from Incoming as inc,     
	                             CardHeader as crd,
	                             CardToFolder as c2f
                            where c2f.DOKAR = crd.DOKAR
                              and c2f.DOKNR = crd.DOKNR
                              and c2f.DOKVR = crd.DOKVR
                              and c2f.DOKTL = crd.DOKTL  
                              and crd.DOKAR = inc.DOKAR  
                              and crd.DOKNR = inc.DOKNR  
                              and crd.DOKVR = inc.DOKVR  
                              and crd.DOKTL = inc.DOKTL
                              and c2f.LOGSYS = crd.LOGSYS
                              and crd.LOGSYS = inc.LOGSYS
                              and c2f.cardProcessed = 0
                              and c2f.folderCode = '00003'
                            order by crd.cardUrgent desc, c2f.rcvdDT desc""";

    var queryResult = await DB.rawSelect(sSql);

    for (var row in queryResult) {
      DecisionListItem dec = new DecisionListItem();
      dec.fromMap(row);
      result.add(dec);
    }

    return result;
  }

  /// Получить список ОРД, Исходящих, Командировок, Отпусков для папки На согласование
  static Future<List<ApproveListItem>> getApproveList() async {
    List<ApproveListItem> result = [];

    String sSql = """select c2f.DOKAR, 
		                            c2f.DOKNR,
		                            c2f.DOKVR,
		                            c2f.DOKTL,
                                c2f.WFITEM as wfItem,
                                crd.CONTENT,
                                dt.VALUE as docTypeText,
                                c2f.rcvdDT,
                                c2f.LOGSYS,
                                c2f.cardOpened,
                                c2f.folderCode,
                                c2f.cardProcessed, crd.createdDT, crd.changedDT, crd.syncFileCount
                                from DocumentType as dt,
	                                 CardHeader as crd,
	                                 CardToFolder as c2f
                                where c2f.DOKAR = crd.DOKAR
                                  and c2f.DOKNR = crd.DOKNR
                                  and c2f.DOKVR = crd.DOKVR
                                  and c2f.DOKTL = crd.DOKTL
                                  and crd.documentType = dt.sCode    
                                  and crd.LOGSYS = dt.LOGSYS
                                  and crd.LOGSYS = c2f.LOGSYS                                  
                                  and c2f.cardProcessed = 0
                                  and c2f.folderCode = '00007'                                  
                             order by c2f.rcvdDT desc""";

    var queryResult = await DB.rawSelect(sSql);

    for (var row in queryResult) {
      ApproveListItem appr = new ApproveListItem();
      appr.fromMap(row);
      result.add(appr);
    }

    return result;
  }

  /// Получить список ОРД, Исходящих для папки На подписание
  static Future<List<SignListItem>> getSignList() async {
    List<SignListItem> result = [];

    String sSql = """select c2f.DOKAR, 
		                            c2f.DOKNR,
		                            c2f.DOKVR,
		                            c2f.DOKTL,
                                c2f.WFITEM as wfItem,
                                crd.CONTENT,
                                dt.VALUE as docTypeText,
                                c2f.rcvdDT,
                                c2f.LOGSYS,
                                c2f.cardOpened,
                                c2f.folderCode,
                                c2f.cardProcessed, crd.createdDT, crd.changedDT, crd.syncFileCount,
                                crd.cardUrgent
                                from DocumentType as dt,
	                                 CardHeader as crd,
	                                 CardToFolder as c2f
                                where c2f.DOKAR = crd.DOKAR
                                  and c2f.DOKNR = crd.DOKNR
                                  and c2f.DOKVR = crd.DOKVR
                                  and c2f.DOKTL = crd.DOKTL
                                  and crd.documentType = dt.sCode    
                                  and crd.LOGSYS = dt.LOGSYS
                                  and crd.LOGSYS = c2f.LOGSYS                                  
                                  and c2f.cardProcessed = 0
                                  and c2f.folderCode = '00008'                                  
                             order by c2f.rcvdDT desc""";

    var queryResult = await DB.rawSelect(sSql);

    for (var row in queryResult) {
      SignListItem sign = new SignListItem();
      sign.fromMap(row);
      result.add(sign);
    }

    return result;
  }

  /// Получить список Поручений для папки На исполнение
  static Future<List<ExecutionListItem>> getExecutionList() async {
    List<ExecutionListItem> result = [];
    String sSql = """select c2f.DOKAR, 
		                            c2f.DOKNR,
		                            c2f.DOKVR,
		                            c2f.DOKTL,
                                    c2f.WFITEM as wfItem,
                                    crd.regNum,
                                    crd.regDate,
                                    crd.CONTENT,
                                    ins.ctrlDate,
                                    ins.controllerName,
                                    c2f.rcvdDT,
                                    c2f.LOGSYS,                                                                       
                                    ins.signerName,
                                    ins.punkt,                                    
                                    c2f.cardOpened,
                                    c2f.folderCode,
                                    c2f.cardProcessed, crd.createdDT, crd.changedDT, crd.syncFileCount,
                                    crd.cardUrgent
                            from Instruction as ins,
	                             CardHeader as crd,
	                             CardToFolder as c2f
                            where c2f.DOKAR = crd.DOKAR
                              and c2f.DOKNR = crd.DOKNR
                              and c2f.DOKVR = crd.DOKVR
                              and c2f.DOKTL = crd.DOKTL  
                              and crd.DOKAR = ins.DOKAR  
                              and crd.DOKNR = ins.DOKNR  
                              and crd.DOKVR = ins.DOKVR  
                              and crd.DOKTL = ins.DOKTL
                              and c2f.LOGSYS = crd.LOGSYS
                              and crd.LOGSYS = ins.LOGSYS
                              and c2f.cardProcessed = 0    
                              and c2f.folderCode = '00009'
                            order by crd.cardUrgent desc, c2f.rcvdDT desc""";

    var queryResult = await DB.rawSelect(sSql);

    for (var row in queryResult) {
      ExecutionListItem exec = new ExecutionListItem();
      exec.fromMap(row);
      result.add(exec);
    }
    return result;
  }

  /// Получить список Поручений для папки На контроль
  static Future<List<ControlListItem>> getControlList() async {
    List<ControlListItem> result = [];

    return result;
  }

  /// Получить список Входящих, Исходящих, ОРД, Поручений для папки На ознакомление
  static Future<List<AcquaintanceListItem>> getAcquaintanceList() async {
    List<AcquaintanceListItem> result = [];

    return result;
  }

  /// Получить список Входящих, Исходящих, ОРД, Поручений для папки К совещанию
  static Future<List<ForMeetingListItem>> getForMeetingList() async {
    List<ForMeetingListItem> result = [];

    return result;
  }
}
