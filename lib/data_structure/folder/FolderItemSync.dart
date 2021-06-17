/// Данные папки с меткой синхронизации
/// Используется для поиска дельты при получении данных из ЕАСД
class FolderItemSync {
  /// Флаг синхронизщированности папки
  late String syncAction;

  /// Конструктор
  FolderItemSync() : super() {
    syncAction = "";
  }

  /// <summary>
  /// Текстовое представление данных экземпляра класса
  /// </summary>
  /// <returns></returns>
  @override
  String toString() {
    return "[${super.toString()}][$syncAction]";
  }
}
