import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/CardKey.dart';
import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:MWPX/data_structure/card/body/outgoing/OutgoingCard.dart';

/// Работа с РК чтением и записью в БД РК Исходящего
abstract class OutgoingOperator {
  ///Получить из БД содержимое РК Исходящего
  static Future<OutgoingCard> getBTripCard(CardKey pCarKey) async {
    OutgoingCard card = new OutgoingCard();

    return card;
  }

  static Future<void> insert(OutgoingCard pCard) async {
    ///Вставим заголовок
    await DB.insert('CardHeader', pCard.getHeader());

    //Вставим Атрибуты РК
    await DB.insert(pCard.tableName, pCard);

    //Вставим таблицу адресатов
    for (var addr in pCard.addresseeTable) {
      await DB.insert(addr.tableName, addr);
    }

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

  /// Удалить из БД РК Исходящего
  static Future<void> delete(OutgoingCard pCard) async {
    //Очистим таблицу итераций
    for (var iter in pCard.iterationTable) {
      await DB.delete(iter.tableName, iter.getWhereExp(), iter.getWhereKey());
    }

    //Очистим маршрутную таблицу
    for (var route in pCard.routeTable) {
      await DB.delete(
          route.tableName, route.getWhereExp(), route.getWhereKey());
    }

    //Очистим таблицу файлов
    for (var file in pCard.fileTable) {
      await DB.delete(file.tableName, file.getWhereExp(), file.getWhereKey());
    }

    //Очистим таблицу адресатов
    for (var dele in pCard.addresseeTable) {
      await DB.delete(dele.tableName, dele.getWhereExp(), dele.getWhereKey());
    }

    //Очистим Атрибуты РК
    await DB.delete(pCard.tableName, pCard.getWhereExp(), pCard.getWhereKey());

    ///Очистим заголовок
    await DB.delete('CardHeader', pCard.getHeader().getWhereExp(),
        pCard.getHeader().getWhereKey());
  }
}
