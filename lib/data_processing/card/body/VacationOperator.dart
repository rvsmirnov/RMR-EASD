import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/CardKey.dart';
import 'package:MWPX/data_structure/card/body/CardHeader.dart';
import 'package:MWPX/data_structure/card/body/vacation/VacationCard.dart';

/// Работа с РК чтением и записью в БД РК Входящих
abstract class VacationOperator {
  ///Получить из БД содержимое РК Входящего
  static Future<VacationCard> getVacationCard(CardKey pCarKey) async {
    VacationCard card = new VacationCard();

    return card;
  }

  static Future<void> insert(VacationCard pCard) async {
    ///Вставим заголовок
    await DB.insert('CardHeader', pCard.getHeader());

    //Вставим Атрибуты РК
    await DB.insert(pCard.tableName, pCard);

    //Вставим маршрутную таблицу
    for (var route in pCard.routeTable) {
      DB.insert(route.tableName, route);
    }

    //Вставим таблицу итераций
    for (var iter in pCard.iterationTable) {
      DB.insert(iter.tableName, iter);
    }
  }

  static Future<void> delete(VacationCard pCard) async {
    //Очистим таблицу итераций
    for (var iter in pCard.iterationTable) {
      DB.delete(iter.tableName, iter.getWhereExp(), iter.getWhereKey());
    }

    //Очистим маршрутную таблицу
    for (var route in pCard.routeTable) {
      DB.delete(route.tableName, route.getWhereExp(), route.getWhereKey());
    }

    //Очистим Атрибуты РК
    DB.delete(pCard.tableName, pCard.getWhereExp(), pCard.getWhereKey());

    ///Очистим заголовок
    CardHeader header = pCard;
    DB.delete('CardHeader', header.getWhereExp(), header.getWhereKey());
  }
}
