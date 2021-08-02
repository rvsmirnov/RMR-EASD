import 'dart:io';
import 'package:MWPX/data_processing/folder/FolderOperator.dart';
import 'package:MWPX/data_structure/TableRow.dart';
import 'package:MWPX/data_structure/folder/FolderItem.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DB {
  static late Database _db;

  static int get _version => 1;

  static String _dbName = "mwpxdb";

  static Future<void> init() async {
    try {
      Directory? _dbDirectory = await getApplicationDocumentsDirectory();

      String _dbFullFileName = join(_dbDirectory.path, _dbName);

      if (await File(_dbFullFileName).exists()) {
        await deleteDatabase(_dbFullFileName);
      }

      _db = await openDatabase(_dbFullFileName,
          version: _version, onCreate: onCreate);

      //print(_db.isOpen ? "DB is Open" : " DB closed");
      //await fillInitialFolders();
      //var _folderList = await selectTable(FolderTableRow.table);
      //print("Folders selected: ${_folderList.length}");
    } catch (ex) {
      print(ex);
    }
  }

  ///Действия, поизводимые при создании локальной БД
  ///Создаем таблицы
  static void onCreate(Database db, int version) async {
    //Создаем таблицу папок
    await db.execute('CREATE TABLE Folder ('
        '  folderCode TEXT NOT NULL'
        ', folderName TEXT NULL'
        ', recNr INTEGER NULL'
        ', folderType TEXT NULL'
        ', parentCode TEXT NULL'
        ', PRIMARY KEY (folderCode)'
        ') WITHOUT ROWID');

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
        ', content TEXT NULL'
        ', documentType STRING NULL'
        ', cardUrgent BOOLEAN NULL'
        ', PRIMARY KEY (logsys, dokar, doknr, dokvr, doktl)'
        ') WITHOUT ROWID');

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
  }

  /// Получить содержимое всей таблицы из БД
  static Future<List<Map<String, dynamic>>> selectTable(String pTable) async =>
      _db.query(pTable);

  /// Получить выборку данных из БД по запросу
  static Future<List<Map<String, dynamic>>> rawSelect(
          String pQueryText) async =>
      _db.rawQuery(pQueryText);

  /// Вставить запись в таблицу БД
  static Future<int> insert(String table, TableRow tableRow) async =>
      await _db.insert(table, tableRow.toMap());

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
}
