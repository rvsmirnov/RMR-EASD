import 'package:MWPX/data_structure/folder/FolderItem.dart';

/// Данные папки с меткой синхронизации
/// Используется для поиска дельты при получении данных из ЕАСД
class FolderItemSync extends FolderItem {
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
