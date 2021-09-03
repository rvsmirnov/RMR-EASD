import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/CardKey.dart';
import 'package:MWPX/data_structure/card/body/instruction/InstructionCard.dart';

/// Работа с РК чтением и записью в БД РК Поручения
abstract class InstructionOperator {
  ///Получить из БД содержимое РК Исходящего
  static Future<InstructionCard> getBTripCard(CardKey pCarKey) async {
    InstructionCard card = new InstructionCard();

    return card;
  }

  static Future<void> insert(InstructionCard pCard) async {
    ///Вставим заголовок
    await DB.insert('CardHeader', pCard.getHeader());

    //Вставим Атрибуты РК
    await DB.insert(pCard.tableName, pCard);

    //Вставим таблицу адресатов
    for (var exec in pCard.executorTable) {
      await DB.insert(exec.tableName, exec);
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

  /// Удалить из БД РК Поручения
  static Future<void> delete(InstructionCard pCard) async {
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

    //Очистим таблицу исполнителей
    for (var dele in pCard.executorTable) {
      await DB.delete(dele.tableName, dele.getWhereExp(), dele.getWhereKey());
    }

    //Очистим Атрибуты РК
    await DB.delete(pCard.tableName, pCard.getWhereExp(), pCard.getWhereKey());

    ///Очистим заголовок
    await DB.delete('CardHeader', pCard.getHeader().getWhereExp(),
        pCard.getHeader().getWhereKey());
  }
}
