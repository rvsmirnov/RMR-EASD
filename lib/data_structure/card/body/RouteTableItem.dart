import 'package:MWPX/data_structure/card/body/CardItemKey.dart';
import 'package:intl/intl.dart';

class RouteTableItem extends CardItemKey {
  DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  /// Дата обработки Маршрута
  late DateTime procDT;

  /// ФИО получателя маршрута
  late String aprNameText;

  /// Подразделение получателя
  late String aprPodrText;

  /// Статус маршрутной строки (N - новое, S - отправлено, W - в работе, P - обработано, R - отклонено)
  late String aprStatus;

  /// Заметка на маршруте, как правило это текст замечаний при отклонении
  late String routeNote;

  /// Дата внесения маршрутной заметки
  late DateTime noteDT;

  /// ФИО реального обработчика маршрута
  late String execNameText;

  /// Подразделение реального обработчика маршрута
  late String execPodrText;

  /// Маршрутная роль (Реашющий, Исполнитель, Контролер и т д)
  late String aprRole;

  /// Идентификатор ЭПО для маршрута
  /// По этому полю ищем дату получения карточки
  late String wfItem;

  /// Дата получения карточки
  /// Нужна для сортировки списка документов и отображения на экране РК
  late DateTime rcvdDT;

  /// Флаг замещения
  /// Нужен для отработки некоторых фильтров в маршрутной таблице
  late String aprSubst;

  String get procDTText {
    if (aprStatus == "P" || aprStatus == "R") {
      return procDT == emptyDate ? "" : dateFormat.format(procDT);
    } else {
      return "";
    }
  }

  /// Дата создания комментария на маршруте
  String get noteDTText {
    return noteDT == emptyDate ? "" : dateFormat.format(noteDT);
  }

  /// Текстовое название статуса маршрутной строки
  String get aprStatusText {
    String sStatus;

    switch (aprStatus) {
      case "P":
        sStatus = "Согласовано без замечаний";
        break;
      case "L":
        sStatus = "Отозвано";
        break;
      case "R":
        sStatus = "Согласовано с замечаниями";
        break;
      case "W":
        sStatus = "На согласовании";
        break;
      case "N":
        sStatus = "Новое";
        break;
      case "S":
        sStatus = "Отправлено";
        break;
      default:
        sStatus = "";
        break;
    }

    return sStatus;
  }

  /// Текстовое название маршрутной роли
  String get aprRoleText {
    String sRoleText;

    switch (aprRole) {
      case "E":
        sRoleText = "Исполнитель";
        break;
      case "P":
        sRoleText = "Отв. исполнитель";
        break;
      case "C":
        sRoleText = "Контролер";
        break;
      default:
        sRoleText = "";
        break;
    }

    return sRoleText;
  }

  /// ФИО исполнителя для поручения(для таблицы комментариев исполнителей)
  String get execNameTextResp {
    if (aprRole == "P")
      return aprNameText + " (отв.)";
    else
      return aprNameText;
  }

  /// <summary>
  /// Конструктор, инициализацуия полей
  /// </summary>
  RouteTableItem() : super() {
    procDT = emptyDate;
    aprNameText = "";
    aprPodrText = "";
    aprStatus = "";
    routeNote = "";
    noteDT = emptyDate;
    execNameText = "";
    execPodrText = "";
    aprRole = "";
    rcvdDT = emptyDate;
    aprSubst = "";
    tableName = "ApproveTable";
  }

  /// <summary>
  /// Отображение данных класса в текстовом виде
  /// </summary>
  /// <returns>Возвращает значение полей ключа РК, номер строки согласования и ФИО согласующего</returns>
  @override
  String toString() {
    return super.toString() + "[$recNr][$aprNameText $aprPodrText]";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'logsys': logsys,
      'dokar': dokar,
      'doknr': doknr,
      'dokvr': dokvr,
      'doktl': doktl,
      'aprnr': recNr,
      'procDT': procDT.millisecondsSinceEpoch,
      'routeNote': routeNote,
      'aprNameText': aprNameText,
      'aprPodrText': aprPodrText,
      'aprStatus': aprStatus,
      'noteDT': noteDT.millisecondsSinceEpoch,
      'execNameText': execNameText,
      'execPodrText': execPodrText,
      'aprRole': aprRole,
      'wfItem': wfItem,
      'rcvdDT': rcvdDT.millisecondsSinceEpoch,
      'aprSubst': aprSubst
    };
    return map;
  }
}
