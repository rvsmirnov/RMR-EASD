import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/CardKey.dart';
import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:MWPX/data_structure/card/body/btrip/BTripCard.dart';

/// Работа с РК чтением и записью в БД РК Командировок
abstract class BTripOperator {
  ///Получить из БД содержимое РК Командировки
  static Future<BTripCard> getBTripCard(CardKey pCarKey) async {
    BTripCard card = new BTripCard();

    return card;
  }

  static Future<void> insert(BTripCard pCard) async {
    ///Вставим заголовок
    await DB.insert('CardHeader', pCard.getHeader());

    //Вставим Атрибуты РК
    await DB.insert(pCard.tableName, pCard);

    //Вставим таблицу делегации
    for (var dele in pCard.delegationTable) {
      await DB.insert(dele.tableName, dele);
    }

    //Вставим маршрутную таблицу
    for (var route in pCard.routeTable) {
      await DB.insert(route.tableName, route);
    }

    //Вставим таблицу итераций
    for (var iter in pCard.iterationTable) {
      await DB.insert(iter.tableName, iter);
    }
  }

  /// Удалить РК Командировки из БД
  static Future<void> delete(BTripCard pCard) async {
    //Очистим таблицу итераций
    for (var iter in pCard.iterationTable) {
      await DB.delete(iter.tableName, iter.getWhereExp(), iter.getWhereKey());
    }

    //Очистим маршрутную таблицу
    for (var route in pCard.routeTable) {
      await DB.delete(
          route.tableName, route.getWhereExp(), route.getWhereKey());
    }

    //Очистим таблицу делегации
    for (var dele in pCard.delegationTable) {
      await DB.delete(dele.tableName, dele.getWhereExp(), dele.getWhereKey());
    }

    //Очистим Атрибуты РК
    await DB.delete(pCard.tableName, pCard.getWhereExp(), pCard.getWhereKey());

    ///Очистим заголовок
    await DB.delete('CardHeader', pCard.getHeader().getWhereExp(),
        pCard.getHeader().getWhereKey());
  }
}
