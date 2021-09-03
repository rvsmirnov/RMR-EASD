import 'package:MWPX/sync/longtext/LongTextKey.dart';
import 'package:xml/xml.dart';

///Класс для обработки длинных текстов, приходящийх из ЕАСД и отправляемых в ЕАСД
class LongTextAssistant {
  /// Внутренний контейнер текстов - словарь, где ключу РК и названию поля соответствует строка текста
  late Map<String, String> textList;

  /// Конструктор, инициализация внутреннего контейнера
  LongTextAssistant() {
    textList = new Map<String, String>();
  }

  /// Получить значение поля по его названию. Нужно для конвертации данных из XML
  String getItemValueByName(XmlNode item, String name) {
    var itemElement = item.getElement(name);
    if (itemElement != null)
      return itemElement.innerText;
    else
      return '';
  }

  /// Преобразование текста из таблицы ЕАСД в данные внутреннего контейнера для последующего доступа
  void importFromSAPTable(XmlElement pTextTable) {
    String sb = "";
    LongTextKey prkey = new LongTextKey("", "", "", "", "");
    LongTextKey key;

    textList.clear();

    for (var data in pTextTable.children) {
      key = new LongTextKey(
          getItemValueByName(data, "DOKAR"),
          getItemValueByName(data, "DOKNR"),
          getItemValueByName(data, "DOKVR"),
          getItemValueByName(data, "DOKTL"),
          getItemValueByName(data, "FIELDNAME"));

      if (key.toString() != prkey.toString()) {
        if (sb.isNotEmpty) {
          if (!textList.containsKey(prkey.toString()))
            textList[prkey.toString()] = sb;
        }

        sb = "";
        prkey = key;
      }
      if (sb.isNotEmpty) {
        sb += " ";
      }

      String tdline = getItemValueByName(data, "TDLINE");
      if ((tdline.startsWith("(")) &&
          (tdline.endsWith("})."))) //вставляем отбой строки до и после
      {
        sb += " ";
        sb += tdline;
        sb += " ";
      } else {
        sb += tdline + " ";
      }
    }

    if (sb.isNotEmpty) {
      if (!textList.containsKey(prkey.toString())) {
        textList[prkey.toString()] = sb;
      }
    }
  }

  /// Получить текстовую строку по ключу РК и названию поля
  String getTextString(String pDokar, String pDoknr, String pDokvr,
      String pDoktl, String pTextName) {
    LongTextKey ltk =
        new LongTextKey(pDokar, pDoknr, pDokvr, pDoktl, pTextName);

    if (textList.containsKey(ltk.toString()))
      return textList[ltk.toString()]!;
    else
      return "";
  }

  /// <summary>
  /// Перевести строку текста в табличный формат длинного текста для отправки в ЕАСД
  /// </summary>
  /// <param name="repo">Репозиторий целевой системы ЕАСД</param>
  /// <param name="p_card_key">Ключ РК</param>
  /// <param name="p_field_name">Название текстового поля в ЕАСД</param>
  /// <param name="p_text">Содержимое длинного текста</param>
  /// <param name="p_text_table">Результат - таблица, в которую будети добавлен длинный текст</param>
  // public void ExportToSAPTable(RfcRepository repo, CardKey p_card_key, string p_field_name, string p_text, ref IRfcTable p_text_table)
  // {

  //     RfcStructureMetadata am = repo.GetStructureMetadata("ZAWPS_LONG_TEXT");

  //     if (!string.IsNullOrEmpty(p_text))
  //     {

  //         string[] s_lines = p_text.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries);
  //         string[] sa;
  //         int i_line_nr = 1;

  //         if (s_lines.Length == 0)
  //         {
  //             IRfcStructure txt = am.CreateStructure();
  //             txt.SetValue("DOKAR", p_card_key.DOKAR);
  //             txt.SetValue("DOKNR", p_card_key.DOKNR);
  //             txt.SetValue("DOKVR", p_card_key.DOKVR);
  //             txt.SetValue("DOKTL", p_card_key.DOKTL);
  //             txt.SetValue("FIELDNAME", p_field_name);
  //             txt.SetValue("LINENR", i_line_nr.ToString());
  //             txt.SetValue("TDLINE", "");
  //             p_text_table.Append(txt);
  //         }
  //         else
  //         {
  //             for (int j = 0; j < s_lines.Length; j++)
  //             {
  //                 sa = SapTypeHelper.SplitString(s_lines[j], 132);
  //                 for (int i = 0; i < sa.GetLength(0); i++)
  //                 {
  //                     IRfcStructure txt = am.CreateStructure();
  //                     txt.SetValue("DOKAR", p_card_key.DOKAR);
  //                     txt.SetValue("DOKNR", p_card_key.DOKNR);
  //                     txt.SetValue("DOKVR", p_card_key.DOKVR);
  //                     txt.SetValue("DOKTL", p_card_key.DOKTL);
  //                     txt.SetValue("FIELDNAME", p_field_name);
  //                     txt.SetValue("LINENR", i_line_nr.ToString());
  //                     txt.SetValue("TDLINE", sa[i]);
  //                     p_text_table.Append(txt);

  //                     i_line_nr++;

  //                 }
  //             }
  //         }
  //     }

  // }

}
