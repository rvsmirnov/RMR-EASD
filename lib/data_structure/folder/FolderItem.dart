/// Класс для загрузки и хранения информации о папке с документами
class FolderItem {
  /// Код папки, её идентификатор
  late String folderCode;

  /// Название папки
  late String folderName;

  /// Порядковый номер папки, по нему надо сортровать при выводе на экран
  late int recnr;

  /// Тип папки.
  /// WFL - Папка с документами, пришедшими по задачам.
  /// REP - Папка с карточками для отчета.
  /// PLN - Просто папка, которая может содержать в себе другие папки.
  late String folderType;

  /// Идентификатор родительской папки.
  /// Родительская папка должа быть типа PLN
  late String parentCode;

  /// Количество всех документов в папке
  late int allCount;

  /// Текстовое поле для вывода количества всех документов в папке
  String get allCountText {
    if (folderCode == "00006" ||
        folderCode == "00011") //Группа отчетов и создание поручений
    {
      return "";
    } else {
      return this.allCount.toString();
    }
  }

  /// Конструктор, инициализация
  FolderItem() {
    folderCode = "";
    folderName = "";
    recnr = 0;
    folderType = "";
    parentCode = "";
    allCount = 0;
  }

  /// Отображение данных класса в текстовом виде
  @override
  String toString() {
    return "[$folderCode][$folderName][$folderType] - $allCount";
  }
}
