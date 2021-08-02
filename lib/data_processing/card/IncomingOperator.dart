import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_structure/card/body/incoming/IncomingCard.dart';

/// Работа с РК чтением и записью в БД РК Входящих
abstract class IncomigOperator {
  ///Получить из БД содержимое РК Входящего
  Future<IncomingCard> getIncomingCard() async {
    IncomingCard card = new IncomingCard();

    return card;
  }
}
