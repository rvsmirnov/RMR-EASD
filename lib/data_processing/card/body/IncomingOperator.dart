import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/CardKey.dart';
import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:MWPX/data_structure/card/body/incoming/IncomingCard.dart';

/// Работа с РК чтением и записью в БД РК Входящих
abstract class IncomingOperator {
  ///Получить из БД содержимое РК Входящего
  static Future<IncomingCard> getIncomingCard(CardKey pCarKey) async {
    IncomingCard card = new IncomingCard();

    return card;
  }

  static Future<void> insert(IncomingCard pCard) async {
    ///Вставим заголовок
    await DB.insert('CardHeader', pCard.getHeader());

    //Вставим Атрибуты РК
    await DB.insert(pCard.tableName, pCard);

    //Вставим маршрутную таблицу
    for (var route in pCard.routeTable) {
      await DB.insert(route.tableName, route);
    }

    //Вставим таблицу файлов
    for (var file in pCard.fileTable) {
      await DB.insert(file.tableName, file);
    }

    //Вставим таблицу итераций
    for (var iter in pCard.iterationTable) {
      await DB.insert(iter.tableName, iter);
    }
  }

  static Future<void> delete(IncomingCard pCard) async {
    //Очистим таблицу итераций
    for (var iter in pCard.iterationTable) {
      await DB.delete(iter.tableName, iter.getWhereExp(), iter.getWhereKey());
    }

    //Очистим таблицу файлов
    for (var file in pCard.fileTable) {
      await DB.delete(file.tableName, file.getWhereExp(), file.getWhereKey());
    }

    //Очистим маршрутную таблицу
    for (var route in pCard.routeTable) {
      await DB.delete(
          route.tableName, route.getWhereExp(), route.getWhereKey());
    }

    //Очистим Атрибуты РК
    await DB.delete(pCard.tableName, pCard.getWhereExp(), pCard.getWhereKey());

    ///Очистим заголовок
    CardHeader header = pCard;
    await DB.delete('CardHeader', header.getWhereExp(), header.getWhereKey());
  }
}
