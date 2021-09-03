import 'package:MWPX/data_structure/CardKey.dart';

///Ключ поля РК, содержащего длинный текст
class LongTextKey extends CardKey {
  //Название поля
  String fieldName = "";

  ///Конструктор, заполнение полей класса
  LongTextKey(String pDokar, String pDoknr, String pDokvr, String pDoktl,
      String pFieldNamed) {
    dokar = pDokar;
    doknr = pDoknr;
    dokvr = pDokvr;
    doktl = pDoktl;
    fieldName = pFieldNamed;
  }

  @override
  toString() {
    return "$dokar$doknr$dokvr$doktl$fieldName";
  }
}
