import 'dart:io';
import 'package:MWPX/data_structure/TableRow.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DB {
  static late Database _db;

  static int get _version => 1;

  static String _dbName = "mwpxdb";

  static Future<void> init() async {
    try {
      Directory? _dbDirectory = await getExternalStorageDirectory();

      String _dbFullFileName = join(_dbDirectory!.path, _dbName);

      if (await File(_dbFullFileName).exists()) {
        await deleteDatabase(_dbFullFileName);
      }

      _db = await openDatabase(_dbFullFileName,
          version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  ///Действия, поизводимые при создании локальной БД
  ///Создаем таблицы
  static void onCreate(Database db, int version) async {
    /////////////////////////////////////////////////////////////////////
    /// Хранение Папок
    /////////////////////////////////////////////////////////////////////

    //Создаем таблицу папок
    await db.execute('CREATE TABLE Folder ('
        '  folderCode TEXT NOT NULL'
        ', folderName TEXT NULL'
        ', recNr INTEGER NULL'
        ', folderType TEXT NULL'
        ', parentCode TEXT NULL'
        ', PRIMARY KEY (folderCode)'
        ') WITHOUT ROWID');

    /////////////////////////////////////////////////////////////////////
    /// Хранение списков РК
    /////////////////////////////////////////////////////////////////////

    //Создаем таблицу привязок РК к папкам
    await db.execute('CREATE TABLE CardToFolder ('
        '  folderCode TEXT NOT NULL'
        ', logsys TEXT NOT NULL'
        ', dokar TEXT NOT NULL'
        ', doknr TEXT NOT NULL'
        ', dokvr TEXT NOT NULL'
        ', doktl TEXT NOT NULL'
        ', wfitem TEXT NOT NULL'
        ', cardOpened BOOLEAN NULL'
        ', cardProcessed BOOLEAN NULL'
        ', rcvdDT DateTime NULL'
        ', PRIMARY KEY (folderCode, logsys, dokar, doknr, dokvr, doktl, wfitem)'
        ') WITHOUT ROWID');

    //Создаем таблицу заголовков РК
    await db.execute('CREATE TABLE CardHeader ('
        '  logsys TEXT NOT NULL'
        ', dokar TEXT NOT NULL'
        ', doknr TEXT NOT NULL'
        ', dokvr TEXT NOT NULL'
        ', doktl TEXT NOT NULL'
        ', doknrTRUNC TEXT NOT NULL'
        ', createdBy TEXT NULL'
        ', createdDT DateTime NULL'
        ', changedBy TEXT NULL'
        ', changedDT DateTime NULL'
        ', content TEXT NULL'
        ', regNum  TEXT NULL'
        ', regDate DateTime NULL'
        ', documentType STRING NULL'
        ', cardUrgent BOOLEAN NULL'
        ', rcvdDT DateTime NULL'
        ', forMeeting BOOLEAN NULL'
        ', syncFileCount int NULL'
        ', PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl)'
        ') WITHOUT ROWID');

    /////////////////////////////////////////////////////////////////////
    /// Хранение Атрибутов РК
    /////////////////////////////////////////////////////////////////////

    //РК Командировки
    await db.execute('''CREATE TABLE BTrip (
    logsys TEXT NOT NULL
  , dokar TEXT NOT NULL
  , doknr TEXT  NOT NULL
  , dokvr TEXT  NOT NULL
  , doktl TEXT  NOT NULL
  , intnl int NULL
  , countryText TEXT NULL
  , ncity TEXT NULL
  , begDT datetime NULL
  , endDT datetime NULL
  , calendDays int NULL
  , transp TEXT NULL
  , globflag int NULL
  , plpunkt TEXT NULL
  , planFlag int NULL
  , resText TEXT NULL
  , goalText TEXT NULL
  , addInfText TEXT NULL
  , signerName TEXT NULL
  , signerDepartment TEXT NULL
  , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl)
) WITHOUT ROWID''');

    await db.execute('''CREATE TABLE BTrip_Delegation (
    logsys TEXT NOT NULL
  , dokar TEXT NOT NULL
  , doknr TEXT  NOT NULL
  , dokvr TEXT  NOT NULL
  , doktl TEXT  NOT NULL
  , recnr TEXT NOT NULL
  , begDT datetime NULL
  , endDT datetime NULL
  , calendDays int NULL
  , transp TEXT NULL
  , nameText TEXT NULL
  , positionText TEXT NULL
  , departmentText TEXT NULL
  , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl, recnr)
  ) WITHOUT ROWID''');

    //РК Отпуска
    await db.execute('''CREATE TABLE Vacation (
    logsys TEXT NOT NULL
  , dokar TEXT NOT NULL
  , doknr TEXT  NOT NULL
  , dokvr TEXT  NOT NULL
  , doktl TEXT  NOT NULL
  , begDT datetime NULL
  , endDT datetime NULL
  , calenddays int NULL
  , intnl TEXT NULL
  , location TEXT NULL
  , unpaid int NULL
  , emplName TEXT NULL
  , substName TEXT NULL
  , resText TEXT NULL
  , addInfText TEXT NULL
  , emplDepartment TEXT NULL
  , emplPosition TEXT NULL
  , signerName TEXT NULL
  , signerDepartment TEXT NULL
  , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl)
  ) WITHOUT ROWID''');

    //РК Входящих
    await db.execute('CREATE TABLE Incoming ('
        '  logsys TEXT NOT NULL'
        ', dokar TEXT NOT NULL'
        ', doknr TEXT  NOT NULL'
        ', dokvr TEXT  NOT NULL'
        ', doktl TEXT  NOT NULL'
        ', mainAuthor TEXT NULL'
        ', mainAuthorOrg TEXT NULL'
        ', PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl)'
        ') WITHOUT ROWID');

    //РК Исходящего
    await db.execute('''CREATE TABLE Outgoing (
        logsys TEXT NOT NULL
        , dokar TEXT NOT NULL
        , doknr TEXT  NOT NULL
        , dokvr TEXT  NOT NULL
        , doktl TEXT  NOT NULL
        , executorName TEXT NULL
        , executorDepartment TEXT NULL
        , signerName TEXT NULL
        , comment TEXT NULL
        , pdfaConvFlag int NULL
        , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl)
        ) WITHOUT ROWID''');

    await db.execute('''CREATE TABLE Outg_Addressee (
        logsys TEXT NOT NULL
        , dokar TEXT NOT NULL
        , doknr TEXT  NOT NULL
        , dokvr TEXT  NOT NULL
        , doktl TEXT  NOT NULL
        , recnr TEXT NOT NULL
        , addresseeName TEXT NULL
        , addresseeDepartment TEXT NULL
        , addresseePosition TEXT NULL
        , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl, recnr)
        ) WITHOUT ROWID''');

    //РК Поручения

    await db.execute('''CREATE TABLE Instruction (
        logsys TEXT NOT NULL
        , dokar TEXT NOT NULL
        , doknr TEXT  NOT NULL
        , dokvr TEXT  NOT NULL
        , doktl TEXT  NOT NULL
        , initiatorName TEXT NULL
        , signerName TEXT NULL
        , controllerName TEXT NULL
        , ctrlType TEXT NULL
        , urgency TEXT NULL
        , chkConf int NULL
        , ctrlDate datetime NULL
        , factExecDate datetime NULL
        , executionText TEXT NULL
        , statusProcText TEXT NULL
        , punkt TEXT NULL
        , newExecDate datetime NULL
        , controllerCode TEXT NULL
        , signerCode TEXT NULL
        , reportText TEXT NULL
        , requestText TEXT NULL
        , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl)
        ) WITHOUT ROWID''');

    await db.execute('''CREATE TABLE Ins_Executor (
        logsys TEXT NOT NULL
        , dokar TEXT NOT NULL
        , doknr TEXT  NOT NULL
        , dokvr TEXT  NOT NULL
        , doktl TEXT  NOT NULL
        , recNr TEXT NOT NULL
        , executorName TEXT NULL
        , executorDepartment TEXT NULL
        , respExec int NULL
        , executorCode TEXT NULL
        , executorDepartmentCode TEXT NULL
        , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl, recNr)
        ) WITHOUT ROWID''');

    //РК ОРД

    await db.execute('''CREATE TABLE ORD (
        logsys TEXT NOT NULL
        , dokar TEXT NOT NULL
        , doknr TEXT  NOT NULL
        , dokvr TEXT  NOT NULL
        , doktl TEXT  NOT NULL
        , executorName TEXT NULL
        , executorDepartment TEXT NULL
        , signerName TEXT NULL
        , comment TEXT NULL
        , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl)
        ) WITHOUT ROWID''');

    /////////////////////////////////////////////////////////////////////
    /// Хранение Общих таблиц РК
    /////////////////////////////////////////////////////////////////////
    await db.execute('''CREATE TABLE ApproveTable (
    logsys TEXT NOT NULL
  , dokar TEXT NOT NULL
  , doknr TEXT  NOT NULL
  , dokvr TEXT  NOT NULL
  , doktl TEXT  NOT NULL
  , aprnr TEXT NOT NULL  
  , procDT DateTime NULL
  , routeNote TEXT NULL
  , aprNameText TEXT NULL
  , aprPodrText TEXT NULL
  , aprStatus TEXT NULL
  , noteDT DateTime NULL
  , execNameText TEXT NULL
  , execPodrText TEXT NULL
  , aprRole TEXT NULL
  , wfItem TEXT NULL
  , rcvdDT DateTime NULL
  , aprSubst TEXT NULL
  , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl, aprnr)
        ) WITHOUT ROWID''');

    await db.execute('''CREATE TABLE MST_Iteration (
    logsys TEXT NOT NULL
  , dokar TEXT NOT NULL
  , doknr TEXT  NOT NULL
  , dokvr TEXT  NOT NULL
  , doktl TEXT  NOT NULL
  , iterNr INTEGER NOT NULL
  , createdDT DateTime NULL
  , authorName TEXT NULL
  , iterType TEXT NULL
  , noteText TEXT NULL
  , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl, iterNr)
        ) WITHOUT ROWID''');

    await db.execute('''CREATE TABLE MST_VoiceNote (
  logsys TEXT NOT NULL
  , dokar TEXT NOT NULL
  , doknr TEXT  NOT NULL
  , dokvr TEXT  NOT NULL
  , doktl TEXT  NOT NULL
  , iterNr INTEGER NOT NULL
  , recExtId TEXT NOT NULL
  , version TEXT NOT NULL
  , createdDT DateTime NULL
  , isNew boolean NULL
  , noteName TEXT NULL
  , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl, iterNr, recExtId, version)
        ) WITHOUT ROWID''');

    await db.execute('''CREATE TABLE FileRecord (
    logsys TEXT NOT NULL
  , dokar TEXT NOT NULL
  , doknr TEXT  NOT NULL
  , dokvr TEXT  NOT NULL
  , doktl TEXT  NOT NULL
  , recExtId TEXT NOT NULL
  , version TEXT NOT NULL
  , recType TEXT NULL
  , description TEXT NULL
  , dappl TEXT NULL
  , comment TEXT NULL
  , createdBy TEXT NULL
  , createdDT datetime NULL
  , changedBy TEXT NULL
  , changedDT datetime NULL
  , isSelected int NULL
  , opensCount int NULL
  , signId TEXT NULL
  , stampHeader TEXT NULL
  , stampRegNum TEXT NULL
  , stampSignerList TEXT NULL
  , fileNr int NULL
  , inkStrokeContent BLOB NULL
  , fileFormat TEXT NULL
  , srcLogSys TEXT NULL
  , srcRecExtId TEXT NULL
  , srcVersion TEXT NULL
  , createMode TEXT NULL
  , PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl, recExtId, version)
          ) WITHOUT ROWID''');

    /////////////////////////////////////////////////////////////////////
    /// Хранение НСИ
    /////////////////////////////////////////////////////////////////////

    await db.execute('CREATE TABLE DocumentType ('
        '  logsys TEXT NOT NULL'
        ', sCode TEXT NOT NULL'
        ', value TEXT NULL'
        ', PRIMARY KEY (logsys, sCode)'
        ') WITHOUT ROWID');

    await db.execute('''CREATE TABLE TextTemplate (
          logsys TEXT NOT NULL
        , cardType TEXT NOT NULL
        , textType TEXT NOT NULL
        , textValue TEXT NOT NULL
        , PRIMARY KEY (logsys, cardType, textType, textValue)
        ) WITHOUT ROWID''');

    await db.execute('''CREATE TABLE PersonDepartment (
        logsys TEXT NOT NULL
      , personCode TEXT NOT NULL
      , departmentCode TEXT NOT NULL
      , personText TEXT NULL
      , departmentText TEXT NULL
      , positionCode TEXT NULL
      , positionText TEXT NULL
      , PRIMARY KEY (logsys, personCode, departmentCode)
        ) WITHOUT ROWID''');

    await db.execute('''CREATE TABLE DeliveryListHeader (
        logsys TEXT NOT NULL
      , sCode TEXT NOT NULL
      , headerText TEXT NULL
      , PRIMARY KEY (logsys, sCode)
        ) WITHOUT ROWID''');

    await db.execute('''CREATE TABLE DeliveryListMember (
        logsys TEXT NOT NULL
      , listCode TEXT NOT NULL
      , recnr TEXT NOT NULL
      , itemCode TEXT NULL
      , PRIMARY KEY (logsys, listCode, recnr)
      ) WITHOUT ROWID''');

    /////////////////////////////////////////////////////////////////////
    /// Служебные таблицы
    /////////////////////////////////////////////////////////////////////
  }

  /// Получить содержимое всей таблицы из БД
  static Future<List<Map<String, dynamic>>> selectTable(String pTable) async =>
      await _db.query(pTable);

  /// Получить выборку данных из БД по запросу
  static Future<List<Map<String, dynamic>>> rawSelect(
          String pQueryText) async =>
      await _db.rawQuery(pQueryText);

  /// Вставить запись в таблицу БД
  static Future<int> insert(String table, TableRow tableRow) async {
    try {
      return await _db.insert(table, tableRow.toMap());
    } catch (Exception) {
      return -1;
    }
  }

  /// Обновить запись в таблице БД
  static Future<int> update(String table, TableRow tableRow, String whereExp,
      List<Object?> whereExpVal) async {
    return await _db.update(table, tableRow.toMap(),
        where: whereExp, whereArgs: whereExpVal);
  }

  /// Удалить запись из таблицы БД
  static Future<int> delete(
      String table, String whereExp, List<Object?> whereExpVal) async {
    return await _db.delete(table, where: whereExp, whereArgs: whereExpVal);
  }

  static Future<int> rawUpdate(String sUpdSql, List<Object?> updUpdVal) async {
    return await _db.rawUpdate(sUpdSql, updUpdVal);
  }
}
