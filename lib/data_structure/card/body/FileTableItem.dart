import 'CardItemKey.dart';

/// Строка таблицы файлов
class FileTableItem extends CardItemKey {
  /// Идентификатор файла
  /// Для новых файлов, прикрепленных в РМР - формируем из Guid, убирая знаки "-"
  late String recExtId;

  /// Версия файла
  /// В ЕАСД, как правило - 01
  /// Для новых файлов, прикрепленных в РМР - 00
  late String version;

  /// Тип привязки файла - Оригинал(RM) или Ссылка(F_LINK)
  late String recType;

  /// <summary>
  /// Описание файла, как правило - имя без расширения
  /// </summary>
  late String description;

  /// Расширение файла, храним его без точки!!!
  late String dappl;

  /// Логин создателя файла
  late String createdBy;

  /// Дата создания файла
  late DateTime createdDT;

  /// Логин изменившего файл
  late String changedBy;

  /// Дата изменения файла
  late DateTime changedDT;

  /// Пометка файла(галочка на форме)
  /// Используется в интерфейсе приложения для выделения файлов для действий над ними (подписание итд)
  /// Это поле так же сохраняется в БД
  late bool isSelected;

  /// Видимость флажка для выделения этого файла
  late bool checkVisible;

  /// Идентификатор подписи - псевдо или ЭП
  late String signId;

  /// Заголовок штампа, если файл продписан ЭП
  late String stampHeader;

  /// Рег.номер для штампа, если файл продписан ЭП
  late String stampRegNum;

  /// Список подписавших для штампа, если файл продписан ЭП
  late String stampSignerList;

  /// Номер файла - отдельное сортировочное поле для сортировки файлов во взаимодействии Руководитель-Помощник.
  late int fileNr;

  /// Открывался ли файл
  late int opensCount;

  /// Байтовый массив, с котором хранятся графические заметки к документу
  //byte[] inkStrokeContent;

  /// Формат прикрепленного файла
  late String fileFormat;

  /// Логическая система файла-родителя (источника сконвертированной копии)
  late String srcLogSys;

  /// Идентификатор файла-родителя (источника сконвертированной копии)
  late String srcRecExtId;

  /// Версия файла-родителя (источника сконвертированной копии)
  late String srcVersion;

  /// Способ создания файла.
  /// Значения:
  ///     <пусто>  	Не задан
  ///     001	        Конвертация в PDF/A-1
  late String createMode;

  /// ???
  late bool skipForSign;

  /// Доступность кнопки "Удалить"
  bool get isDeleteEnable {
    return recExtId.startsWith("AWP");
  }

  /// <summary>
  /// Доступность кнопки "Создать версию"
  /// </summary>
  bool get isVersionEnable {
    return (dappl.toUpperCase().contains("DOC") ||
        dappl.toUpperCase().contains("XLS"));
  }

  /// Описаниеи файла с расширением
  String get descriptionFilename {
    if (description.toUpperCase().endsWith("." + dappl.toUpperCase())) {
      return description;
    } else {
      return description + "." + dappl;
    }
  }

  String get descriptionShort {
    if (description.length > 25) {
      return "${description.substring(0, 25)}...";
    } else {
      return description;
    }
  }

  bool get isStampVisible {
    return (stampHeader.isNotEmpty ||
        stampRegNum.isNotEmpty ||
        stampSignerList.isNotEmpty);
  }

  String get stampSignerListText {
    String sResult = stampSignerList;

    if (sResult.length > 0) {
      if (sResult.endsWith("<sep>")) {
        sResult = sResult.substring(0, sResult.length - 5);
      }

      sResult = sResult.replaceAll("<sep>", ", ");

      sResult = "$stampHeader $sResult".trim();
    }

    return sResult;
  }

  /// <summary>
  /// Конструктор, инициализация значений
  /// </summary>
  FileTableItem() : super() {
    recExtId = "";
    version = "";
    recType = "";
    description = "";
    dappl = "";
    createdBy = "";
    createdDT = emptyDate;
    changedBy = "";
    changedDT = emptyDate;
    isSelected = false;
    signId = "";
    stampHeader = "";
    stampRegNum = "";
    stampSignerList = "";
    fileNr = 0;
    opensCount = 0;

    checkVisible = false;

    srcLogSys = "";
    srcRecExtId = "";
    srcVersion = "";
    fileFormat = "";
    createMode = "";

    skipForSign = false;

    //InkStrokeContent = null;
  }

  /// <summary>
  /// Отображение данных класса в текстовом виде
  /// </summary>
  /// <returns>Возвращает значение полей ключа РК, ключа файла, название и ид. подписи в виде строки</returns>
  @override
  String toString() {
    return super.toString() + "[$recExtId][$version][$description $signId]";
  }
}
